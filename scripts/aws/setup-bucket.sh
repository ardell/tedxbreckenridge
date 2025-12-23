#!/bin/bash

# TEDxBreckenridge S3 Bucket Setup Script
# Creates and configures S3 bucket for static website hosting

set -e

# Get year argument
YEAR=${1}

if [ -z "$YEAR" ]; then
    echo "Usage: $0 <year>"
    echo "Example: $0 2026"
    exit 1
fi

# Load configurations
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/config/infrastructure.conf"

YEAR_CONFIG="${SCRIPT_DIR}/config/${YEAR}.conf"
if [ ! -f "$YEAR_CONFIG" ]; then
    echo "Error: Configuration file not found: $YEAR_CONFIG"
    echo "Please create a configuration file for year ${YEAR}"
    exit 1
fi

source "$YEAR_CONFIG"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "========================================="
echo "Setting up S3 Bucket for ${YEAR}"
echo "========================================="
echo ""
echo "Bucket: ${S3_BUCKET}"
echo "Region: ${AWS_REGION}"
echo "Profile: ${AWS_SSO_PROFILE}"
echo ""

# Validate SSO session
"${SCRIPT_DIR}/validate-sso.sh" || exit 1

# Check if bucket already exists
echo "Checking if bucket exists..."
if aws s3 ls "s3://${S3_BUCKET}" --profile "${AWS_SSO_PROFILE}" 2>/dev/null; then
    echo -e "${YELLOW}Bucket ${S3_BUCKET} already exists${NC}"
    read -p "Do you want to reconfigure it? (y/n) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Skipping bucket setup"
        exit 0
    fi
else
    # Create bucket
    echo -e "${BLUE}Creating bucket: ${S3_BUCKET}${NC}"
    aws s3api create-bucket \
        --bucket "${S3_BUCKET}" \
        --region "${AWS_REGION}" \
        --create-bucket-configuration LocationConstraint="${AWS_REGION}" \
        --profile "${AWS_SSO_PROFILE}"
    echo -e "${GREEN}✓ Bucket created${NC}"
fi

# Enable static website hosting
echo ""
echo -e "${BLUE}Enabling static website hosting${NC}"
aws s3 website "s3://${S3_BUCKET}" \
    --index-document index.html \
    --error-document 404.html \
    --profile "${AWS_SSO_PROFILE}"
echo -e "${GREEN}✓ Static website hosting enabled${NC}"

# Disable Block Public Access (required for public website)
echo ""
echo -e "${BLUE}Configuring public access settings${NC}"
aws s3api put-public-access-block \
    --bucket "${S3_BUCKET}" \
    --public-access-block-configuration \
        "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=false,RestrictPublicBuckets=false" \
    --profile "${AWS_SSO_PROFILE}"
echo -e "${GREEN}✓ Public access configured${NC}"

# Set public read policy
echo ""
echo -e "${BLUE}Setting public read policy${NC}"

# Create policy JSON
POLICY=$(cat <<EOF
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
)

# Apply policy
echo "$POLICY" | aws s3api put-bucket-policy \
    --bucket "${S3_BUCKET}" \
    --policy file:///dev/stdin \
    --profile "${AWS_SSO_PROFILE}"
echo -e "${GREEN}✓ Public read policy applied${NC}"

# Enable versioning
echo ""
echo -e "${BLUE}Enabling versioning${NC}"
aws s3api put-bucket-versioning \
    --bucket "${S3_BUCKET}" \
    --versioning-configuration Status=Enabled \
    --profile "${AWS_SSO_PROFILE}"
echo -e "${GREEN}✓ Versioning enabled${NC}"

# Add tags
echo ""
echo -e "${BLUE}Adding bucket tags${NC}"
aws s3api put-bucket-tagging \
    --bucket "${S3_BUCKET}" \
    --tagging "TagSet=[
        {Key=Project,Value=TEDxBreckenridge},
        {Key=Year,Value=${YEAR}},
        {Key=Theme,Value=${EVENT_THEME}},
        {Key=ManagedBy,Value=Scripts}
    ]" \
    --profile "${AWS_SSO_PROFILE}"
echo -e "${GREEN}✓ Tags added${NC}"

# Summary
echo ""
echo "========================================="
echo -e "${GREEN}Bucket Setup Complete!${NC}"
echo "========================================="
echo ""
echo "Bucket: ${S3_BUCKET}"
echo "Region: ${AWS_REGION}"
echo "Website URL: ${WEBSITE_URL}"
echo ""
echo "Next steps:"
echo "1. Deploy your site: ../deploy.sh ${YEAR}"
echo "2. Visit: ${WEBSITE_URL}"
echo ""
