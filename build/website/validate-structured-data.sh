#!/bin/bash

# TEDxBreckenridge Structured Data Validation Script
# Validates that Event schema.org JSON-LD includes all required fields for Google Rich Results

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SITE_DIR="${REPO_ROOT}/_site"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "========================================="
echo "Validating Event Structured Data"
echo "========================================="
echo ""

ERRORS=0
CHECKED=0

# Function to validate a single event page
validate_event_page() {
    local file="$1"
    local relative_path="${file#$SITE_DIR/}"
    local has_error=0

    # Check if file contains Event structured data
    if ! grep -q '"@type"[[:space:]]*:[[:space:]]*"Event"' "$file" 2>/dev/null; then
        return 0
    fi

    # Extract the Event JSON-LD block using sed
    local json_ld=$(sed -n '/<script type="application\/ld+json">/,/<\/script>/p' "$file" | grep -A 1000 '"@type"[[:space:]]*:[[:space:]]*"Event"' | head -100)

    if [[ -z "$json_ld" ]]; then
        return 0
    fi

    ((CHECKED++)) || true
    echo "Checking: $relative_path"

    # Check required top-level fields
    for field in "name" "startDate" "endDate" "location" "offers" "image" "description"; do
        if ! echo "$json_ld" | grep -q "\"$field\""; then
            echo -e "  ${RED}✗ Missing required field: $field${NC}"
            has_error=1
        fi
    done

    # Check offers required fields
    if echo "$json_ld" | grep -q '"offers"'; then
        for field in "price" "priceCurrency" "availability" "url"; do
            if ! echo "$json_ld" | grep -q "\"$field\""; then
                echo -e "  ${RED}✗ Missing required field in offers: $field${NC}"
                has_error=1
            fi
        done
    fi

    # Validate startDate format (should be ISO 8601)
    local start_date=$(echo "$json_ld" | grep -o '"startDate"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*"\([^"]*\)"$/\1/' || true)
    if [[ -n "$start_date" ]]; then
        if ! echo "$start_date" | grep -qE '^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}'; then
            echo -e "  ${YELLOW}⚠ startDate may not be in ISO 8601 format: $start_date${NC}"
        fi
    fi

    # Validate endDate format
    local end_date=$(echo "$json_ld" | grep -o '"endDate"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*"\([^"]*\)"$/\1/' || true)
    if [[ -n "$end_date" ]]; then
        if ! echo "$end_date" | grep -qE '^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}'; then
            echo -e "  ${YELLOW}⚠ endDate may not be in ISO 8601 format: $end_date${NC}"
        fi
    fi

    # Validate price is a number
    local price=$(echo "$json_ld" | grep -o '"price"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*"\([^"]*\)"$/\1/' || true)
    if [[ -n "$price" ]]; then
        if ! echo "$price" | grep -qE '^[0-9]+\.?[0-9]*$'; then
            echo -e "  ${YELLOW}⚠ price should be a number: $price${NC}"
        fi
    fi

    # Validate availability is a valid schema.org value
    local availability=$(echo "$json_ld" | grep -o '"availability"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*"\([^"]*\)"$/\1/' || true)
    if [[ -n "$availability" ]]; then
        if ! echo "$availability" | grep -qE 'schema.org/(InStock|SoldOut|PreOrder|PreSale|LimitedAvailability|OnlineOnly|Discontinued)'; then
            echo -e "  ${YELLOW}⚠ availability should be a schema.org URL (e.g., https://schema.org/InStock)${NC}"
        fi
    fi

    if [[ $has_error -eq 0 ]]; then
        echo -e "  ${GREEN}✓ All required fields present${NC}"
    else
        ((ERRORS++)) || true
    fi

    return 0
}

# Check if site has been built
if [[ ! -d "$SITE_DIR" ]]; then
    echo -e "${RED}Error: _site directory not found. Run 'bundle exec jekyll build' first.${NC}"
    exit 1
fi

echo "Scanning for Event structured data in: $SITE_DIR/events"
echo ""

# Find all HTML files in the events directory (recursively)
EVENT_PAGES=$(find "$SITE_DIR/events" -name "*.html" -type f 2>/dev/null || true)

if [[ -z "$EVENT_PAGES" ]]; then
    echo -e "${YELLOW}No HTML files found in _site/events/${NC}"
    echo ""
    echo "========================================="
    echo -e "${GREEN}✓ Validation complete (no events to check)${NC}"
    echo "========================================="
    exit 0
fi

# Validate each event page
for page in $EVENT_PAGES; do
    validate_event_page "$page"
done

echo ""
echo "========================================="

if [[ $CHECKED -eq 0 ]]; then
    echo -e "${YELLOW}⚠ No Event structured data found in any pages${NC}"
    echo "========================================="
    exit 0
elif [[ $ERRORS -gt 0 ]]; then
    echo -e "${RED}✗ $ERRORS of $CHECKED event page(s) have missing required fields${NC}"
    echo "========================================="
    exit 1
else
    echo -e "${GREEN}✓ All $CHECKED event page(s) have valid structured data${NC}"
    echo "========================================="
    exit 0
fi
