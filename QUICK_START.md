# TEDxBreckenridge - Quick Start Guide

## Prerequisites

- **Ruby 3.4.8** (managed via mise)
- **mise**: [Install mise](https://mise.jdx.dev/getting-started.html)

```bash
# Install mise (if not already installed)
curl https://mise.run | sh

# Install Ruby 3.4.8
mise install

# Verify
ruby -v  # Should show ruby 3.4.8
```

## 🚀 Running the Site (3 Options)

### Option 1: Helper Script (Easiest)
```bash
./build/website/serve.sh
```

### Option 2: Manual with mise exec
```bash
cd website
mise exec -- bundle exec jekyll serve --livereload
```

### Option 3: After Shell Integration
```bash
# First time setup - add to ~/.zshrc
eval "$(mise activate zsh)"
source ~/.zshrc

# Then you can use directly
cd website
bundle exec jekyll serve --livereload
```

## 📍 View Your Site

Visit: http://localhost:4000

## 🎨 What You'll See

The complete TEDxBreckenridge 2026 "Inversion" homepage with:
- Hero section with event details (October 3, 2026)
- Photo banner with past event images
- Theme explanation
- Speaker placeholders (8 cards)
- Past events gallery
- Salon information
- Support/Get Involved section
- Sponsors section
- Newsletter signup
- Full navigation and footer

## 📁 Key Files

```
2026/
├── index.html              # Homepage (fully implemented)
├── assets/
│   ├── css/main.css       # Complete Inversion theme styles
│   └── images/            # Logos + 10 event photos
├── _config.yml            # Event details & configuration
└── style-guide/README.md  # Complete design system
```

## 🎨 Inversion Theme Colors

Northern Lights-inspired palette:
- **Violet** `#E6DFE3` - Backgrounds
- **Lilac** `#9657A3` - Accents
- **Twilight** `#4E4484` - Deep purple
- **Aqua** `#67A1D0` - Cool blue
- **Mint** `#AED2C0` - Fresh green
- **Eclipse** `#2A4B5B` - Dark teal
- **TED Red** `#EB0028` - CTAs

## 🛠️ Common Tasks

### Make Changes to Content
Edit files in `2026/`, Jekyll auto-reloads with `--livereload`

### Update Event Details
Edit `2026/_config.yml`

### Customize Styles
Edit `2026/assets/css/main.css`

### Add Speaker
Create file in `2026/_speakers/` (see README for format)

### Build for Production
```bash
cd 2026
JEKYLL_ENV=production mise exec -- bundle exec jekyll build
```

### Deploy to AWS
```bash
./scripts/deploy.sh 2026
```

## 🔧 Troubleshooting

### Ruby version errors
```bash
cd 2026
rm -rf vendor/bundle Gemfile.lock
mise exec -- bundle install
```

### Port already in use
```bash
# Kill existing Jekyll server
pkill -f jekyll
# Or use a different port
mise exec -- bundle exec jekyll serve --port 4001
```

### Gems not found
```bash
cd 2026
mise exec -- bundle install
```

## 📚 Documentation

- **MISE_SETUP.md** - Complete guide to mise and Ruby version management
- **IMPLEMENTATION.md** - Details of what was implemented
- **2026/README.md** - Year-specific documentation
- **2026/style-guide/README.md** - Complete design system

## 🎯 Next Steps

1. **Run the site**: `./scripts/serve.sh 2026`
2. **Preview at**: http://localhost:4000
3. **Customize**: Edit content in `2026/`
4. **Add speakers**: Create files in `2026/_speakers/`
5. **Deploy**: Set up AWS (see `docs/AWS_SETUP.md`)

---

**Ready to go!** Start the server and check out your new site! 🎉
