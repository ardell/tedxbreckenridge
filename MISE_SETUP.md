# Mise Setup for TEDxBreckenridge

This project uses [mise](https://mise.jdx.dev/) for Ruby version management.

## Quick Start

```bash
# Install mise if you haven't already
curl https://mise.run | sh

# Install Ruby 3.4.8
mise install

# Verify Ruby version
ruby -v  # Should show ruby 3.4.8
```

## Mise vs RVM Gemsets

### Does mise support gemsets?

**No**, mise doesn't have built-in gemset support like RVM. However, you don't need it because:

1. **Bundler provides better isolation**: Each year directory (2026, 2027, etc.) has its own `Gemfile` and installs gems locally in `vendor/bundle`

2. **Per-project gem isolation**: The `.bundle/config` in each year directory ensures gems are installed locally, not globally

3. **Cleaner approach**: No need to remember to switch gemsets - just `cd` into the year directory and run `bundle install`

## How It Works

### Traditional RVM Approach
```bash
rvm use ruby-3.4.8@tedxbreckenridge-2026
cd 2026
bundle install
```

### Mise + Bundler Approach (Simpler)
```bash
cd 2026
bundle install  # Installs to ./vendor/bundle automatically
```

## Project Structure

```
tedxbreckenridge/
├── .mise.toml           # Ruby version (3.4.8) for entire project
├── .ruby-version        # Backup for other tools
├── 2026/
│   ├── .bundle/
│   │   └── config       # Bundle config: install to vendor/bundle
│   ├── vendor/bundle/   # Gems installed here (gitignored)
│   ├── Gemfile
│   └── Gemfile.lock
├── 2027/
│   ├── .bundle/
│   │   └── config
│   ├── vendor/bundle/   # Separate gems for 2027
│   ├── Gemfile
│   └── Gemfile.lock
```

## Benefits Over RVM Gemsets

1. **Automatic**: No need to create or switch gemsets
2. **Visible**: You can see exactly what gems are installed (in vendor/bundle)
3. **Portable**: Works with any Ruby version manager (mise, rbenv, asdf, etc.)
4. **Standard**: This is the recommended Bundler approach
5. **CI/CD friendly**: Easier to set up in Docker, GitHub Actions, etc.

## Initial Setup for Each Year

When creating a new year (e.g., 2027):

```bash
# Create the year directory
./scripts/new-year.sh 2027

# Set up bundler config
mkdir -p 2027/.bundle
cat > 2027/.bundle/config <<EOF
---
BUNDLE_PATH: "vendor/bundle"
BUNDLE_DISABLE_SHARED_GEMS: "true"
EOF

# Install gems
cd 2027
bundle install
```

## Common Commands

```bash
# Install Ruby version specified in .mise.toml
mise install

# Check current Ruby version
mise current ruby
mise exec -- ruby -v

# Run Jekyll for a specific year (two options)
# Option 1: Use helper script (recommended)
./scripts/serve.sh 2026

# Option 2: Manual
cd 2026
mise exec -- bundle exec jekyll serve

# Update gems for a specific year
cd 2026
mise exec -- bundle update

# Clean up gems
cd 2026
rm -rf vendor/bundle Gemfile.lock
mise exec -- bundle install
```

## Important: Using `mise exec`

When running commands in the terminal, you may need to use `mise exec --` to ensure you're using the project's Ruby version:

```bash
# This might use the wrong Ruby version
bundle exec jekyll serve  # ❌ May use Ruby 3.4.7

# This ensures correct Ruby version
mise exec -- bundle exec jekyll serve  # ✅ Uses Ruby 3.4.8
```

Alternatively, ensure mise is properly integrated in your shell:

```bash
# Add to ~/.zshrc or ~/.bashrc
eval "$(mise activate zsh)"  # or bash

# Then restart your shell
source ~/.zshrc
```

## Upgrading Ruby Version

```bash
# Update .mise.toml
# Change: ruby = "3.4.8"
# To:     ruby = "3.5.0"

# Install new version
mise install ruby@3.5.0

# Reinstall gems for each year
cd 2026
rm -rf vendor/bundle .bundle
bundle install

cd ../2027
rm -rf vendor/bundle .bundle
bundle install
```

## Troubleshooting

### Gems installing to wrong location

```bash
cd 2026
bundle config --local path vendor/bundle
bundle install
```

### Ruby version not detected

```bash
# Make sure you're using mise shell integration
echo 'eval "$(mise activate zsh)"' >> ~/.zshrc  # or ~/.bashrc
source ~/.zshrc
```

### Want to use system Ruby temporarily

```bash
mise uninstall ruby
# Or just use the full path: /usr/bin/ruby
```

## Why Mise?

Compared to RVM:
- **Faster**: Written in Rust, much faster than RVM
- **Polyglot**: Manages Node.js, Python, Go, etc., not just Ruby
- **Simpler**: Single `.mise.toml` file, no complex RC files
- **Modern**: Active development, supports latest Ruby versions quickly
- **Standard format**: Uses `.tool-versions` (compatible with asdf)

Compared to rbenv:
- **Built-in installation**: `mise install` - no need for ruby-build plugin
- **Environment variables**: Can set env vars in `.mise.toml`
- **More tools**: Manages many languages, not just Ruby

## Additional Resources

- [mise documentation](https://mise.jdx.dev/)
- [Bundler deployment docs](https://bundler.io/guides/deploying.html)
- [Jekyll installation guide](https://jekyllrb.com/docs/installation/)
