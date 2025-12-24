# TEDxBreckenridge 2026

Jekyll static site for TEDxBreckenridge 2026.

## Quick Start

### Installation

```bash
# Install dependencies
bundle install
```

### Local Development

**Important:** Use `mise exec` to ensure you're using the correct Ruby version (3.4.8):

```bash
# Start the development server
mise exec -- bundle exec jekyll serve

# With live reload
mise exec -- bundle exec jekyll serve --livereload

# Or use the helper script
../scripts/serve.sh
```

Visit http://localhost:4000 to preview the site.

### Building for Production

```bash
# Build the site
mise exec -- bundle exec jekyll build

# Or with environment variable
JEKYLL_ENV=production mise exec -- bundle exec jekyll build
```

The built site will be in the `_site/` directory.

## Project Structure

```
2026/
├── _config.yml           # Jekyll configuration
├── _layouts/             # Page layouts
│   ├── default.html
│   ├── home.html
│   └── page.html
├── _speakers/            # Speaker profiles (collection)
├── _team/                # Team member profiles (collection)
├── assets/
│   └── css/
│       └── main.css      # Main stylesheet
├── style-guide/          # Theme and design guidelines
│   ├── README.md
│   ├── logos/
│   ├── images/
│   └── mockups/
├── index.html            # Homepage
├── about.md              # About page
├── speakers.md           # Speakers listing
├── tickets.md            # Tickets page
└── contact.md            # Contact page
```

## Content Management

### Adding Speakers

Create a new file in `_speakers/` directory:

```markdown
---
layout: page
title: Speaker Name
tagline: One-line description
image: /assets/images/speakers/speaker-name.jpg
talk_title: "Talk Title"
---

Speaker bio and information here.
```

### Adding Team Members

Create a new file in `_team/` directory:

```markdown
---
layout: page
title: Team Member Name
role: Role/Position
image: /assets/images/team/member-name.jpg
---

Team member bio here.
```

### Updating Event Details

Edit `_config.yml` to update:
- Event date
- Venue information
- Theme
- Social media links

## Theme Customization

See the [Style Guide](style-guide/README.md) for information about:
- Brand colors and palette
- Typography
- Logo usage guidelines
- Photography style
- Design principles

To customize styles, edit `assets/css/main.css`.

## Deployment

The site is deployed to AWS S3 with CloudFront CDN.

### Deploy to Production

From the root of the repository:

```bash
# Build and deploy
../scripts/deploy.sh 2026
```

See the [main README](../README.md) for detailed deployment instructions.

## Resources

- [Jekyll Documentation](https://jekyllrb.com/docs/)
- [TED Brand Guidelines](https://www.ted.com/about/our-organization/our-policies-terms/ted-brand-guidelines)
- [TEDx Organizer Guide](https://www.ted.com/participate/organize-a-local-tedx-event/tedx-organizer-guide)
