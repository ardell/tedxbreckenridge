#!/bin/bash

# TEDxBreckenridge GitHub Actions OIDC Setup Script
# Sets up AWS OIDC identity provider and IAM role for GitHub Actions deployments

set -e

# Load configurations
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/config/infrastructure.conf"
source "${SCRIPT_DIR}/config/website.conf"

# GitHub repository details
GITHUB_OWNER="ardell"
GITHUB_REPO="tedxbreckenridge"
GITHUB_REPO_FULL="${GITHUB_OWNER}/${GITHUB_REPO}"

# AWS Account ID
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --profile "${AWS_SSO_PROFILE_PROD_ADMIN}" --query Account --output text)

# IAM Role name
ROLE_NAME="GitHubActionsDeploymentRole"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "========================================="
echo "GitHub Actions OIDC Setup"
echo "========================================="
echo ""
echo "AWS Account: ${AWS_ACCOUNT_ID}"
echo "GitHub Repo: ${GITHUB_REPO_FULL}"
echo "S3 Bucket: ${S3_BUCKET}"
echo "IAM Role: ${ROLE_NAME}"
echo ""

# Validate SSO session
"${SCRIPT_DIR}/validate-sso.sh" || exit 1

# Step 1: Create OIDC Identity Provider (if it doesn't exist)
echo ""
echo -e "${BLUE}Step 1: Creating OIDC Identity Provider${NC}"

OIDC_PROVIDER_ARN="arn:aws:iam::${AWS_ACCOUNT_ID}:oidc-provider/token.actions.githubusercontent.com"

if aws iam get-open-id-connect-provider \
    --open-id-connect-provider-arn "${OIDC_PROVIDER_ARN}" \
    --profile "${AWS_SSO_PROFILE_PROD_ADMIN}" \
    2>/dev/null | grep -q "Url"; then
    echo -e "${YELLOW}OIDC provider already exists${NC}"
else
    echo "Creating OIDC provider..."
    aws iam create-open-id-connect-provider \
        --url "https://token.actions.githubusercontent.com" \
        --client-id-list "sts.amazonaws.com" \
        --thumbprint-list "6938fd4d98bab03faadb97b34396831e3780aea1" \
        --profile "${AWS_SSO_PROFILE_PROD_ADMIN}"
    echo -e "${GREEN}✓ OIDC provider created${NC}"
fi

# Step 2: Create IAM Role with Trust Policy
echo ""
echo -e "${BLUE}Step 2: Creating IAM Role${NC}"

# Create trust policy
TRUST_POLICY=$(cat <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${AWS_ACCOUNT_ID}:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        },
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:${GITHUB_REPO_FULL}:ref:refs/heads/main"
        }
      }
    }
  ]
}
EOF
)

if aws iam get-role \
    --role-name "${ROLE_NAME}" \
    --profile "${AWS_SSO_PROFILE_PROD_ADMIN}" \
    2>/dev/null | grep -q "RoleName"; then
    echo -e "${YELLOW}Role ${ROLE_NAME} already exists${NC}"

    # Update trust policy
    echo "Updating trust policy..."
    echo "$TRUST_POLICY" | aws iam update-assume-role-policy \
        --role-name "${ROLE_NAME}" \
        --policy-document file:///dev/stdin \
        --profile "${AWS_SSO_PROFILE_PROD_ADMIN}"
    echo -e "${GREEN}✓ Trust policy updated${NC}"
else
    echo "Creating role ${ROLE_NAME}..."
    echo "$TRUST_POLICY" | aws iam create-role \
        --role-name "${ROLE_NAME}" \
        --assume-role-policy-document file:///dev/stdin \
        --description "Role for GitHub Actions to deploy TEDxBreckenridge website" \
        --profile "${AWS_SSO_PROFILE_PROD_ADMIN}"
    echo -e "${GREEN}✓ Role created${NC}"
fi

# Step 3: Attach S3 Permissions Policy
echo ""
echo -e "${BLUE}Step 3: Attaching S3 Permissions${NC}"

POLICY_NAME="S3DeploymentPolicy"

# Create permissions policy
PERMISSIONS_POLICY=$(cat <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetBucketLocation",
        "s3:GetBucketWebsite"
      ],
      "Resource": "arn:aws:s3:::${S3_BUCKET}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject"
      ],
      "Resource": "arn:aws:s3:::${S3_BUCKET}/*"
    }
  ]
}
EOF
)

echo "Attaching inline policy..."
echo "$PERMISSIONS_POLICY" | aws iam put-role-policy \
    --role-name "${ROLE_NAME}" \
    --policy-name "${POLICY_NAME}" \
    --policy-document file:///dev/stdin \
    --profile "${AWS_SSO_PROFILE_PROD_ADMIN}"
echo -e "${GREEN}✓ Permissions policy attached${NC}"

# Step 4: Get Role ARN
echo ""
echo -e "${BLUE}Step 4: Getting Role ARN${NC}"

ROLE_ARN=$(aws iam get-role \
    --role-name "${ROLE_NAME}" \
    --query 'Role.Arn' \
    --output text \
    --profile "${AWS_SSO_PROFILE_PROD_ADMIN}")

echo -e "${GREEN}✓ Role ARN: ${ROLE_ARN}${NC}"

# Summary
echo ""
echo "========================================="
echo -e "${GREEN}Setup Complete!${NC}"
echo "========================================="
echo ""
echo "Next steps:"
echo ""
echo "1. Add GitHub Secret:"
echo "   - Go to: https://github.com/${GITHUB_REPO_FULL}/settings/secrets/actions"
echo "   - Click 'New repository secret'"
echo "   - Name: AWS_ROLE_ARN"
echo "   - Value: ${ROLE_ARN}"
echo ""
echo "2. Create GitHub Actions workflow:"
echo "   - File: .github/workflows/deploy.yml"
echo "   - See documentation for workflow configuration"
echo ""
echo "3. Test deployment:"
echo "   - Push to main branch or manually trigger workflow"
echo ""
