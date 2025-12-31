#!/bin/bash

# TEDxBreckenridge CloudFront Setup Script
# Creates ACM certificate and CloudFront distribution with custom domains

set -e

# Load configurations
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/config/infrastructure.conf"
source "${SCRIPT_DIR}/config/website.conf"
source "${SCRIPT_DIR}/config/cloudfront.conf"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get AWS Account ID
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --profile "${AWS_SSO_PROFILE_PROD_ADMIN}" --query Account --output text)

# Get S3 website endpoint URL
S3_WEBSITE_ENDPOINT="${S3_BUCKET}.s3-website-${AWS_REGION}.amazonaws.com"

echo "========================================="
echo "CloudFront Setup for TEDxBreckenridge"
echo "========================================="
echo ""
echo "AWS Account: ${AWS_ACCOUNT_ID}"
echo "Domains: ${DOMAIN_WWW}, ${DOMAIN_BETA}, ${DOMAIN_APEX}"
echo "S3 Bucket: ${S3_BUCKET}"
echo "S3 Website Endpoint: ${S3_WEBSITE_ENDPOINT}"
echo ""

# Validate SSO session
"${SCRIPT_DIR}/validate-sso.sh" || exit 1

# Step 1: Request or find existing ACM Certificate
echo ""
echo -e "${BLUE}Step 1: ACM Certificate${NC}"

# Check if certificate already exists
EXISTING_CERT=$(aws acm list-certificates \
    --region "${ACM_REGION}" \
    --profile "${AWS_SSO_PROFILE_PROD_ADMIN}" \
    --query "CertificateSummaryList[?DomainName=='*.${DOMAIN_APEX}'].CertificateArn" \
    --output text)

if [ -n "$EXISTING_CERT" ]; then
    echo -e "${YELLOW}Found existing certificate: ${EXISTING_CERT}${NC}"
    CERTIFICATE_ARN="$EXISTING_CERT"

    # Check certificate status
    CERT_STATUS=$(aws acm describe-certificate \
        --certificate-arn "${CERTIFICATE_ARN}" \
        --region "${ACM_REGION}" \
        --profile "${AWS_SSO_PROFILE_PROD_ADMIN}" \
        --query "Certificate.Status" \
        --output text)

    echo "Certificate status: ${CERT_STATUS}"

    if [ "$CERT_STATUS" != "ISSUED" ]; then
        echo -e "${RED}Certificate is not in ISSUED status${NC}"
        echo "Please check the certificate validation in ACM console"
        exit 1
    fi
else
    echo "Requesting new ACM certificate..."
    CERTIFICATE_ARN=$(aws acm request-certificate \
        --domain-name "*.${DOMAIN_APEX}" \
        --subject-alternative-names "${DOMAIN_APEX}" \
        --validation-method DNS \
        --region "${ACM_REGION}" \
        --profile "${AWS_SSO_PROFILE_PROD_ADMIN}" \
        --query "CertificateArn" \
        --output text)

    echo -e "${GREEN}✓ Certificate requested: ${CERTIFICATE_ARN}${NC}"

    # Wait a moment for AWS to generate validation records
    echo "Waiting for DNS validation records to be generated..."
    sleep 5
fi

# Step 2: Get DNS validation records
echo ""
echo -e "${BLUE}Step 2: DNS Validation Records${NC}"

# Get validation records
VALIDATION_RECORDS=$(aws acm describe-certificate \
    --certificate-arn "${CERTIFICATE_ARN}" \
    --region "${ACM_REGION}" \
    --profile "${AWS_SSO_PROFILE_PROD_ADMIN}" \
    --query "Certificate.DomainValidationOptions[*].[DomainName,ResourceRecord.Name,ResourceRecord.Value]" \
    --output text)

if [ -z "$VALIDATION_RECORDS" ]; then
    echo -e "${RED}Error: Could not retrieve DNS validation records${NC}"
    exit 1
fi

echo "Add these CNAME records to your DNS provider (Squarespace):"
echo ""
echo "$VALIDATION_RECORDS" | while IFS=$'\t' read -r domain name value; do
    echo -e "${YELLOW}Domain: ${domain}${NC}"
    echo "  Name:  ${name}"
    echo "  Value: ${value}"
    echo ""
done

# Check if certificate is already validated
CERT_STATUS=$(aws acm describe-certificate \
    --certificate-arn "${CERTIFICATE_ARN}" \
    --region "${ACM_REGION}" \
    --profile "${AWS_SSO_PROFILE_PROD_ADMIN}" \
    --query "Certificate.Status" \
    --output text)

if [ "$CERT_STATUS" = "ISSUED" ]; then
    echo -e "${GREEN}✓ Certificate is already validated${NC}"
else
    echo "Waiting for certificate validation..."
    echo "This can take 5-30 minutes after you add the DNS records."
    echo ""
    read -p "Press Enter after you've added the DNS records to continue..." -r
    echo ""

    # Poll for certificate validation (max 30 minutes)
    echo "Polling for certificate validation (timeout: 30 minutes)..."
    TIMEOUT=1800  # 30 minutes
    ELAPSED=0
    INTERVAL=30

    while [ $ELAPSED -lt $TIMEOUT ]; do
        CERT_STATUS=$(aws acm describe-certificate \
            --certificate-arn "${CERTIFICATE_ARN}" \
            --region "${ACM_REGION}" \
            --profile "${AWS_SSO_PROFILE_PROD_ADMIN}" \
            --query "Certificate.Status" \
            --output text)

        if [ "$CERT_STATUS" = "ISSUED" ]; then
            echo -e "${GREEN}✓ Certificate validated!${NC}"
            break
        fi

        echo "Status: ${CERT_STATUS} (elapsed: ${ELAPSED}s, waiting ${INTERVAL}s...)"
        sleep $INTERVAL
        ELAPSED=$((ELAPSED + INTERVAL))
    done

    if [ "$CERT_STATUS" != "ISSUED" ]; then
        echo -e "${RED}Certificate validation timed out${NC}"
        echo "Please check the DNS records and run this script again"
        exit 1
    fi
fi

# Step 3: Create CloudFront Function for apex redirect
echo ""
echo -e "${BLUE}Step 3: CloudFront Function (apex redirect)${NC}"

# CloudFront Function code
FUNCTION_CODE='function handler(event) {
    var request = event.request;
    var host = request.headers.host.value;

    // Redirect apex domain to www
    if (host === "'"${DOMAIN_APEX}"'") {
        return {
            statusCode: 301,
            statusDescription: "Moved Permanently",
            headers: {
                "location": { value: "https://'"${DOMAIN_WWW}"'" + request.uri }
            }
        };
    }

    return request;
}'

# Check if function already exists
EXISTING_FUNCTION=$(aws cloudfront list-functions \
    --profile "${AWS_SSO_PROFILE_PROD_ADMIN}" \
    --query "FunctionList.Items[?Name=='${CF_FUNCTION_NAME}'].Name" \
    --output text 2>/dev/null || echo "")

if [ -n "$EXISTING_FUNCTION" ]; then
    echo -e "${YELLOW}Updating existing CloudFront Function: ${CF_FUNCTION_NAME}${NC}"

    # Update function code
    echo "$FUNCTION_CODE" | aws cloudfront update-function \
        --name "${CF_FUNCTION_NAME}" \
        --function-code fileb:///dev/stdin \
        --function-config "Comment=Redirect apex domain to www,Runtime=cloudfront-js-1.0" \
        --profile "${AWS_SSO_PROFILE_PROD_ADMIN}" \
        --if-match "$(aws cloudfront describe-function --name "${CF_FUNCTION_NAME}" --profile "${AWS_SSO_PROFILE_PROD_ADMIN}" --query "ETag" --output text)" \
        > /dev/null

    echo -e "${GREEN}✓ Function updated${NC}"
else
    echo "Creating CloudFront Function: ${CF_FUNCTION_NAME}"

    # Create function
    echo "$FUNCTION_CODE" | aws cloudfront create-function \
        --name "${CF_FUNCTION_NAME}" \
        --function-code fileb:///dev/stdin \
        --function-config "Comment=Redirect apex domain to www,Runtime=cloudfront-js-1.0" \
        --profile "${AWS_SSO_PROFILE_PROD_ADMIN}" \
        > /dev/null

    echo -e "${GREEN}✓ Function created${NC}"
fi

# Publish the function
FUNCTION_ARN=$(aws cloudfront describe-function \
    --name "${CF_FUNCTION_NAME}" \
    --profile "${AWS_SSO_PROFILE_PROD_ADMIN}" \
    --query "FunctionSummary.FunctionMetadata.FunctionARN" \
    --output text)

FUNCTION_ETAG=$(aws cloudfront describe-function \
    --name "${CF_FUNCTION_NAME}" \
    --profile "${AWS_SSO_PROFILE_PROD_ADMIN}" \
    --query "ETag" \
    --output text)

aws cloudfront publish-function \
    --name "${CF_FUNCTION_NAME}" \
    --if-match "${FUNCTION_ETAG}" \
    --profile "${AWS_SSO_PROFILE_PROD_ADMIN}" \
    > /dev/null

echo -e "${GREEN}✓ Function published${NC}"
echo "Function ARN: ${FUNCTION_ARN}"

# Step 4: Create or update CloudFront Distribution
echo ""
echo -e "${BLUE}Step 4: CloudFront Distribution${NC}"

# Check if distribution already exists
EXISTING_DIST=$(aws cloudfront list-distributions \
    --profile "${AWS_SSO_PROFILE_PROD_ADMIN}" \
    --query "DistributionList.Items[?Comment=='${CF_DISTRIBUTION_COMMENT}'].Id" \
    --output text 2>/dev/null || echo "")

if [ -n "$EXISTING_DIST" ] && [ "$EXISTING_DIST" != "None" ]; then
    echo -e "${YELLOW}Distribution already exists: ${EXISTING_DIST}${NC}"
    echo "To update the distribution, please use the AWS Console or modify this script"
    DISTRIBUTION_ID="$EXISTING_DIST"

    # Get distribution domain name
    DISTRIBUTION_DOMAIN=$(aws cloudfront get-distribution \
        --id "${DISTRIBUTION_ID}" \
        --profile "${AWS_SSO_PROFILE_PROD_ADMIN}" \
        --query "Distribution.DomainName" \
        --output text)
else
    echo "Creating CloudFront distribution..."

    # Create distribution configuration JSON
    DIST_CONFIG=$(cat <<EOF
{
    "CallerReference": "tedxbreckenridge-$(date +%s)",
    "Comment": "${CF_DISTRIBUTION_COMMENT}",
    "Enabled": true,
    "Origins": {
        "Quantity": 1,
        "Items": [
            {
                "Id": "S3-${S3_BUCKET}",
                "DomainName": "${S3_WEBSITE_ENDPOINT}",
                "CustomOriginConfig": {
                    "HTTPPort": 80,
                    "HTTPSPort": 443,
                    "OriginProtocolPolicy": "http-only",
                    "OriginSslProtocols": {
                        "Quantity": 1,
                        "Items": ["TLSv1.2"]
                    }
                }
            }
        ]
    },
    "DefaultCacheBehavior": {
        "TargetOriginId": "S3-${S3_BUCKET}",
        "ViewerProtocolPolicy": "redirect-to-https",
        "AllowedMethods": {
            "Quantity": 2,
            "Items": ["GET", "HEAD"],
            "CachedMethods": {
                "Quantity": 2,
                "Items": ["GET", "HEAD"]
            }
        },
        "Compress": true,
        "CachePolicyId": "${CF_CACHE_POLICY_ID}",
        "OriginRequestPolicyId": "${CF_ORIGIN_REQUEST_POLICY_ID}",
        "ResponseHeadersPolicyId": "${CF_RESPONSE_HEADERS_POLICY_ID}",
        "FunctionAssociations": {
            "Quantity": 1,
            "Items": [
                {
                    "FunctionARN": "${FUNCTION_ARN}",
                    "EventType": "viewer-request"
                }
            ]
        }
    },
    "Aliases": {
        "Quantity": 3,
        "Items": ["${DOMAIN_WWW}", "${DOMAIN_BETA}", "${DOMAIN_APEX}"]
    },
    "DefaultRootObject": "${CF_DEFAULT_ROOT_OBJECT}",
    "PriceClass": "${CF_PRICE_CLASS}",
    "ViewerCertificate": {
        "ACMCertificateArn": "${CERTIFICATE_ARN}",
        "SSLSupportMethod": "sni-only",
        "MinimumProtocolVersion": "TLSv1.2_2021"
    },
    "HttpVersion": "http2and3"
}
EOF
)

    # Create distribution
    DIST_OUTPUT=$(echo "$DIST_CONFIG" | aws cloudfront create-distribution \
        --distribution-config file:///dev/stdin \
        --profile "${AWS_SSO_PROFILE_PROD_ADMIN}" \
        --output json)

    DISTRIBUTION_ID=$(echo "$DIST_OUTPUT" | jq -r '.Distribution.Id')
    DISTRIBUTION_DOMAIN=$(echo "$DIST_OUTPUT" | jq -r '.Distribution.DomainName')

    echo -e "${GREEN}✓ Distribution created${NC}"
    echo "Distribution ID: ${DISTRIBUTION_ID}"
    echo "Domain: ${DISTRIBUTION_DOMAIN}"
    echo ""
    echo "Note: CloudFront distribution deployment takes 5-15 minutes"
fi

# Summary
echo ""
echo "========================================="
echo -e "${GREEN}CloudFront Setup Complete!${NC}"
echo "========================================="
echo ""
echo "Certificate ARN: ${CERTIFICATE_ARN}"
echo "CloudFront Function: ${CF_FUNCTION_NAME}"
echo "Distribution ID: ${DISTRIBUTION_ID}"
echo "Distribution Domain: ${DISTRIBUTION_DOMAIN}"
echo ""
echo "Next steps:"
echo ""
echo "1. Add these DNS CNAME records in Squarespace:"
echo "   ${DOMAIN_WWW}   CNAME   ${DISTRIBUTION_DOMAIN}"
echo "   ${DOMAIN_BETA}  CNAME   ${DISTRIBUTION_DOMAIN}"
echo ""
echo "2. For apex domain (${DOMAIN_APEX}):"
echo "   Set up Squarespace URL forwarding to ${DOMAIN_WWW}"
echo "   (CNAME cannot be used at apex domain)"
echo ""
echo "3. Update config/website.conf with:"
echo "   CF_DISTRIBUTION_ID=\"${DISTRIBUTION_ID}\""
echo ""
echo "4. Add GitHub secret:"
echo "   Name: CF_DISTRIBUTION_ID"
echo "   Value: ${DISTRIBUTION_ID}"
echo ""
echo "5. Update IAM permissions for GitHub Actions:"
echo "   Run: ./build/aws/setup-oidc.sh"
echo ""
echo "6. Test deployment:"
echo "   Run: ./build/website/deploy.sh"
echo ""
echo "CloudFront deployment typically takes 5-15 minutes to complete."
echo "You can check status in AWS Console or with:"
echo "  aws cloudfront get-distribution --id ${DISTRIBUTION_ID} --query 'Distribution.Status'"
echo ""
