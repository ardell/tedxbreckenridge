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
       - `test` (this is the test job from `.github/workflows/deploy.yml`)

   - ✅ **Require conversation resolution before merging**
     - Ensures all PR comments are addressed

   - ✅ **Do not allow bypassing the above settings**
     - Even admins must follow these rules

4. Click **"Create"** to save the rule

### What This Does

With branch protection enabled:

1. **Direct pushes to `main` are blocked**
   - All changes must go through pull requests

2. **Tests must pass**
   - HTML validation
   - Link checking
   - Image size validation
   - CSS linting
   - Accessibility testing

3. **Pull requests show test status**
   - Green checkmark = tests passed, safe to merge
   - Red X = tests failed, must fix before merging

4. **Automatic deployment**
   - Once PR is merged, tests run again
   - If tests pass, site deploys automatically

### Workflow

**Before branch protection:**
```
Push to main → Tests run → Deploy (even if tests fail)
```

**After branch protection:**
```
Create PR → Tests run → ❌ Tests fail → Fix issues → ✅ Tests pass → Merge PR → Deploy
```

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
   - Should see "test" check running
   - Wait for green checkmark

5. **Try to merge before tests complete**:
   - Merge button should be disabled
   - Message: "Merging is blocked - Required status check has not succeeded"

6. **After tests pass**:
   - Merge button becomes enabled
   - Click "Merge pull request"
   - Confirm the merge

7. **Verify deployment**:
   - Go to Actions tab
   - See deploy job running
   - Check website after deployment completes

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
   - Solution: Verify status check is named exactly `test`
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

### Branch protection accidentally locked yourself out

**If you can't push to main and need to bypass**:

1. Temporarily disable branch protection:
   - Go to: https://github.com/ardell/tedxbreckenridge/settings/branches
   - Click "Edit" on the main branch rule
   - Uncheck "Do not allow bypassing"
   - Save changes

2. Make your urgent fix and push to main

3. Re-enable strict branch protection immediately after

**Better approach**: Create a PR even for urgent fixes. Tests run faster than you think (~5 minutes).

## Summary

Proper GitHub configuration ensures:
- ✅ Code quality through automated testing
- ✅ Safe deployments (tests must pass)
- ✅ Clear workflow (PRs → Tests → Merge → Deploy)
- ✅ Audit trail of all changes
- ✅ Protected production environment

All changes go through the same quality checks, whether from humans or AI assistants.
