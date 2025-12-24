# Build Scripts

This directory contains all build scripts and automation tools for the TEDxBreckenridge repository.

## Current Structure

```
build/
├── website/              # Website build and deployment
│   ├── build.sh         # Build Jekyll site
│   ├── serve.sh         # Local development server
│   └── deploy.sh        # Deploy to AWS S3
└── aws/                 # AWS infrastructure scripts
    ├── setup-bucket.sh
    ├── setup-cloudfront.sh
    ├── validate-sso.sh
    └── config/
        ├── infrastructure.conf
        └── cloudfront.conf
```

## Website Scripts

### build.sh
Builds the Jekyll website for production.

```bash
./build/website/build.sh
```

**Output**: `website/_site/` directory with static site files

### serve.sh
Starts a local development server with live reload.

```bash
./build/website/serve.sh
```

**Server**: http://localhost:4000

### deploy.sh
Builds and deploys the website to AWS S3.

```bash
./build/website/deploy.sh
```

**Requirements**:
- AWS CLI installed (`brew install awscli`)
- AWS SSO session active
- S3 bucket configured (see `build/aws/setup-bucket.sh`)

## AWS Scripts

### setup-bucket.sh
Creates and configures an S3 bucket for static website hosting.

### setup-cloudfront.sh
Sets up CloudFront distribution for CDN caching.

### validate-sso.sh
Validates AWS SSO session before deployment.

## Future Automation

As the repository grows, we'll add build scripts for:

### PDF Generation
```
build/pdf/
├── generate-flier.sh
├── generate-grant.sh
├── generate-report.sh
└── pandoc/
    ├── templates/
    └── filters/
```

**Tools**: Pandoc, wkhtmltopdf, or LaTeX for markdown→PDF conversion

### Email Processing
```
build/email/
├── build-email.sh       # Build email HTML
├── inline-css.sh        # Inline CSS for email clients
└── test-email.sh        # Test rendering
```

**Tools**: Juice or similar for CSS inlining

### Validation
```
build/validation/
├── check-links.sh       # Validate all links
├── validate-html.sh     # HTML validation
├── check-images.sh      # Check image references
└── lint-markdown.sh     # Markdown linting
```

### Utilities
```
build/utilities/
├── optimize-images.sh   # Image optimization
├── generate-thumbnails.sh
└── backup.sh           # Backup to Google Drive
```

## Design Principles

1. **Simple over clever**: Scripts should be easy to understand and modify
2. **Self-contained**: Each script should work independently
3. **Clear output**: Show progress and errors clearly
4. **Fail fast**: Exit on errors to prevent cascading issues
5. **Documented**: Include usage instructions in script comments

## Dependencies

### Current
- **mise**: Ruby version management
- **Jekyll**: Static site generator
- **AWS CLI**: Deployment to S3
- **Bash**: Script execution

### Future
- **Pandoc**: Document conversion (markdown→PDF)
- **wkhtmltopdf** or **LaTeX**: PDF rendering
- **Node.js**: Email processing tools

## Adding New Scripts

When adding a new build script:

1. Place it in the appropriate subdirectory (or create a new one)
2. Make it executable (`chmod +x script.sh`)
3. Include clear usage instructions in comments
4. Test thoroughly before committing
5. Update this README with the new script's purpose and usage

## Environment Configuration

Build scripts can reference configuration from:
- `config/organization.yml` - Org details
- `build/aws/config/` - AWS settings
- `website/_config.yml` - Jekyll settings
- Environment variables - For secrets and local overrides

## Running Scripts

All scripts should be run from the repository root:

```bash
# Good
./build/website/build.sh

# Bad (don't cd into build/ directory)
cd build/website && ./build.sh
```

This ensures relative paths work correctly.

## Troubleshooting

### Jekyll build fails
- Check Ruby version: `mise current ruby`
- Install gems: `cd website && bundle install`
- Clear cache: `rm -rf website/.jekyll-cache`

### Deployment fails
- Verify AWS SSO: `./build/aws/validate-sso.sh`
- Check S3 bucket exists: `aws s3 ls s3://tedxbreckenridge-2026`
- Review AWS credentials: `aws configure list`

### Permission errors
- Make sure scripts are executable: `chmod +x build/**/*.sh`
