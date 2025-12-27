# GitHub Repository Setup

This document describes how to configure GitHub settings for the TEDxBreckenridge repository.

## Branch Protection Rules

To ensure code quality and prevent broken code from reaching production, set up branch protection rules that require tests to pass before merging.

### Setup Instructions

1. Go to: https://github.com/ardell/tedxbreckenridge/settings/branches

2. Click **"Add branch protection rule"**

3. Configure the rule:

   **Branch name pattern**: `main`

   **Protect matching branches** - Enable these options:

   - ✅ **Require a pull request before merging**
     - Require approvals: `0` (or `1` if you want peer review)
     - Dismiss stale pull request approvals when new commits are pushed

   - ✅ **Require status checks to pass before merging**
     - ✅ Require branches to be up to date before merging
     - **Required status checks** (search and add these):
       - `Test` (this is the workflow from `.github/workflows/test.yml`)
         - Note: This check includes all quality tests: Jekyll build, image validation, HTMLProofer, Stylelint, and pa11y-ci
         - If any individual test fails, the entire check fails and PRs cannot be merged

   - ✅ **Require conversation resolution before merging**
     - Ensures all PR comments are addressed

   - ✅ **Do not allow bypassing the above settings**
     - **IMPORTANT**: This prevents ALL direct pushes to main, even from admins
     - All changes must go through pull requests
     - This is the recommended configuration for production safety

4. Click **"Create"** to save the rule

### What This Does

With branch protection enabled:

1. **Direct pushes to `main` are blocked**
   - All changes must go through pull requests

2. **Tests must pass** (all of these run in the "Test" workflow)
   - Jekyll site builds successfully
   - Image size validation (heroes <500KB, all images <500KB)
   - HTMLProofer (internal link checking)
   - Stylelint (CSS linting)
   - pa11y-ci (accessibility testing on all pages)
   - External links checked (non-blocking, won't prevent merges)

3. **Pull requests show test status**
   - You'll see "Test" workflow running
   - Green checkmark = tests passed, safe to merge
   - Red X = tests failed, must fix before merging

4. **Automatic deployment**
   - Once PR is merged to main, "Test" workflow runs again
   - If tests pass, "Deploy" workflow triggers automatically
   - Site is deployed to S3

### Workflow

**With branch protection enabled (recommended):**
```
Create PR → "Test" runs → ❌ Tests fail → Fix issues → ✅ Tests pass → Merge PR → "Test" runs → "Deploy" runs
```

**What you'll see in GitHub:**
- On PRs: "Test" workflow appears (must pass to merge)
- After merge: Both "Test" and "Deploy" workflows run on main branch
- Direct pushes to main: Blocked (all changes require PRs)

### Testing the Setup

1. **Create a test branch**:
   ```bash
   git checkout -b test-branch-protection
   ```

2. **Make a small change** (e.g., edit a page):
   ```bash
   echo "Test change" >> website/README.md
   git add website/README.md
   git commit -m "Test branch protection."
   git push -u origin test-branch-protection
   ```

3. **Create a pull request**:
   - Go to: https://github.com/ardell/tedxbreckenridge/pulls
   - Click "New pull request"
   - Select your test branch
   - Create the PR

4. **Watch the tests run**:
   - PR page will show "Checks" section
   - Should see "Test" workflow running
   - Click "Details" to expand and see individual steps: Build Jekyll site, Validate images, HTMLProofer, Stylelint, pa11y-ci
   - Wait for green checkmark

5. **Try to merge before tests complete**:
   - Merge button should be disabled
   - Message: "Merging is blocked - Required status check 'Test' has not succeeded"

6. **After tests pass**:
   - Merge button becomes enabled
   - Click "Merge pull request"
   - Confirm the merge

7. **Verify deployment**:
   - Go to Actions tab
   - See "Test" workflow complete successfully
   - See "Deploy" workflow start automatically
   - Check website after "Deploy" completes

## GitHub Secrets

The following secrets must be configured for GitHub Actions to work:

### AWS_ROLE_ARN

**Location**: https://github.com/ardell/tedxbreckenridge/settings/secrets/actions

**Value**: `arn:aws:iam::119697988135:role/GitHubActionsDeploymentRole`

**Purpose**: Allows GitHub Actions to authenticate to AWS via OIDC and deploy to S3

**How to verify**:
1. Go to secrets page
2. Should see `AWS_ROLE_ARN` listed
3. Value is hidden but should show "Updated X days ago"

**If missing**:
```bash
# Get the role ARN from AWS
aws iam get-role \
  --role-name GitHubActionsDeploymentRole \
  --query 'Role.Arn' \
  --output text \
  --profile tedxbreckenridge-production-admin
```

Then add it via the GitHub UI as described above.

## Dependabot Configuration

Consider enabling Dependabot to keep dependencies up to date:

1. Go to: https://github.com/ardell/tedxbreckenridge/settings/security_analysis

2. Enable:
   - ✅ Dependabot alerts
   - ✅ Dependabot security updates

This will:
- Alert you to vulnerable dependencies
- Automatically create PRs to update gems and npm packages
- Help keep the site secure

## Notifications

Configure notifications for deployment status:

### Email Notifications

GitHub automatically sends emails for:
- Workflow failures
- PR comments and reviews
- Merged PRs

Adjust settings: https://github.com/settings/notifications

### Recommended Settings

- ✅ Participate: Email notifications for conversations you're involved in
- ✅ Watch: Notifications for repository activity
- ✅ Actions: Email on workflow failures

## GitHub Actions Permissions

Current permissions are configured in the workflow file:

```yaml
permissions:
  id-token: write  # Required for OIDC authentication
  contents: read   # Required to checkout code
```

These are minimal permissions following the principle of least privilege.

## Troubleshooting

### "Merge blocked" but tests passed

**Possible causes**:
1. Branch is not up to date with main
   - Solution: Update your branch: `git pull origin main`

2. Required status check name doesn't match
   - Solution: Verify status check is named exactly `Test` (the workflow name)
   - Check: https://github.com/ardell/tedxbreckenridge/settings/branches

3. Conversations not resolved
   - Solution: Resolve all PR comments

### Tests pass locally but fail in CI

**Common causes**:
1. Different Ruby/Node versions
   - CI uses mise to install Ruby 3.4.8
   - Verify local: `ruby --version`

2. Missing files not committed
   - Solution: `git status` and commit missing files

3. External links failing
   - External link check is non-blocking (`continue-on-error: true`)
   - Should not prevent merging

### Emergency Deployments

**If you need to deploy an urgent fix**:

With strict branch protection enabled (recommended), you have two options:

1. **Fast-track a PR** (recommended):
   - Create a PR for your fix
   - Tests run in ~4 minutes
   - Merge immediately after tests pass
   - Deploy runs automatically

2. **Manual trigger** (for true emergencies):
   - Make your fix locally
   - Deploy manually: `./build/website/deploy.sh`
   - Then create a PR to sync the fix to GitHub
   - This bypasses CI but requires AWS credentials

## Summary

Proper GitHub configuration ensures:
- ✅ Code quality through automated testing
- ✅ Safe deployments (tests must pass)
- ✅ Clear workflow (PRs → Tests → Merge → Deploy)
- ✅ Audit trail of all changes
- ✅ Protected production environment

All changes go through the same quality checks, whether from humans or AI assistants.
