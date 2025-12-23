# AWS Infrastructure Setup Guide

This guide walks through setting up the AWS infrastructure for hosting TEDxBreckenridge sites.

## Overview

Each year's site is hosted using:
- **S3**: Static file storage and website hosting
- **CloudFront**: CDN for fast global content delivery
- **Route 53** (optional): DNS management for custom domains

## Prerequisites

1. AWS Account
2. AWS CLI installed and configured
3. Appropriate IAM permissions for S3, CloudFront, and Route 53

## S3 Bucket Setup

### Automated Setup

Use the provided script:

```bash
./scripts/setup-aws.sh 2026
```

### Manual Setup

1. Create S3 bucket: `tedxbreckenridge-2026`
2. Enable static website hosting:
   - Index document: `index.html`
   - Error document: `404.html`
3. Add bucket policy for public read access
4. Configure bucket for website hosting

## CloudFront Distribution Setup

### Creating a Distribution

1. **Go to CloudFront Console**
   - Navigate to: https://console.aws.amazon.com/cloudfront/

2. **Create Distribution**
   - Click "Create Distribution"

3. **Origin Settings**
   - Origin Domain: `tedxbreckenridge-2026.s3-website-us-east-1.amazonaws.com`
     (Note: Use the S3 website endpoint, not the REST endpoint)
   - Protocol: HTTP only (S3 website endpoints only support HTTP)
   - Origin Path: Leave blank

4. **Default Cache Behavior**
   - Viewer Protocol Policy: Redirect HTTP to HTTPS
   - Allowed HTTP Methods: GET, HEAD, OPTIONS
   - Compress Objects Automatically: Yes
   - Cache Policy: CachingOptimized (Recommended)

5. **Distribution Settings**
   - Price Class: Use All Edge Locations (or adjust based on your needs)
   - Alternate Domain Names (CNAMEs): e.g., `2026.tedxbreckenridge.com`
   - SSL Certificate:
     - Request a certificate via ACM (must be in us-east-1 region)
     - Or use default CloudFront certificate
   - Default Root Object: `index.html`

6. **Create Distribution**
   - Click "Create Distribution"
   - Note the Distribution ID (e.g., `E1234ABCDEFGH`)
   - Note the Distribution Domain Name (e.g., `d111111abcdef8.cloudfront.net`)

### Post-Creation Configuration

1. **Save Distribution ID**
   ```bash
   export CLOUDFRONT_DISTRIBUTION_ID=E1234ABCDEFGH
   ```

2. **Test Distribution**
   - Visit: `https://d111111abcdef8.cloudfront.net`
   - Verify the site loads correctly

## Custom Domain Setup (Optional)

### SSL Certificate

1. **Request Certificate in ACM (us-east-1)**
   - Go to AWS Certificate Manager
   - Request a public certificate
   - Domain name: `2026.tedxbreckenridge.com` or `*.tedxbreckenridge.com`
   - Validation method: DNS validation
   - Add validation records to Route 53

2. **Wait for Validation**
   - Can take a few minutes to several hours

### Route 53 Configuration

1. **Create Hosted Zone** (if not exists)
   - Domain: `tedxbreckenridge.com`

2. **Add CNAME or A Record**

   Option A - Using CNAME:
   ```
   Name: 2026.tedxbreckenridge.com
   Type: CNAME
   Value: d111111abcdef8.cloudfront.net
   ```

   Option B - Using Alias Record (recommended):
   ```
   Name: 2026.tedxbreckenridge.com
   Type: A
   Alias: Yes
   Alias Target: Select your CloudFront distribution
   ```

3. **Update CloudFront Distribution**
   - Add alternate domain name: `2026.tedxbreckenridge.com`
   - Select ACM certificate

## Deployment Workflow

### First Time Setup

```bash
# 1. Set up AWS infrastructure
./scripts/setup-aws.sh 2026

# 2. Create CloudFront distribution (manual, see above)

# 3. Set environment variables
export CLOUDFRONT_DISTRIBUTION_ID=E1234ABCDEFGH

# 4. Deploy site
./scripts/deploy.sh 2026
```

### Subsequent Deployments

```bash
# With CloudFront invalidation
export CLOUDFRONT_DISTRIBUTION_ID=E1234ABCDEFGH
./scripts/deploy.sh 2026

# Without CloudFront invalidation
./scripts/deploy.sh 2026
```

## Cost Estimates

### S3 Storage
- ~$0.023 per GB/month (first 50 TB)
- Typical Jekyll site: < 100 MB = ~$0.002/month

### S3 Requests
- GET requests: $0.0004 per 1,000 requests
- PUT requests: $0.005 per 1,000 requests

### CloudFront
- Data transfer out: ~$0.085 per GB (US/Europe)
- HTTPS requests: $0.01 per 10,000 requests
- Free tier: 1 TB data transfer + 10M requests/month (first year)

### Estimated Monthly Cost
- Small site (<10K visitors): $5-15/month
- Medium site (10K-50K visitors): $15-50/month

## Security Best Practices

1. **S3 Bucket**
   - Only allow public read access to objects
   - Enable versioning for backup
   - Enable server access logging

2. **CloudFront**
   - Use HTTPS only (redirect HTTP)
   - Enable origin access identity (OAI) for better security
   - Set appropriate cache headers
   - Enable AWS WAF for DDoS protection (optional)

3. **IAM**
   - Create dedicated deployment user
   - Grant minimum required permissions
   - Use access keys securely

## Monitoring

### CloudWatch Metrics

Monitor these metrics:
- Requests count
- Bytes downloaded
- 4xx/5xx error rates
- Cache hit rate

### Set Up Alarms

```bash
# Example: Alert on high 4xx error rate
aws cloudwatch put-metric-alarm \
  --alarm-name tedxbreckenridge-2026-high-4xx \
  --alarm-description "High 4xx error rate" \
  --metric-name 4xxErrorRate \
  --namespace AWS/CloudFront \
  --statistic Average \
  --period 300 \
  --threshold 5 \
  --comparison-operator GreaterThanThreshold
```

## Troubleshooting

### Site not loading
- Check S3 bucket policy allows public read
- Verify CloudFront origin is correct
- Check DNS propagation (for custom domains)

### Stale content after deployment
- Invalidate CloudFront cache: `aws cloudfront create-invalidation --distribution-id E1234ABCDEFGH --paths "/*"`
- Wait 5-10 minutes for invalidation to complete

### SSL certificate errors
- Ensure certificate is in us-east-1 region
- Verify domain validation is complete
- Check certificate is attached to distribution

## References

- [AWS S3 Static Website Hosting](https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html)
- [CloudFront Documentation](https://docs.aws.amazon.com/cloudfront/)
- [AWS Certificate Manager](https://docs.aws.amazon.com/acm/)
- [Route 53 Documentation](https://docs.aws.amazon.com/route53/)
