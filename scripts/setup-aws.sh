#!/bin/bash

# TEDxBreckenridge AWS Infrastructure Setup
# Creates S3 bucket for static website hosting
#
# NOTE: This script is now simplified. For full-featured setup with SSO validation,
# versioning, and proper tagging, use: ./scripts/aws/setup-bucket.sh

set -e

YEAR=$1
AWS_PROFILE=${AWS_PROFILE:-default}
AWS_REGION=${AWS_REGION:-us-west-1}
S3_BUCKET="tedxbreckenridge-${YEAR}"

if [ -z "$YEAR" ]; then
  echo "Usage: ./scripts/setup-aws.sh <year>"
  echo "Example: ./scripts/setup-aws.sh 2026"
  echo ""
  echo "For full-featured setup with SSO, use:"
  echo "  ./scripts/aws/setup-bucket.sh <year>"
  echo ""
  echo "Environment Variables:"
  echo "  AWS_PROFILE: AWS CLI profile to use (default: default)"
  echo "  AWS_REGION: AWS region (default: us-west-1)"
  exit 1
fi

echo "========================================"
echo "AWS Infrastructure Setup"
echo "TEDxBreckenridge $YEAR"
echo "========================================"
echo "S3 Bucket: $S3_BUCKET"
echo "AWS Region: $AWS_REGION"
echo "AWS Profile: $AWS_PROFILE"
echo ""

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
  echo "Error: AWS CLI is not installed"
  echo "Install it with: brew install awscli"
  exit 1
fi

# Create S3 bucket
echo "Step 1: Creating S3 bucket..."
if aws s3 ls "s3://${S3_BUCKET}" --profile "$AWS_PROFILE" --region "$AWS_REGION" &> /dev/null; then
  echo "✓ Bucket already exists: s3://${S3_BUCKET}"
else
  # For us-east-1, don't specify LocationConstraint; for other regions, specify it
  if [ "$AWS_REGION" = "us-east-1" ]; then
    aws s3api create-bucket \
      --bucket "$S3_BUCKET" \
      --profile "$AWS_PROFILE"
  else
    aws s3api create-bucket \
      --bucket "$S3_BUCKET" \
      --region "$AWS_REGION" \
      --create-bucket-configuration LocationConstraint="$AWS_REGION" \
      --profile "$AWS_PROFILE"
  fi
  echo "✓ Bucket created: s3://${S3_BUCKET}"
fi

# Configure bucket for static website hosting
echo ""
echo "Step 2: Configuring static website hosting..."
aws s3 website "s3://${S3_BUCKET}" \
  --index-document index.html \
  --error-document 404.html \
  --profile "$AWS_PROFILE"

echo "✓ Static website hosting configured"

# Set bucket policy for public read
echo ""
echo "Step 3: Setting bucket policy for public access..."
cat > /tmp/bucket-policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${S3_BUCKET}/*"
    }
  ]
}
EOF

aws s3api put-bucket-policy \
  --bucket "$S3_BUCKET" \
  --policy file:///tmp/bucket-policy.json \
  --profile "$AWS_PROFILE"

rm /tmp/bucket-policy.json
echo "✓ Bucket policy applied"

echo ""
echo "========================================"
echo "✓ S3 Setup Complete!"
echo "========================================"
echo ""
echo "Bucket: s3://${S3_BUCKET}"
echo "Region: ${AWS_REGION}"
echo "Website URL: http://${S3_BUCKET}.s3-website-${AWS_REGION}.amazonaws.com"
echo ""
echo "Next steps:"
echo "1. Deploy your site: ./scripts/deploy.sh $YEAR"
echo "2. Access your site at the URL above"
echo ""
echo "Note: For production setup with versioning, SSO, and proper tagging,"
echo "      use: ./scripts/aws/setup-bucket.sh $YEAR"
echo ""
