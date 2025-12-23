#!/bin/bash

# TEDxBreckenridge Deployment Script
# Builds and deploys a specific year's site to AWS S3 + CloudFront

set -e

YEAR=$1
AWS_PROFILE=${AWS_PROFILE:-default}
S3_BUCKET="tedxbreckenridge-${YEAR}"
CLOUDFRONT_DISTRIBUTION_ID=""  # Set this or pass as environment variable

if [ -z "$YEAR" ]; then
  echo "Usage: ./scripts/deploy.sh <year>"
  echo "Example: ./scripts/deploy.sh 2026"
  echo ""
  echo "Environment Variables:"
  echo "  AWS_PROFILE: AWS CLI profile to use (default: default)"
  echo "  CLOUDFRONT_DISTRIBUTION_ID: CloudFront distribution ID for cache invalidation"
  echo "  S3_BUCKET_OVERRIDE: Override the default S3 bucket name"
  exit 1
fi

# Allow bucket override via environment variable
if [ -n "$S3_BUCKET_OVERRIDE" ]; then
  S3_BUCKET="$S3_BUCKET_OVERRIDE"
fi

SITE_DIR="${YEAR}"
BUILD_DIR="${SITE_DIR}/_site"

if [ ! -d "$SITE_DIR" ]; then
  echo "Error: Directory $SITE_DIR does not exist"
  exit 1
fi

echo "========================================"
echo "Deploying TEDxBreckenridge $YEAR"
echo "========================================"
echo "S3 Bucket: $S3_BUCKET"
echo "AWS Profile: $AWS_PROFILE"
echo ""

# Build the site
echo "Step 1: Building site..."
./scripts/build.sh "$YEAR"

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
  echo "Error: AWS CLI is not installed"
  echo "Install it with: brew install awscli"
  exit 1
fi

# Verify S3 bucket exists
echo ""
echo "Step 2: Verifying S3 bucket..."
if ! aws s3 ls "s3://${S3_BUCKET}" --profile "$AWS_PROFILE" &> /dev/null; then
  echo "Warning: S3 bucket s3://${S3_BUCKET} does not exist or is not accessible"
  echo "Creating bucket..."
  aws s3 mb "s3://${S3_BUCKET}" --profile "$AWS_PROFILE"

  # Configure bucket for static website hosting
  aws s3 website "s3://${S3_BUCKET}" \
    --index-document index.html \
    --error-document 404.html \
    --profile "$AWS_PROFILE"

  echo "✓ Bucket created and configured for static website hosting"
fi

# Sync to S3
echo ""
echo "Step 3: Uploading to S3..."
aws s3 sync "$BUILD_DIR" "s3://${S3_BUCKET}" \
  --profile "$AWS_PROFILE" \
  --delete \
  --cache-control "public, max-age=3600" \
  --exclude "*.DS_Store"

echo "✓ Files uploaded to S3"

# Invalidate CloudFront cache
if [ -n "$CLOUDFRONT_DISTRIBUTION_ID" ]; then
  echo ""
  echo "Step 4: Invalidating CloudFront cache..."
  INVALIDATION_ID=$(aws cloudfront create-invalidation \
    --distribution-id "$CLOUDFRONT_DISTRIBUTION_ID" \
    --paths "/*" \
    --profile "$AWS_PROFILE" \
    --query 'Invalidation.Id' \
    --output text)

  echo "✓ CloudFront invalidation created: $INVALIDATION_ID"
  echo "  Cache invalidation may take a few minutes to complete"
else
  echo ""
  echo "Note: CLOUDFRONT_DISTRIBUTION_ID not set, skipping cache invalidation"
  echo "Set it in the script or as an environment variable for automatic invalidation"
fi

echo ""
echo "========================================"
echo "✓ Deployment complete!"
echo "========================================"
echo "Site URL: http://${S3_BUCKET}.s3-website-us-east-1.amazonaws.com"
if [ -n "$CLOUDFRONT_DISTRIBUTION_ID" ]; then
  echo "CloudFront URL: (configure in CloudFront console)"
fi
echo ""
