#!/bin/bash

# TEDxBreckenridge Build Script
# Builds a specific year's Jekyll site

set -e

YEAR=$1

if [ -z "$YEAR" ]; then
  echo "Usage: ./scripts/build.sh <year>"
  echo "Example: ./scripts/build.sh 2026"
  exit 1
fi

SITE_DIR="${YEAR}"

if [ ! -d "$SITE_DIR" ]; then
  echo "Error: Directory $SITE_DIR does not exist"
  exit 1
fi

echo "====================================="
echo "Building TEDxBreckenridge $YEAR site"
echo "====================================="

cd "$SITE_DIR"

# Check if Gemfile exists
if [ ! -f "Gemfile" ]; then
  echo "Error: Gemfile not found in $SITE_DIR"
  exit 1
fi

# Install dependencies
echo "Installing dependencies..."
mise exec -- bundle install

# Build the site
echo "Building Jekyll site..."
JEKYLL_ENV=production mise exec -- bundle exec jekyll build

echo ""
echo "✓ Build complete!"
echo "Site generated in: $SITE_DIR/_site"
echo ""
