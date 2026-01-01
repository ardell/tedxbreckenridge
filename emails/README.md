# Email Templates

Email templates are now managed through Jekyll, just like the website.

## Location

Email templates live in `website/_emails/` (not this directory).

## Previewing Emails

Start the Jekyll development server:

```bash
./build/website/serve.sh
```

Then visit http://localhost:4000/emails/ to see all email templates.

Each email preview page includes:
- **Preview mode**: Shows the email with Mailchimp merge tags substituted with test values
- **Source mode**: Click "View Source HTML" to see and copy the raw HTML for Mailchimp

## Creating a New Email

1. Create a new `.html` file in `website/_emails/`:

```bash
touch website/_emails/2026-02-new-email.html
```

2. Add front matter at the top:

```yaml
---
title: "Your Email Title"
date: 2026-02-01
subject: "Recommended subject line for Mailchimp"
description: "Brief description of this email"
---
```

3. Add your email HTML below the front matter (including `<!DOCTYPE html>`)

4. Use Mailchimp merge tags as usual:
   - `*|FNAME|*` - Subscriber's first name
   - `*|IF:FNAME|*...*|ELSE:|*...*|END:IF|*` - Conditional content
   - `*|ARCHIVE|*` - View in browser link
   - `*|UNSUB|*` - Unsubscribe link
   - `*|UPDATE_PROFILE|*` - Update preferences link
   - `*|FORWARD|*` - Forward to friend link
   - `*|LIST:ADDRESS|*` - Mailing address

## Preview Values

Preview values are configured in `website/_data/email_preview.yml`. Edit this file to change the test data shown in email previews.

## Sending via Mailchimp

1. Start the dev server and visit the email preview
2. Click "View Source HTML"
3. Click "Copy HTML"
4. In Mailchimp, create a new campaign
5. Choose "Code your own" template
6. Paste the HTML

## Brand Guidelines

All templates should follow the TEDxBreckenridge brand guidelines in `design-system/README.md`.

### Colors
- TED Red: `#e62b1e` (CTAs, accents)
- Charcoal: `#2A2A2A` (body text, dark backgrounds)
- Stone: `#6B6B6B` (secondary text)
- Cream: `#F5F3F0` (backgrounds)
- Forest: `#4A7470` (links, highlights)
- Teal Light: `#A3C4C4` (footer links on dark backgrounds)

### Typography
- Primary: Helvetica, Arial, sans-serif
- Body: 16px, line-height 1.6

### Logo
Use the hosted logo URL: `https://tedxbreckenridge.com/assets/images/logos/tedx-breckenridge-logo-black.png`

## Production Builds

Email templates are **not** included in production builds. They're only available during local development.
