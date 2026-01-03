#!/bin/bash

# TEDxBreckenridge Affiliate Link Validation Script
# Validates that all ticketsauce.com and givebutter.com links include affiliate tracking parameters

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "========================================="
echo "Validating Affiliate Tracking Links"
echo "========================================="
echo ""

ERRORS=0
WARNINGS=0

# Temporary file to track campaign usage
CAMPAIGN_LOG=$(mktemp)
trap "rm -f $CAMPAIGN_LOG" EXIT

# Function to extract utm_campaign from URL
extract_campaign() {
  local url="$1"
  # Handle both normal and URL-encoded formats
  local campaign=""

  # Try normal format first: utm_campaign=value
  campaign=$(echo "$url" | grep -oE 'utm_campaign=[^&]+' | head -1 | sed 's/utm_campaign=//' || true)

  # If not found, try URL-encoded format: utm_campaign%3D
  if [[ -z "$campaign" ]]; then
    campaign=$(echo "$url" | grep -oE 'utm_campaign%3D[^%&]+' | head -1 | sed 's/utm_campaign%3D//' || true)
  fi

  echo "$campaign"
}

# Function to check if a ticketsauce URL has affiliate tracking
check_ticketsauce_tracking() {
  local url="$1"
  local file="$2"
  local line_num="$3"

  # Check for required affiliate parameters (support both normal and URL-encoded formats)
  local has_source=false
  local has_id=false

  if [[ "$url" == *"utm_source=affiliate"* ]] || [[ "$url" == *"utm_source%3Daffiliate"* ]]; then
    has_source=true
  fi

  if [[ "$url" == *"utm_id="* ]] || [[ "$url" == *"utm_id%3D"* ]]; then
    has_id=true
  fi

  if [[ "$has_source" == false ]] || [[ "$has_id" == false ]]; then
    echo -e "${RED}✗ Missing ticketsauce affiliate tracking:${NC}"
    echo "  File: $file:$line_num"
    echo "  URL: $url"
    echo ""
    return 1
  fi

  # Log the campaign for duplicate checking
  local campaign=$(extract_campaign "$url")
  if [[ -n "$campaign" ]]; then
    echo "ticketsauce:${campaign}|${file}:${line_num}" >> "$CAMPAIGN_LOG"
  fi

  return 0
}

# Function to check if a givebutter URL has UTM tracking
check_givebutter_tracking() {
  local url="$1"
  local file="$2"
  local line_num="$3"

  # Check for required UTM parameters (support both normal and URL-encoded formats)
  local has_source=false
  local has_campaign=false

  if [[ "$url" == *"utm_source="* ]] || [[ "$url" == *"utm_source%3D"* ]]; then
    has_source=true
  fi

  if [[ "$url" == *"utm_campaign="* ]] || [[ "$url" == *"utm_campaign%3D"* ]]; then
    has_campaign=true
  fi

  if [[ "$has_source" == false ]] || [[ "$has_campaign" == false ]]; then
    echo -e "${RED}✗ Missing givebutter UTM tracking:${NC}"
    echo "  File: $file:$line_num"
    echo "  URL: $url"
    echo ""
    return 1
  fi

  # Log the campaign for duplicate checking
  local campaign=$(extract_campaign "$url")
  if [[ -n "$campaign" ]]; then
    echo "givebutter:${campaign}|${file}:${line_num}" >> "$CAMPAIGN_LOG"
  fi

  return 0
}

# Check website HTML and Markdown files
echo "Checking website HTML and Markdown files..."
while IFS= read -r file; do
  line_num=0
  while IFS= read -r line; do
    line_num=$((line_num + 1))
    # Look for ticketsauce.com URLs in href attributes
    if [[ "$line" == *"ticketsauce.com"* ]]; then
      # Extract URLs from the line (handles multiple URLs per line)
      urls=$(echo "$line" | grep -oE 'https?://[^"'"'"'<>)]+ticketsauce\.com[^"'"'"'<>)]*' || true)
      for url in $urls; do
        if ! check_ticketsauce_tracking "$url" "$file" "$line_num"; then
          ERRORS=$((ERRORS + 1))
        fi
      done
    fi
    # Look for givebutter.com URLs
    if [[ "$line" == *"givebutter.com"* ]]; then
      urls=$(echo "$line" | grep -oE 'https?://[^"'"'"'<>)]*givebutter\.com[^"'"'"'<>)]*' || true)
      for url in $urls; do
        if ! check_givebutter_tracking "$url" "$file" "$line_num"; then
          ERRORS=$((ERRORS + 1))
        fi
      done
    fi
  done < "$file"
done < <(find "${REPO_ROOT}/website" \( -name "*.html" -o -name "*.md" \) -type f)

# Check Jekyll layouts
echo "Checking Jekyll layouts..."
while IFS= read -r file; do
  line_num=0
  while IFS= read -r line; do
    line_num=$((line_num + 1))
    if [[ "$line" == *"ticketsauce.com"* ]]; then
      urls=$(echo "$line" | grep -oE 'https?://[^"'"'"'<>]+ticketsauce\.com[^"'"'"'<>]*' || true)
      for url in $urls; do
        if ! check_ticketsauce_tracking "$url" "$file" "$line_num"; then
          ERRORS=$((ERRORS + 1))
        fi
      done
    fi
    if [[ "$line" == *"givebutter.com"* ]]; then
      urls=$(echo "$line" | grep -oE 'https?://[^"'"'"'<>]*givebutter\.com[^"'"'"'<>]*' || true)
      for url in $urls; do
        if ! check_givebutter_tracking "$url" "$file" "$line_num"; then
          ERRORS=$((ERRORS + 1))
        fi
      done
    fi
  done < "$file"
done < <(find "${REPO_ROOT}/_layouts" -name "*.html" -type f 2>/dev/null || true)

# Check Jekyll includes
echo "Checking Jekyll includes..."
while IFS= read -r file; do
  line_num=0
  while IFS= read -r line; do
    line_num=$((line_num + 1))
    if [[ "$line" == *"ticketsauce.com"* ]]; then
      urls=$(echo "$line" | grep -oE 'https?://[^"'"'"'<>]+ticketsauce\.com[^"'"'"'<>]*' || true)
      for url in $urls; do
        if ! check_ticketsauce_tracking "$url" "$file" "$line_num"; then
          ERRORS=$((ERRORS + 1))
        fi
      done
    fi
    if [[ "$line" == *"givebutter.com"* ]]; then
      urls=$(echo "$line" | grep -oE 'https?://[^"'"'"'<>]*givebutter\.com[^"'"'"'<>]*' || true)
      for url in $urls; do
        if ! check_givebutter_tracking "$url" "$file" "$line_num"; then
          ERRORS=$((ERRORS + 1))
        fi
      done
    fi
  done < "$file"
done < <(find "${REPO_ROOT}/_includes" -name "*.html" -type f 2>/dev/null || true)

# Check email templates
echo "Checking email templates..."
while IFS= read -r file; do
  line_num=0
  while IFS= read -r line; do
    line_num=$((line_num + 1))
    if [[ "$line" == *"ticketsauce.com"* ]]; then
      urls=$(echo "$line" | grep -oE 'https?://[^"'"'"'<>]+ticketsauce\.com[^"'"'"'<>]*' || true)
      for url in $urls; do
        if ! check_ticketsauce_tracking "$url" "$file" "$line_num"; then
          ERRORS=$((ERRORS + 1))
        fi
      done
    fi
    if [[ "$line" == *"givebutter.com"* ]]; then
      urls=$(echo "$line" | grep -oE 'https?://[^"'"'"'<>]*givebutter\.com[^"'"'"'<>]*' || true)
      for url in $urls; do
        if ! check_givebutter_tracking "$url" "$file" "$line_num"; then
          ERRORS=$((ERRORS + 1))
        fi
      done
    fi
  done < "$file"
done < <(find "${REPO_ROOT}/_emails" -name "*.html" -type f 2>/dev/null || true)

# Check print templates (QR code URLs in comments)
echo "Checking print templates (QR code URLs)..."
while IFS= read -r file; do
  line_num=0
  while IFS= read -r line; do
    line_num=$((line_num + 1))
    if [[ "$line" == *"ticketsauce.com"* ]]; then
      # Extract the ticketsauce URL from within the QR code API URL or directly
      # Allow parentheses and percent-encoded characters in URL
      urls=$(echo "$line" | grep -oE 'https://[a-zA-Z0-9.-]*ticketsauce\.com/[^"'"'"'<> ]*' || true)
      for url in $urls; do
        # Skip if url is empty or just dashes
        [[ -z "$url" || "$url" == "--"* ]] && continue
        if ! check_ticketsauce_tracking "$url" "$file" "$line_num"; then
          ERRORS=$((ERRORS + 1))
        fi
      done
    fi
    if [[ "$line" == *"givebutter.com"* ]]; then
      # Extract the givebutter URL from within the QR code API URL or directly
      urls=$(echo "$line" | grep -oE 'https://[a-zA-Z0-9.-]*givebutter\.com/[^"'"'"'<> ]*' || true)
      for url in $urls; do
        [[ -z "$url" || "$url" == "--"* ]] && continue
        if ! check_givebutter_tracking "$url" "$file" "$line_num"; then
          ERRORS=$((ERRORS + 1))
        fi
      done
    fi
  done < "$file"
done < <(find "${REPO_ROOT}/_print" -name "*.html" -type f 2>/dev/null || true)

# Check for duplicate campaigns
echo ""
echo "Checking for duplicate utm_campaign values..."

# Get unique campaigns and their counts (format is service:campaign|location)
if [[ -s "$CAMPAIGN_LOG" ]]; then
  # Sort and count campaigns (including service prefix)
  while IFS= read -r service_campaign; do
    count=$(grep -c "^${service_campaign}|" "$CAMPAIGN_LOG" || true)
    # Extract just the campaign name for display
    display_campaign=$(echo "$service_campaign" | sed 's/^[^:]*://')
    service=$(echo "$service_campaign" | sed 's/:.*//')
    if [[ $count -gt 3 ]]; then
      echo -e "${RED}✗ utm_campaign '${display_campaign}' (${service}) used ${count} times (max 3):${NC}"
      grep "^${service_campaign}|" "$CAMPAIGN_LOG" | while IFS='|' read -r _ location; do
        echo "    - $location"
      done
      echo ""
      ERRORS=$((ERRORS + 1))
    elif [[ $count -gt 1 ]]; then
      echo -e "${YELLOW}⚠ utm_campaign '${display_campaign}' (${service}) used ${count} times:${NC}"
      grep "^${service_campaign}|" "$CAMPAIGN_LOG" | while IFS='|' read -r _ location; do
        echo "    - $location"
      done
      echo ""
      WARNINGS=$((WARNINGS + 1))
    fi
  done < <(cut -d'|' -f1 "$CAMPAIGN_LOG" | sort -u)
fi

# Summary
echo ""
echo "========================================="
if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
  echo -e "${GREEN}✓ All ticketsauce.com links have affiliate tracking!${NC}"
  echo -e "${GREEN}✓ All givebutter.com links have UTM tracking!${NC}"
  echo -e "${GREEN}✓ All utm_campaign values are unique!${NC}"
  echo "========================================="
  exit 0
elif [ $ERRORS -eq 0 ]; then
  echo -e "${GREEN}✓ All ticketsauce.com links have affiliate tracking!${NC}"
  echo -e "${GREEN}✓ All givebutter.com links have UTM tracking!${NC}"
  echo -e "${YELLOW}⚠ ${WARNINGS} utm_campaign value(s) used multiple times${NC}"
  echo "========================================="
  echo ""
  echo "Consider using unique utm_campaign values for better tracking."
  echo ""
  exit 0
else
  echo -e "${RED}✗ ${ERRORS} error(s)${NC}"
  if [ $WARNINGS -gt 0 ]; then
    echo -e "${YELLOW}⚠ ${WARNINGS} warning(s)${NC}"
  fi
  echo "========================================="
  echo ""
  echo "All ticketsauce.com links must include:"
  echo "  - utm_source=affiliate"
  echo "  - utm_id=<affiliate_id>"
  echo ""
  echo "All givebutter.com links must include:"
  echo "  - utm_source=<source>"
  echo "  - utm_campaign=<campaign>"
  echo ""
  echo "Each utm_campaign should be unique (max 3 uses per campaign)."
  echo ""
  echo "Examples:"
  echo "  https://tedxbreckenridge.ticketsauce.com/e/event-name?utm_source=affiliate&utm_name=tedxbreckenridge.com&utm_campaign=homepage&utm_id=695827faa4044dcbae486ce50a1e63a3"
  echo "  https://givebutter.com/tedxbreckenridge?utm_source=website&utm_campaign=tedxbreckenridge.com-homepage-donate"
  echo ""
  exit 1
fi
