#!/bin/bash

# TEDxBreckenridge Jekyll Development Server
# Starts the Jekyll server for a specific year

set -e

YEAR=${1:-2026}
SITE_DIR="${YEAR}"

if [ ! -d "$SITE_DIR" ]; then
  echo "Error: Directory $SITE_DIR does not exist"
  exit 1
fi

echo "========================================"
echo "Starting Jekyll server for $YEAR"
echo "========================================"
echo ""

cd "$SITE_DIR"

# Check if gems are installed
if [ ! -d "vendor/bundle" ]; then
  echo "Installing dependencies..."
  mise exec -- bundle install
  echo ""
fi

echo "Starting server at http://localhost:4000"
echo "Press Ctrl+C to stop"
echo ""

# Start Jekyll with live reload
mise exec -- bundle exec jekyll serve --livereload
