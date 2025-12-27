#!/bin/bash

# TEDxBreckenridge Image Validation Script
# Validates that images meet size requirements from CLAUDE.md

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
IMAGES_DIR="${REPO_ROOT}/website/assets/images"

# Size limits (in KB)
HERO_MAX_KB=500
THUMBNAIL_MAX_KB=150
GENERAL_MAX_KB=500

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "========================================="
echo "Validating Image Sizes"
echo "========================================="
echo ""
echo "Image directory: ${IMAGES_DIR}"
echo "Hero image limit: ${HERO_MAX_KB} KB"
echo "Thumbnail limit: ${THUMBNAIL_MAX_KB} KB"
echo "General limit: ${GENERAL_MAX_KB} KB"
echo ""

ERRORS=0
WARNINGS=0

# Check hero images
echo "Checking hero images..."
if [ -d "${IMAGES_DIR}/heroes" ]; then
  while IFS= read -r -d '' file; do
    SIZE_KB=$(du -k "$file" | cut -f1)
    if [ "$SIZE_KB" -gt "$HERO_MAX_KB" ]; then
      echo -e "${RED}✗ $(basename "$file"): ${SIZE_KB} KB (exceeds ${HERO_MAX_KB} KB)${NC}"
      ERRORS=$((ERRORS + 1))
    else
      echo -e "${GREEN}✓ $(basename "$file"): ${SIZE_KB} KB${NC}"
    fi
  done < <(find "${IMAGES_DIR}/heroes" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) -print0)
fi

# Check speaker/team thumbnails (recommended 100KB, hard limit 500KB)
echo ""
echo "Checking team/speaker images..."
for dir in "speakers" "team"; do
  if [ -d "${IMAGES_DIR}/${dir}" ]; then
    while IFS= read -r -d '' file; do
      SIZE_KB=$(du -k "$file" | cut -f1)
      if [ "$SIZE_KB" -gt "$GENERAL_MAX_KB" ]; then
        echo -e "${RED}✗ ${dir}/$(basename "$file"): ${SIZE_KB} KB (exceeds ${GENERAL_MAX_KB} KB)${NC}"
        ERRORS=$((ERRORS + 1))
      elif [ "$SIZE_KB" -gt "$THUMBNAIL_MAX_KB" ]; then
        echo -e "${YELLOW}⚠ ${dir}/$(basename "$file"): ${SIZE_KB} KB (recommended <${THUMBNAIL_MAX_KB} KB)${NC}"
        WARNINGS=$((WARNINGS + 1))
      else
        echo -e "${GREEN}✓ ${dir}/$(basename "$file"): ${SIZE_KB} KB${NC}"
      fi
    done < <(find "${IMAGES_DIR}/${dir}" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) -print0)
  fi
done

# Check blog images
echo ""
echo "Checking blog images..."
if [ -d "${IMAGES_DIR}/blog" ]; then
  while IFS= read -r -d '' file; do
    SIZE_KB=$(du -k "$file" | cut -f1)
    if [ "$SIZE_KB" -gt "$GENERAL_MAX_KB" ]; then
      echo -e "${RED}✗ blog/$(basename "$file"): ${SIZE_KB} KB (exceeds ${GENERAL_MAX_KB} KB)${NC}"
      ERRORS=$((ERRORS + 1))
    else
      echo -e "${GREEN}✓ blog/$(basename "$file"): ${SIZE_KB} KB${NC}"
    fi
  done < <(find "${IMAGES_DIR}/blog" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) -print0)
fi

# Check event images
echo ""
echo "Checking event images..."
if [ -d "${IMAGES_DIR}/events" ]; then
  while IFS= read -r -d '' file; do
    SIZE_KB=$(du -k "$file" | cut -f1)
    if [ "$SIZE_KB" -gt "$GENERAL_MAX_KB" ]; then
      echo -e "${RED}✗ events/$(basename "$file"): ${SIZE_KB} KB (exceeds ${GENERAL_MAX_KB} KB)${NC}"
      ERRORS=$((ERRORS + 1))
    else
      echo -e "${GREEN}✓ events/$(basename "$file"): ${SIZE_KB} KB${NC}"
    fi
  done < <(find "${IMAGES_DIR}/events" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) -print0)
fi

# Summary
echo ""
echo "========================================="
if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
  echo -e "${GREEN}✓ All images pass validation!${NC}"
  echo "========================================="
  exit 0
elif [ $ERRORS -eq 0 ]; then
  echo -e "${YELLOW}⚠ ${WARNINGS} warning(s)${NC}"
  echo "Some images exceed recommended sizes but are acceptable."
  echo "Consider optimizing for better performance."
  echo "========================================="
  exit 0
else
  echo -e "${RED}✗ ${ERRORS} error(s), ${WARNINGS} warning(s)${NC}"
  echo "========================================="
  echo ""
  echo "To optimize images:"
  echo "  - JPEG: Use mozjpeg or similar (quality 85)"
  echo "  - PNG: Use pngquant or similar"
  echo "  - Consider WebP with fallbacks"
  echo ""
  exit 1
fi
