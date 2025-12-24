# Configuration Files

This directory contains shared configuration files that apply across multiple asset types (website, materials, etc.).

## Philosophy

**Keep it minimal:** Only store configuration here that is truly shared across multiple parts of the repository.

- **Jekyll-specific config** stays in `website/_config.yml`
- **Event-specific details** stay in Jekyll config (year, date, theme, etc.)
- **AWS deployment config** stays in `build/aws/config/`

## Files

### organization.yml

Contains core organizational information that might be referenced across various materials:
- Organization name and contact details
- Social media accounts
- Team contact information
- 501(c)(3) status and tax information

This file provides a single source of truth for organizational details that appear on the website, in grant applications, on fliers, etc.

## Usage

Reference these configuration files from your build scripts, templates, or other materials as needed. For example:

```bash
# In a build script
source config/organization.yml
```

```yaml
# In a Jekyll data file
organization: <%= YAML.load_file('config/organization.yml') %>
```

## Adding New Config

Before adding a new configuration file here, ask:
1. Is this truly shared across multiple asset types?
2. Does it belong in a more specific location (Jekyll config, build config, etc.)?
3. Will this make it easier or harder to maintain?

If the answer points to shared configuration, add it here with clear documentation.
