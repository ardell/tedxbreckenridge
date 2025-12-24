#!/bin/bash

# TEDxBreckenridge AWS SSO Validation Script
# Checks if AWS SSO session is valid and prompts for login if expired

set -e

# Load infrastructure configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/config/infrastructure.conf"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "========================================="
echo "Validating AWS SSO Session"
echo "========================================="
echo ""

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo -e "${RED}Error: AWS CLI is not installed${NC}"
    echo "Please install AWS CLI: https://aws.amazon.com/cli/"
    exit 1
fi

# Check if SSO profile exists in config
if ! aws configure list-profiles | grep -q "^${AWS_SSO_PROFILE}$"; then
    echo -e "${YELLOW}Warning: AWS SSO profile '${AWS_SSO_PROFILE}' not found${NC}"
    echo ""
    echo "Please configure AWS SSO in ~/.aws/config:"
    echo ""
    echo "[profile ${AWS_SSO_PROFILE}]"
    echo "sso_start_url = https://YOUR_ORG.awsapps.com/start"
    echo "sso_region = ${AWS_REGION}"
    echo "sso_account_id = YOUR_ACCOUNT_ID"
    echo "sso_role_name = TEDxBreckenridgeAdmin"
    echo "region = ${AWS_REGION}"
    echo "output = json"
    echo ""
    exit 1
fi

# Test if SSO credentials are valid
echo "Testing SSO credentials for profile: ${AWS_SSO_PROFILE}"
if aws sts get-caller-identity --profile "${AWS_SSO_PROFILE}" &> /dev/null; then
    echo -e "${GREEN}✓ AWS SSO session is valid${NC}"

    # Show identity
    IDENTITY=$(aws sts get-caller-identity --profile "${AWS_SSO_PROFILE}" --output json)
    ACCOUNT=$(echo "$IDENTITY" | grep -o '"Account": "[^"]*' | cut -d'"' -f4)
    ARN=$(echo "$IDENTITY" | grep -o '"Arn": "[^"]*' | cut -d'"' -f4)

    echo "  Account: ${ACCOUNT}"
    echo "  ARN: ${ARN}"
    echo ""
    exit 0
else
    echo -e "${YELLOW}✗ AWS SSO session is expired or invalid${NC}"
    echo ""
    echo "Please login with:"
    echo "  aws sso login --profile ${AWS_SSO_PROFILE}"
    echo ""

    # Optionally prompt for automatic login
    read -p "Would you like to login now? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        aws sso login --profile "${AWS_SSO_PROFILE}"

        # Verify login succeeded
        if aws sts get-caller-identity --profile "${AWS_SSO_PROFILE}" &> /dev/null; then
            echo -e "${GREEN}✓ AWS SSO login successful${NC}"
            exit 0
        else
            echo -e "${RED}✗ AWS SSO login failed${NC}"
            exit 1
        fi
    else
        echo "Please login manually before deploying."
        exit 1
    fi
fi
