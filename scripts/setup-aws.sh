#!/bin/bash

# TEDxBreckenridge AWS Infrastructure Setup
# Creates S3 bucket and CloudFront distribution for a specific year

set -e

YEAR=$1
AWS_PROFILE=${AWS_PROFILE:-default}
AWS_REGION=${AWS_REGION:-us-east-1}
S3_BUCKET="tedxbreckenridge-${YEAR}"

if [ -z "$YEAR" ]; then
  echo "Usage: ./scripts/setup-aws.sh <year>"
  echo "Example: ./scripts/setup-aws.sh 2026"
  echo ""
  echo "Environment Variables:"
  echo "  AWS_PROFILE: AWS CLI profile to use (default: default)"
  echo "  AWS_REGION: AWS region (default: us-east-1)"
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
if aws s3 ls "s3://${S3_BUCKET}" --profile "$AWS_PROFILE" &> /dev/null; then
  echo "✓ Bucket already exists: s3://${S3_BUCKET}"
else
  if [ "$AWS_REGION" = "us-east-1" ]; then
    aws s3 mb "s3://${S3_BUCKET}" --profile "$AWS_PROFILE"
  else
    aws s3 mb "s3://${S3_BUCKET}" --region "$AWS_REGION" --profile "$AWS_PROFILE"
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

# Get website endpoint
WEBSITE_ENDPOINT=$(aws s3api get-bucket-website \
  --bucket "$S3_BUCKET" \
  --profile "$AWS_PROFILE" \
  --query '[WebsiteConfiguration.IndexDocument.Suffix]' \
  --output text 2>/dev/null || echo "index.html")

echo ""
echo "========================================"
echo "CloudFront Distribution Setup"
echo "========================================"
echo ""
echo "To create a CloudFront distribution:"
echo ""
echo "1. Go to AWS CloudFront Console"
echo "2. Create a new distribution with these settings:"
echo "   - Origin Domain: ${S3_BUCKET}.s3-website-${AWS_REGION}.amazonaws.com"
echo "   - Origin Protocol: HTTP only"
echo "   - Viewer Protocol: Redirect HTTP to HTTPS"
echo "   - Compress Objects: Yes"
echo "   - Price Class: Use All Edge Locations (or your preference)"
echo "   - Alternate Domain Names (CNAMEs): your-domain.com"
echo "   - SSL Certificate: Request or import certificate"
echo ""
echo "3. After creation, note the Distribution ID and add it to your deploy script:"
echo "   export CLOUDFRONT_DISTRIBUTION_ID=<your-distribution-id>"
echo ""
echo "========================================"
echo "✓ S3 Setup Complete!"
echo "========================================"
echo ""
echo "Website URL: http://${S3_BUCKET}.s3-website-${AWS_REGION}.amazonaws.com"
echo ""
echo "Next steps:"
echo "1. Deploy your site: ./scripts/deploy.sh $YEAR"
echo "2. Set up CloudFront distribution (see instructions above)"
echo "3. Configure custom domain in Route 53 (optional)"
echo ""
