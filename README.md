# TEDxBreckenridge

Central repository for all TEDxBreckenridge branded assets, including the website, design system, and various materials (fliers, emails, grants, reports, presentations).

## Philosophy

**One repository, many assets. Source in git, outputs elsewhere.**

This repository manages all TEDxBreckenridge branded materials with a focus on:
- Single evolving website (no year-based versioning)
- Centralized design system accessible to all materials
- Source control for content, with generated outputs stored in Google Drive
- Automation to streamline repetitive tasks
- Clear organization that scales as the project grows

## Repository Structure

```
tedxbreckenridge/
├── website/              # Main Jekyll website (single evolving site)
├── design-system/        # Brand guidelines (text documentation)
├── materials/            # Non-website branded materials
│   ├── fliers/
│   ├── emails/
│   ├── grants/
│   ├── reports/
│   ├── presentations/
│   └── social-media/
├── build/                # Build scripts and automation
│   ├── website/         # Website build, serve, deploy
│   └── aws/             # AWS infrastructure scripts
├── config/               # Shared configuration files
└── docs/                 # Repository documentation
```

### Directory Overview

- **website/** - Single Jekyll site that evolves over time. Contains all pages, posts, collections, assets, and layouts. No year-based directories.

- **design-system/** - Text-based brand guidelines split into focused documents: brand overview, logo usage, typography, colors, and theme details. Images stay in website/assets/.

- **materials/** - Source files for fliers, emails, grants, reports, and other branded materials. Currently contains directory structure with .gitkeep files; will expand as materials are created.

- **build/** - Build scripts organized by output type. Currently includes website build/serve/deploy and AWS setup. Will expand to include PDF generation, email processing, and validation tools.

- **config/** - Minimal shared configuration (organization info). Jekyll config stays in Jekyll; only truly shared config lives here.

## Quick Start

### Prerequisites

- **Ruby 3.4.8** (managed via mise)
- **mise**: [Install mise](https://mise.jdx.dev/getting-started.html)
- **AWS CLI** with SSO configured (for deployment)

```bash
# Install mise (if not already installed)
curl https://mise.run | sh

# Install Ruby 3.4.8
mise install

# Verify
ruby -v  # Should show ruby 3.4.8
```

### Local Development

Start the local development server:

```bash
./build/website/serve.sh
```

Visit http://localhost:4000 to preview the site with live reload.

### Building

Build the production site:

```bash
./build/website/build.sh
```

Output: `website/_site/` directory

### Deployment

Deploy to AWS S3:

```bash
./build/website/deploy.sh
```

**Requirements**:
- AWS CLI installed
- AWS SSO session active
- S3 bucket configured

See [build/README.md](build/README.md) for detailed build documentation.

## Design System

The design system provides brand guidelines for all TEDxBreckenridge materials:

- **[Brand Overview](design-system/README.md)** - Mission, values, voice & tone
- **[Logo Usage](design-system/logos.md)** - Logo configurations, clearspace, dos & don'ts
- **[Typography](design-system/typography.md)** - Typeface specifications and usage
- **[Colors](design-system/colors.md)** - Brand colors and theme palettes
- **[Current Theme](design-system/theme-2025.md)** - 2025 Metamorphosis theme details

All materials (website, fliers, emails, etc.) should reference these guidelines to maintain brand consistency.

## Long-Term Vision

This reorganization sets the foundation for TEDxBreckenridge to manage all branded assets in a single, well-organized repository.

### Current State (Immediate)
- ✅ **Website**: Single evolving Jekyll site (no year-based versioning)
- ✅ **Design System**: Text-based brand guidelines accessible to all materials
- ✅ **Materials**: Directory structure in place, ready for future content
- ✅ **Build System**: Website build, serve, and deployment automation

### Near-Term Growth (Next 6-12 months)
- **Materials Expansion**: Add templates and content for:
  - Fliers (event announcements, speaker showcases)
  - Email campaigns (newsletters, announcements)
  - Grant applications (standardized templates)
  - Annual reports and impact reports
  - Sponsor materials and presentations
- **Build Automation**: Add scripts to generate PDFs from markdown using Pandoc
- **Email Templates**: HTML email templates with inlined CSS for email clients

### Long-Term Vision (1-2 years)
- **Unified Brand Management**: All materials reference centralized design system
- **Automation Pipeline**:
  - Markdown/HTML source → Generated PDFs → Google Drive
  - Automated email campaign generation
  - Social media asset generation
- **Template Library**: Reusable components across all material types
- **Historical Archive**: Past years' materials preserved without cluttering active work
- **Contributor-Friendly**: Clear structure makes it easy for team members to add content

### Key Principles
1. **Source Control Everything**: All source files in git, outputs to Google Drive
2. **Single Source of Truth**: Design system guides all materials
3. **Automation Over Manual Work**: Build scripts handle repetitive tasks
4. **Clarity Over Cleverness**: Simple, obvious structure anyone can navigate
5. **Grow Organically**: Add complexity only when needed

## Working with Materials

See [materials/README.md](materials/README.md) for detailed information on creating and managing branded materials.

### Future Workflow

1. **Create content**: Write markdown files with frontmatter metadata
2. **Add assets**: Place images in material-specific directories
3. **Reference design system**: Use brand guidelines for colors, typography, logos
4. **Generate output**: Run build scripts to create PDFs, emails, etc.
5. **Upload**: Scripts automatically upload outputs to Google Drive
6. **Distribute**: Share Google Drive links with team/recipients

As we create materials, we'll build automation to streamline this process.

## Configuration

Configuration is kept minimal and distributed appropriately:

- **Jekyll config**: `website/_config.yml` (website-specific settings)
- **Organization info**: `config/organization.yml` (shared across materials)
- **AWS settings**: `build/aws/config/` (deployment configuration)

See [config/README.md](config/README.md) for configuration philosophy.

## Contributing

When adding new materials or functionality:

1. **Materials**: Create content in the appropriate `materials/` subdirectory
2. **Build Scripts**: Add automation to `build/` when patterns emerge
3. **Documentation**: Update relevant README files
4. **Design System**: Reference existing guidelines or propose updates

Keep the structure simple and add complexity only when it provides clear value.

## AWS Infrastructure

The website is deployed to AWS S3 with CloudFront CDN:

- **S3 Bucket**: `tedxbreckenridge-2026` (static website hosting)
- **CloudFront**: CDN for caching and performance
- **Region**: us-west-1

See [docs/AWS_SETUP.md](docs/AWS_SETUP.md) for infrastructure setup details.

## Additional Documentation

- [Build System](build/README.md) - Detailed build script documentation
- [Materials](materials/README.md) - Creating and managing branded materials
- [Design System](design-system/README.md) - Brand guidelines overview
- [Configuration](config/README.md) - Configuration philosophy
- [Quick Start Guide](QUICK_START.md) - Detailed setup and usage
- [Mise Setup](MISE_SETUP.md) - Ruby version management details

## Repository Evolution

This repository has evolved from a year-based structure to a unified approach:

**Previous**: Separate directories for each year (2026/, 2027/, etc.)
**Current**: Single evolving website with materials organized by type, not year

This change supports:
- Simplified maintenance (one website, not many)
- Centralized design system
- Broader scope (not just website, but all branded materials)
- Better version control (git history shows evolution)
- Clearer organization (materials by type, archived by year within each type)

---

*TEDxBreckenridge: Ideas Worth Spreading in the High Rockies*

