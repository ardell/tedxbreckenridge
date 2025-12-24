#!/bin/bash

# TEDxBreckenridge Deployment Script
# Builds and deploys the website to AWS S3

set -e

# Get script directory for loading configs
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Load infrastructure config if available
if [ -f "${SCRIPT_DIR}/../aws/config/infrastructure.conf" ]; then
    source "${SCRIPT_DIR}/../aws/config/infrastructure.conf"
fi

# Set defaults (can be overridden by config files or environment variables)
AWS_REGION=${AWS_REGION:-us-west-1}
AWS_PROFILE=${AWS_PROFILE:-${AWS_SSO_PROFILE:-tedxbreckenridge}}
S3_BUCKET=${S3_BUCKET:-"tedxbreckenridge-2026"}

SITE_DIR="$REPO_ROOT/website"
BUILD_DIR="${SITE_DIR}/_site"

if [ ! -d "$SITE_DIR" ]; then
  echo "Error: Directory website/ does not exist"
  exit 1
fi

echo "========================================"
echo "Deploying TEDxBreckenridge Website"
echo "========================================"
echo "S3 Bucket: $S3_BUCKET"
echo "AWS Region: $AWS_REGION"
echo "AWS Profile: $AWS_PROFILE"
echo ""

# Validate AWS SSO session if using SSO profile
if [ "$AWS_PROFILE" = "tedxbreckenridge" ] || [ "$AWS_PROFILE" = "$AWS_SSO_PROFILE" ]; then
  if [ -f "${SCRIPT_DIR}/../aws/validate-sso.sh" ]; then
    "${SCRIPT_DIR}/../aws/validate-sso.sh" || exit 1
  fi
fi

# Build the site
echo "Step 1: Building site..."
"${SCRIPT_DIR}/build.sh"

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
  echo "Error: AWS CLI is not installed"
  echo "Install it with: brew install awscli"
  exit 1
fi

# Verify S3 bucket exists
echo ""
echo "Step 2: Verifying S3 bucket..."
if ! aws s3 ls "s3://${S3_BUCKET}" --profile "$AWS_PROFILE" --region "$AWS_REGION" &> /dev/null; then
  echo "Warning: S3 bucket s3://${S3_BUCKET} does not exist or is not accessible"
  echo ""
  echo "Please create the bucket first using:"
  echo "  ./build/aws/setup-bucket.sh"
  echo ""
  echo "Or create it manually with proper configuration (static website hosting, public read policy, versioning)"
  exit 1
fi

# Sync to S3
echo ""
echo "Step 3: Uploading to S3..."
aws s3 sync "$BUILD_DIR" "s3://${S3_BUCKET}" \
  --profile "$AWS_PROFILE" \
  --region "$AWS_REGION" \
  --delete \
  --cache-control "public, max-age=3600" \
  --exclude "*.DS_Store"

echo "✓ Files uploaded to S3"

echo ""
echo "========================================"
echo "✓ Deployment complete!"
echo "========================================"
echo "S3 Bucket: s3://${S3_BUCKET}"
echo "Website URL: http://${S3_BUCKET}.s3-website-${AWS_REGION}.amazonaws.com"
if [ -n "$WEBSITE_URL" ]; then
  echo "            ${WEBSITE_URL}"
fi
echo ""
echo "Note: It may take a few moments for changes to be visible"
echo ""
