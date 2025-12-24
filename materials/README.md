# Materials Directory

This directory houses all non-website branded materials for TEDxBreckenridge, including fliers, email campaigns, grant applications, reports, presentations, and social media assets.

## Philosophy

**Source in Git, Outputs in Google Drive**

- Store source files (markdown, HTML, images) in this repository
- Generate output files (PDFs, rendered emails) via build scripts
- Upload outputs to Google Drive for distribution
- Keep the repository clean and focused on source control

## Current Structure

```
materials/
├── fliers/          # Event fliers, speaker announcements
├── emails/          # Email campaigns and newsletters
├── grants/          # Grant applications and supporting docs
├── reports/         # Annual reports, impact reports, sponsor reports
├── presentations/   # Pitch decks, sponsor presentations
└── social-media/    # Social media assets and campaigns
```

Currently, these directories contain only `.gitkeep` files to preserve the structure in git. As we create materials, we'll add content following the patterns described below.

## Future Organization Pattern

As this directory grows, each material type will follow a similar pattern:

```
materials/<type>/
├── README.md           # Specific guidelines for this type
├── templates/          # Reusable templates
├── components/         # Shared components (headers, footers, etc.)
├── 2025/              # Current year materials
├── 2026/              # Next year materials
└── archive/           # Past years (optional)
```

### Example: Fliers

```
materials/fliers/
├── README.md
├── templates/
│   ├── event-announcement.html
│   ├── speaker-showcase.html
│   └── salon-event.html
├── 2025/
│   ├── main-event/
│   │   ├── content.md          # Text content
│   │   ├── images/             # Flier-specific images
│   │   └── flier.html          # Composed flier
│   └── salon-january/
│       ├── content.md
│       └── flier.html
└── archive/
    └── 2024/
```

## Design System Integration

All materials should reference the centralized design system in `design-system/`:

- **Colors**: Use palette from `design-system/colors.md`
- **Typography**: Follow guidelines in `design-system/typography.md`
- **Logos**: Reference usage rules in `design-system/logos.md`
- **Brand Voice**: Align with tone defined in `design-system/README.md`

This ensures brand consistency across all materials.

## Build Automation (Future)

As we add materials, we'll create build scripts in `build/` to automate generation:

- **PDF Generation**: `build/pdf/generate-flier.sh`, `build/pdf/generate-grant.sh`
- **Email Processing**: `build/email/build-email.sh` (inline CSS, optimize images)
- **Validation**: Scripts to check markdown formatting, image references, broken links

## Workflow (Future)

1. **Create content**: Write markdown files with frontmatter metadata
2. **Add assets**: Place images in material-specific directories
3. **Generate output**: Run build scripts to create PDFs, emails, etc.
4. **Upload**: Scripts automatically upload outputs to Google Drive
5. **Distribute**: Share Google Drive links with team/recipients

## Getting Started

To add a new material type:

1. Create a subdirectory under the appropriate category (fliers/, emails/, etc.)
2. Add a content.md file with your text
3. Include any necessary images
4. Reference the design system for brand consistency
5. As build scripts become available, use them to generate outputs

For now, create materials manually and we'll add automation as needs become clear.

## Questions?

- Design questions → See `design-system/`
- Build automation → See `build/`
- Organizational info → See `config/organization.yml`
- Website → See `website/`
