#!/bin/bash

# TEDxBreckenridge QR Code Validation Script
# Validates that all QR code images have proper documentation comments

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "========================================="
echo "Validating QR Code Documentation"
echo "========================================="
echo ""

ERRORS=0

# Function to check if a QR code image has proper comments
check_qr_comments() {
  local file="$1"
  local line_num="$2"
  local img_line="$3"

  # Read up to 5 lines before the img tag (to handle wrapper divs)
  local context=""
  local start_line=$((line_num - 5))
  if [[ $start_line -lt 1 ]]; then
    start_line=1
  fi
  context=$(sed -n "${start_line},$((line_num - 1))p" "$file")

  # Check for "QR code for:" comment
  local has_url_comment=false
  if [[ "$context" == *"<!-- QR code for:"* ]]; then
    has_url_comment=true
  fi

  # Check for "Generate at:" comment
  local has_generate_comment=false
  if [[ "$context" == *"<!-- Generate at:"* ]]; then
    has_generate_comment=true
  fi

  if [[ "$has_url_comment" == false ]] || [[ "$has_generate_comment" == false ]]; then
    echo -e "${RED}✗ Missing QR code documentation:${NC}"
    echo "  File: $file:$line_num"

    # Extract just the src for display
    local src=$(echo "$img_line" | grep -oE 'src="[^"]*"' | head -1)
    echo "  Image: $src"

    if [[ "$has_url_comment" == false ]]; then
      echo "  Missing: <!-- QR code for: [URL] -->"
    fi
    if [[ "$has_generate_comment" == false ]]; then
      echo "  Missing: <!-- Generate at: [generator URL] -->"
    fi
    echo ""
    return 1
  fi

  return 0
}

# Check print templates for QR code images
echo "Checking print templates for QR code images..."
if [[ -d "${REPO_ROOT}/_print" ]]; then
  while IFS= read -r file; do
    line_num=0
    while IFS= read -r line; do
      line_num=$((line_num + 1))
      # Look for img tags in qr-code directories or with qr-code class
      if [[ "$line" == *"qr-codes/"* ]] || [[ "$line" == *"qr-code"* && "$line" == *"<img"* ]]; then
        # Make sure it's an img tag with a qr-code image
        if [[ "$line" == *"<img"* ]] && [[ "$line" == *"src="* ]]; then
          if ! check_qr_comments "$file" "$line_num" "$line"; then
            ERRORS=$((ERRORS + 1))
          fi
        fi
      fi
    done < "$file"
  done < <(find "${REPO_ROOT}/_print" -name "*.html" -type f 2>/dev/null)
fi

# Check website for QR code images
echo "Checking website for QR code images..."
while IFS= read -r file; do
  line_num=0
  while IFS= read -r line; do
    line_num=$((line_num + 1))
    # Look for img tags referencing qr-codes directory
    if [[ "$line" == *"qr-codes/"* ]] && [[ "$line" == *"<img"* ]] && [[ "$line" == *"src="* ]]; then
      if ! check_qr_comments "$file" "$line_num" "$line"; then
        ERRORS=$((ERRORS + 1))
      fi
    fi
  done < "$file"
done < <(find "${REPO_ROOT}/website" -name "*.html" -type f 2>/dev/null)

# Check email templates for QR code images
echo "Checking email templates for QR code images..."
if [[ -d "${REPO_ROOT}/_emails" ]]; then
  while IFS= read -r file; do
    line_num=0
    while IFS= read -r line; do
      line_num=$((line_num + 1))
      # Look for img tags referencing qr-codes directory
      if [[ "$line" == *"qr-codes/"* ]] && [[ "$line" == *"<img"* ]] && [[ "$line" == *"src="* ]]; then
        if ! check_qr_comments "$file" "$line_num" "$line"; then
          ERRORS=$((ERRORS + 1))
        fi
      fi
    done < "$file"
  done < <(find "${REPO_ROOT}/_emails" -name "*.html" -type f 2>/dev/null)
fi

# Summary
echo ""
echo "========================================="
if [ $ERRORS -eq 0 ]; then
  echo -e "${GREEN}✓ All QR code images have proper documentation!${NC}"
  echo "========================================="
  exit 0
else
  echo -e "${RED}✗ ${ERRORS} QR code(s) missing documentation${NC}"
  echo "========================================="
  echo ""
  echo "Each QR code image must have two comments above it:"
  echo "  <!-- QR code for: [human-readable URL] -->"
  echo "  <!-- Generate at: [QR generator API URL] -->"
  echo ""
  echo "Example:"
  echo "  <!-- QR code for: https://givebutter.com/tedxbreckenridge?utm_source=print&utm_campaign=example -->"
  echo "  <!-- Generate at: https://api.qrserver.com/v1/create-qr-code/?size=510x510&data=https://givebutter.com/tedxbreckenridge?utm_source=print%26utm_campaign=example -->"
  echo "  <img src=\"/assets/images/qr-codes/example.png\" alt=\"Description\">"
  echo ""
  exit 1
fi
