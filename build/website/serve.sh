#!/bin/bash

# TEDxBreckenridge Jekyll Development Server
# Starts the Jekyll server for local development

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SITE_DIR="$REPO_ROOT"

echo "========================================"
echo "Starting Jekyll server"
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

# Start Jekyll with live reload using dev config for localhost URLs
mise exec -- bundle exec jekyll serve --livereload --config _config.yml,_config.dev.yml
