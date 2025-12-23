# TEDxBreckenridge

Multi-year Jekyll static site repository for TEDxBreckenridge events.

## Structure

Each year has its own independent Jekyll site in a dedicated directory:

```
tedxbreckenridge/
├── 2026/           # TEDxBreckenridge 2026 site
├── 2027/           # TEDxBreckenridge 2027 site (future)
└── scripts/        # Deployment and build scripts
```

## Year-Specific Sites

Each year directory contains:
- Complete Jekyll site with its own theme and style guide
- Independent `_config.yml` configuration
- Year-specific assets, content, and styling
- Dedicated theme based on the year's design

## Prerequisites

- **Ruby 3.4.8** (managed via mise)
- **mise**: [Install mise](https://mise.jdx.dev/getting-started.html)
- AWS CLI configured with appropriate credentials (for deployment)

### Ruby Version Management

This project uses [mise](https://mise.jdx.dev/) for Ruby version management:

```bash
# Install mise (if not already installed)
curl https://mise.run | sh

# Install Ruby 3.4.8
mise install

# Verify
ruby -v  # Should show ruby 3.4.8
```

**Note on Gemsets:** mise doesn't use gemsets like RVM. Instead, each year directory (2026, 2027, etc.) has gems installed locally in `vendor/bundle`, providing better isolation. See [MISE_SETUP.md](MISE_SETUP.md) for details.

## Local Development

To work on a specific year's site:

```bash
cd 2026
bundle install
bundle exec jekyll serve
```

Visit http://localhost:4000 to preview the site.

## Deployment

Each year's site is deployed to its own S3 bucket with CloudFront CDN:

```bash
# Deploy a specific year
./scripts/deploy.sh 2026

# Build only (no deployment)
./scripts/build.sh 2026
```

### AWS Infrastructure

- **S3 Buckets**: `tedxbreckenridge-YEAR` (e.g., `tedxbreckenridge-2026`)
- **CloudFront**: One distribution per year for CDN
- **Domain**: Each year can have its own subdomain or path

## Creating a New Year

```bash
# Copy structure from previous year
cp -r 2026 2027
cd 2027

# Update _config.yml with new year information
# Update style guide and theme
# Clear out old content
```

## Theme & Style Guide

Each year has its own theme directory containing:
- Color palettes
- Typography settings
- Logo and brand assets
- Style guide documentation

See individual year directories for specific design guidelines.
