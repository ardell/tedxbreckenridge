# Email Templates

This directory contains HTML email templates for TEDxBreckenridge campaigns.

## Naming Convention

`YYYY-MM-description.html`

Example: `2026-01-salon-elevated-cuisine.html`

## Previewing Emails

To preview emails in your browser with test values substituted:

```bash
yarn install        # First time only
yarn emails:preview
```

This generates preview files in `_previews/` with Mailchimp merge tags replaced by values from `preview-values.yml`.

Open the generated files directly in your browser to see how the email will look.

## Usage with Mailchimp

1. Open the HTML file in a text editor
2. Copy the entire contents
3. In Mailchimp, create a new campaign
4. Choose "Code your own" template option
5. Paste the HTML into the code editor
6. The template includes Mailchimp merge tags for:
   - `*|ARCHIVE|*` - View in browser link
   - `*|IF:FNAME|*` / `*|FNAME|*` - Personalized greeting
   - `*|FORWARD|*` - Forward to friend link
   - `*|UPDATE_PROFILE|*` - Update preferences link
   - `*|UNSUB|*` - Unsubscribe link
   - `*|LIST:ADDRESS|*` - Mailing address (required by law)

## Subject Line Best Practices

- **Keep it short**: Aim for <50 characters (mobile shows ~30-40)
- **Front-load key info**: Put the most important words first
- **Include date**: Helps with event urgency
- **Avoid spam triggers**: Don't use ALL CAPS or excessive punctuation

Example:
- ❌ "You're invited — TEDxBreckenridge Salon: Elevated Cuisine (Jan 15)" (61 chars)
- ✅ "You're invited — TEDxBreckenridge Salon Jan 15" (47 chars)

## Brand Guidelines

All templates follow the TEDxBreckenridge brand guidelines:

### Colors
- TED Red: `#e62b1e` (CTAs, accents)
- Charcoal: `#2A2A2A` (body text, dark backgrounds)
- Stone: `#6B6B6B` (secondary text)
- Cream: `#F5F3F0` (backgrounds)
- Forest: `#4A7470` (links, highlights - WCAG AA compliant)
- Teal Light: `#A3C4C4` (footer links on dark backgrounds)

### Typography
- Primary: Helvetica, Arial, sans-serif
- Body: 16px, line-height 1.6
- Headings: Bold weight

### Logo
Use the hosted logo URL: `https://tedxbreckenridge.com/assets/images/logos/tedx-breckenridge-logo-black.png`

## Testing

Before sending, test emails using:
- [Litmus](https://litmus.com) or [Email on Acid](https://emailonacid.com)
- Mailchimp's built-in preview and test send features
- Send test emails to Gmail, Outlook, and Apple Mail

## Email Templates

| File | Recommended Subject | Purpose |
|------|---------------------|---------|
| `2026-01-salon-elevated-cuisine.html` | You're invited — TEDxBreckenridge Salon Jan 15 | Salon event invitation |
