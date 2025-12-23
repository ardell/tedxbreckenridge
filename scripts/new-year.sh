#!/bin/bash

# TEDxBreckenridge New Year Setup Script
# Creates a new year's site based on the previous year

set -e

NEW_YEAR=$1
PREVIOUS_YEAR=$2

if [ -z "$NEW_YEAR" ]; then
  echo "Usage: ./scripts/new-year.sh <new-year> [previous-year]"
  echo "Example: ./scripts/new-year.sh 2027 2026"
  echo ""
  echo "If previous year is not specified, the most recent year will be used."
  exit 1
fi

# Find the most recent year if not specified
if [ -z "$PREVIOUS_YEAR" ]; then
  PREVIOUS_YEAR=$(ls -d [0-9][0-9][0-9][0-9] 2>/dev/null | sort -r | head -n 1)
  if [ -z "$PREVIOUS_YEAR" ]; then
    echo "Error: No previous year found. Please specify a previous year."
    exit 1
  fi
  echo "Using previous year: $PREVIOUS_YEAR"
fi

if [ ! -d "$PREVIOUS_YEAR" ]; then
  echo "Error: Previous year directory $PREVIOUS_YEAR does not exist"
  exit 1
fi

if [ -d "$NEW_YEAR" ]; then
  echo "Error: Directory $NEW_YEAR already exists"
  exit 1
fi

echo "========================================"
echo "Creating TEDxBreckenridge $NEW_YEAR"
echo "Based on: $PREVIOUS_YEAR"
echo "========================================"
echo ""

# Copy the previous year's structure
echo "Step 1: Copying site structure..."
cp -r "$PREVIOUS_YEAR" "$NEW_YEAR"
echo "✓ Structure copied"

# Clean up build artifacts
echo ""
echo "Step 2: Cleaning build artifacts..."
rm -rf "${NEW_YEAR}/_site"
rm -rf "${NEW_YEAR}/.jekyll-cache"
rm -f "${NEW_YEAR}/Gemfile.lock"
rm -rf "${NEW_YEAR}/.sass-cache"
echo "✓ Build artifacts cleaned"

# Clear content directories
echo ""
echo "Step 3: Clearing old content..."
rm -rf "${NEW_YEAR}/_speakers"/*
rm -rf "${NEW_YEAR}/_team"/*
mkdir -p "${NEW_YEAR}/_speakers"
mkdir -p "${NEW_YEAR}/_team"
echo "✓ Content directories cleared"

# Update config file
echo ""
echo "Step 4: Updating configuration..."
sed -i.bak "s/${PREVIOUS_YEAR}/${NEW_YEAR}/g" "${NEW_YEAR}/_config.yml"
sed -i.bak "s/title: TEDxBreckenridge ${PREVIOUS_YEAR}/title: TEDxBreckenridge ${NEW_YEAR}/g" "${NEW_YEAR}/_config.yml"
rm "${NEW_YEAR}/_config.yml.bak"
echo "✓ Configuration updated"

# Update README
echo ""
echo "Step 5: Updating README..."
sed -i.bak "s/${PREVIOUS_YEAR}/${NEW_YEAR}/g" "${NEW_YEAR}/README.md"
sed -i.bak "s/# TEDxBreckenridge ${PREVIOUS_YEAR}/# TEDxBreckenridge ${NEW_YEAR}/g" "${NEW_YEAR}/README.md"
rm "${NEW_YEAR}/README.md.bak"
echo "✓ README updated"

# Update style guide
echo ""
echo "Step 6: Resetting style guide..."
cat > "${NEW_YEAR}/style-guide/README.md" <<EOF
# TEDxBreckenridge ${NEW_YEAR} Style Guide

This directory contains the design system and style guide for the ${NEW_YEAR} event.

## Theme

**To be determined** - Define the ${NEW_YEAR} event theme here.

## TODO for ${NEW_YEAR} Theme

- [ ] Define event theme
- [ ] Choose color palette
- [ ] Select typography
- [ ] Design event logo
- [ ] Create brand assets
- [ ] Update CSS variables in assets/css/main.css
- [ ] Add hero images and photography

## Updating Styles

1. Update color variables in \`assets/css/main.css\`
2. Add logos to \`style-guide/logos/\`
3. Add images to \`style-guide/images/\`
4. Update this README with final style guide

## Brand Colors

### Primary Colors
- **TED Red**: \`#e62b1e\` - Official TED brand color (required by license)

### ${NEW_YEAR} Theme Colors
- Primary: \`#______\` (update this)
- Secondary: \`#______\` (update this)
- Accent: \`#______\` (update this)

See the [${PREVIOUS_YEAR} style guide](../../${PREVIOUS_YEAR}/style-guide/README.md) for reference.
EOF

echo "✓ Style guide reset for new year"

echo ""
echo "========================================"
echo "✓ New Year Setup Complete!"
echo "========================================"
echo ""
echo "Created: $NEW_YEAR/"
echo ""
echo "Next steps:"
echo "1. cd $NEW_YEAR"
echo "2. Update _config.yml with event details (date, venue, theme)"
echo "3. Review and update style-guide/README.md with theme details"
echo "4. Customize assets/css/main.css with new colors/styles"
echo "5. Add event-specific content (speakers, schedule, etc.)"
echo "6. Run: bundle install"
echo "7. Test locally: bundle exec jekyll serve"
echo ""
