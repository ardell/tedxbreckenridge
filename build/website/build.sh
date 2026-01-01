#!/bin/bash

# TEDxBreckenridge Website Build Script
# Builds the Jekyll website

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SITE_DIR="$REPO_ROOT"

echo "====================================="
echo "Building TEDxBreckenridge website"
echo "====================================="

cd "$SITE_DIR"

# Check if Gemfile exists
if [ ! -f "Gemfile" ]; then
  echo "Error: Gemfile not found at project root"
  exit 1
fi

# Install dependencies
echo "Installing dependencies..."
mise exec -- bundle install

# Build the site
echo "Building Jekyll site..."
JEKYLL_ENV=production mise exec -- bundle exec jekyll build

echo ""
echo "Build complete!"
echo "Site generated in: _site"
echo ""
