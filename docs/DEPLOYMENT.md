# Deployment Guide

## Overview

TEDxBreckenridge uses GitHub Actions for automated deployment to AWS S3.

## Automated Deployment

### Two-Stage Process

The deployment process uses two separate GitHub Actions workflows:

1. **Test Workflow** (`.github/workflows/test.yml`)
   - Runs on every push to `main` and on all pull requests
   - Validates code quality (Jekyll build, image sizes, HTML, CSS, accessibility)
   - Must pass before PRs can be merged

2. **Deploy Workflow** (`.github/workflows/deploy.yml`)
   - Runs automatically after Test workflow succeeds on `main` branch
   - Only deploys if all tests pass
   - Can also be manually triggered

### Trigger
Deployments run automatically when:
- Pull request is merged to `main` (Test runs → Deploy runs)
  - Note: With branch protection enabled, ALL changes to main happen via PR merges
- Manually triggered via GitHub Actions UI (Deploy only, for emergency fixes)

### Process
**Test Stage:**
1. Checkout code
2. Set up Ruby environment via mise (version 3.4.8)
3. Install Jekyll dependencies
4. Build site with dev config (for localhost URLs in sitemap)
5. Validate image sizes
6. Run HTMLProofer (internal links)
7. Run Stylelint (CSS linting)
8. Run pa11y-ci (accessibility testing)

**Deploy Stage:**
1. Checkout code
2. Set up Ruby environment
3. Install Jekyll dependencies
4. Build static site (`JEKYLL_ENV=production`)
5. Authenticate to AWS via OIDC (no stored credentials)
6. Sync files to S3 bucket
7. Report deployment status

### Monitoring
- **View workflows**: [Actions tab](https://github.com/ardell/tedxbreckenridge/actions)
- **Test workflow**: `.github/workflows/test.yml`
- **Deploy workflow**: `.github/workflows/deploy.yml`
- **Test time**: ~3-4 minutes
- **Deploy time**: ~2 minutes
- **Total time**: ~5-6 minutes from merge to live

## Manual Deployment

### Prerequisites
- AWS CLI installed: `brew install awscli`
- AWS SSO configured
- Active SSO session: `aws sso login --profile tedxbreckenridge-production`

### Deploy Command
```bash
./build/website/deploy.sh
```

### What It Does
1. Validates AWS SSO session
2. Builds Jekyll site
3. Verifies S3 bucket access
4. Syncs files to S3 with cache headers
5. Deletes removed files from S3

## AWS Infrastructure

### S3 Bucket
- **Name**: tedxbreckenridge-website
- **Region**: us-west-1
- **Website URL**: http://tedxbreckenridge-website.s3-website-us-west-1.amazonaws.com
- **Configuration**: Static website hosting, public read, versioning enabled

### Authentication

#### GitHub Actions (OIDC)
- Uses OpenID Connect for secure, credential-less authentication
- Role: `GitHubActionsDeploymentRole`
- Permissions: S3 read/write for tedxbreckenridge-website bucket
- Trust policy: Restricted to `ardell/tedxbreckenridge` repository's `main` branch

#### Local (AWS SSO)
- Profile: `tedxbreckenridge-production`
- Requires SSO login before deployment

## GitHub Actions Setup

### Initial Setup (One-time)

**1. Set up AWS OIDC Infrastructure**

Run the setup script to create the OIDC identity provider and IAM role:

```bash
./build/aws/setup-oidc.sh
```

This will:
- Create OIDC identity provider in AWS
- Create `GitHubActionsDeploymentRole` IAM role
- Attach S3 deployment permissions
- Output the role ARN

**2. Add GitHub Secret**

1. Go to: https://github.com/ardell/tedxbreckenridge/settings/secrets/actions
2. Click "New repository secret"
3. Name: `AWS_ROLE_ARN`
4. Value: `arn:aws:iam::119697988135:role/GitHubActionsDeploymentRole`
5. Click "Add secret"

**3. Verify Workflow**

The workflow file should already exist at `.github/workflows/deploy.yml`.

To test:
- Push a commit to `main` branch
- Or manually trigger via Actions tab → "Deploy to Production" → "Run workflow"

### Workflow Configuration

The workflow is configured to:
- Run on every push to `main`
- Use Ruby 3.4.8 (managed by mise)
- Cache Ruby gems for faster builds
- Deploy only from `main` branch (enforced by IAM trust policy)
- Prevent concurrent deployments

## Troubleshooting

### Deployment Failed in GitHub Actions

**Check Actions tab for error details**

Common issues:

1. **OIDC authentication failure** → Verify IAM role configuration
   ```bash
   # Check if OIDC provider exists
   aws iam get-open-id-connect-provider \
     --open-id-connect-provider-arn "arn:aws:iam::119697988135:oidc-provider/token.actions.githubusercontent.com" \
     --profile tedxbreckenridge-production-admin

   # Check if role exists
   aws iam get-role \
     --role-name GitHubActionsDeploymentRole \
     --profile tedxbreckenridge-production-admin
   ```

2. **Build errors** → Test locally first:
   ```bash
   ./build/website/build.sh
   ```

3. **S3 permissions** → Verify IAM policy allows deployment:
   ```bash
   aws iam get-role-policy \
     --role-name GitHubActionsDeploymentRole \
     --policy-name S3DeploymentPolicy \
     --profile tedxbreckenridge-production-admin
   ```

4. **GitHub secret missing** → Verify `AWS_ROLE_ARN` secret exists:
   - Check: https://github.com/ardell/tedxbreckenridge/settings/secrets/actions

### Manual Deployment Fails

1. **Verify AWS SSO session**:
   ```bash
   aws sts get-caller-identity --profile tedxbreckenridge-production
   ```

2. **Re-authenticate if expired**:
   ```bash
   aws sso login --profile tedxbreckenridge-production
   ```

### Site Not Updating

1. Check deployment succeeded (Actions tab)
2. Wait 2-3 minutes for S3 to propagate changes
3. Clear browser cache (Cmd+Shift+R or Ctrl+F5)
4. Verify S3 bucket contents:
   ```bash
   aws s3 ls s3://tedxbreckenridge-website --recursive | grep index.html
   ```

## Rollback

### Revert to Previous Version

**Option 1: Revert git commit**
```bash
git revert HEAD
git push origin main
# GitHub Actions will deploy previous version
```

**Option 2: Manual deployment of previous version**
```bash
git checkout <previous-commit>
./build/website/deploy.sh
git checkout main
```

**Option 3: Use S3 versioning**
```bash
# List versions
aws s3api list-object-versions \
  --bucket tedxbreckenridge-website \
  --prefix index.html \
  --profile tedxbreckenridge-production

# Restore specific version (replace VERSION_ID)
aws s3api copy-object \
  --bucket tedxbreckenridge-website \
  --copy-source tedxbreckenridge-website/index.html?versionId=VERSION_ID \
  --key index.html \
  --profile tedxbreckenridge-production
```

## Monitoring

### GitHub Actions
- Workflow runs: [Actions tab](https://github.com/ardell/tedxbreckenridge/actions)
- Check deployment logs for any issues
- Review deployment summary generated after each run

### AWS S3
```bash
# Check recent uploads
aws s3 ls s3://tedxbreckenridge-website --recursive | sort -k1,2

# Verify file count
aws s3 ls s3://tedxbreckenridge-website --recursive --summarize

# Check bucket size
aws s3 ls s3://tedxbreckenridge-website --recursive --summarize --human-readable
```

## Configuration Files

- `.github/workflows/deploy.yml` - GitHub Actions workflow
- `build/aws/config/infrastructure.conf` - AWS region and profile settings
- `build/aws/config/website.conf` - Website-specific configuration (bucket name, event details)
- `build/aws/setup-oidc.sh` - Script to set up AWS OIDC infrastructure
- `build/website/deploy.sh` - Manual deployment script
- `build/website/build.sh` - Jekyll build script

## Security

### OIDC Trust Policy

The IAM role trust policy restricts access to:
- **Repository**: `ardell/tedxbreckenridge`
- **Branch**: `main` only
- **Provider**: GitHub Actions OIDC (`token.actions.githubusercontent.com`)

This ensures only deployments from the main branch of the official repository can access AWS resources.

### IAM Permissions

The deployment role has minimal permissions:
- `s3:ListBucket`, `s3:GetBucketLocation`, `s3:GetBucketWebsite` on the bucket
- `s3:PutObject`, `s3:GetObject`, `s3:DeleteObject` on bucket objects

No permissions for:
- Creating/deleting buckets
- Modifying IAM roles or policies
- Accessing other AWS resources

### Secret Management

- **GitHub Secret**: `AWS_ROLE_ARN` contains only the role ARN (public identifier, not sensitive)
- **No AWS credentials** stored in GitHub (OIDC provides temporary credentials)
- **SSO for local development** prevents long-term credentials on developer machines

## Cost Estimate

### Current Costs (Monthly)

- **S3 Storage**: ~13 MB = ~$0.003/month
- **S3 Requests**: ~20 deployments × 500 files = 10,000 PUT requests = $0.05/month
- **Data Transfer**: First 1 GB free, then ~$0.09/GB
- **GitHub Actions**: Free for public repositories

**Total**: < $1/month

## Future Enhancements

Potential improvements:

1. **CloudFront CDN**
   - Add HTTPS support
   - Custom domain (www.tedxbreckenridge.com)
   - Cache invalidation on deployment
   - Faster global access

2. **Deployment Notifications**
   - Slack/Discord notifications
   - Email on deployment success/failure

3. **Preview Deployments**
   - Deploy PR previews to separate S3 paths
   - Comment PR with preview URL

4. **Smoke Tests**
   - Post-deployment validation
   - Check critical pages load
   - Verify assets are accessible

5. **Build Performance**
   - Cache Jekyll build artifacts
   - Parallel asset processing
   - Track build times
