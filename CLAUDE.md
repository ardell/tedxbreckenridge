# Claude Code Guidelines for TEDxBreckenridge

This document provides technical guidelines and best practices for AI-assisted development on the TEDxBreckenridge project. For project structure and philosophy, see [README.md](README.md). For brand guidelines, see [design-system/](design-system/).

**Note**: If a local configuration file exists at `~/.claude-local.md`, follow those user-specific preferences in addition to the guidelines below.

---

## Development Principles

### DRY and Maintainability
- **Keep code DRY** (Don't Repeat Yourself) - extract common patterns into reusable components
- **Lean toward systemic solutions** over inline styles to prevent pages from diverging
- **Use Jekyll includes and layouts** for shared UI patterns
- **Centralize styles** in `website/assets/css/main.css` or modular CSS files
- **Avoid inline styles** unless necessary for dynamic content

### Simplicity First
- Don't over-engineer solutions
- Use well-maintained gems/plugins instead of reinventing the wheel
- Only add complexity when it provides clear value
- Suggest useful tools and plugins when appropriate

---

## Code Standards

### HTML/Liquid Templates
- Use semantic HTML5 elements (`<header>`, `<nav>`, `<main>`, `<article>`, `<section>`, `<footer>`)
- Follow Jekyll/Liquid best practices for templating
- Keep Liquid logic simple and readable
- Use Jekyll collections for structured content (speakers, team, etc.)
- Prefer includes (`{% include component.html %}`) for reusable components

### CSS
- Follow BEM or similar naming conventions for clarity
- Use CSS custom properties (variables) for theme values
- Write mobile-first responsive styles
- Group related styles logically
- Comment complex CSS patterns
- Avoid `!important` unless absolutely necessary

### Accessibility
- Follow general accessibility best practices (no strict WCAG level required)
- Use proper heading hierarchy (`<h1>` → `<h2>` → `<h3>`)
- Include `alt` text for all images (descriptive, not decorative)
- Ensure sufficient color contrast for text
- Make interactive elements keyboard accessible
- Use ARIA labels where appropriate
- Test with keyboard navigation

### Browser Support
- Target 99%+ browser support
- Test critical features across modern browsers
- Consider using tools like caniuse to check compatibility
- Graceful degradation for older browsers
- Avoid cutting-edge CSS/JS features without fallbacks

### Overall
- Include a trailing newline at the end of each file unless it will affect the layout (this helps when using `cat` from the command line)

---

## File Organization

### Images
**Location**: `website/assets/images/`

**Naming Convention**: `kebab-case` with descriptive names
- ✅ `speaker-john-doe-headshot.jpg`
- ✅ `hero-mountain-sunset.jpg`
- ✅ `tedx-logo-black.png`
- ❌ `IMG_1234.jpg`
- ❌ `photo1.jpg`

**Directory Structure**: Follow best practices
```
assets/images/
├── logos/              # TEDx logos (black, white variants)
├── speakers/           # Speaker headshots
├── team/               # Team member photos
├── events/             # Event photography
├── heroes/             # Hero/banner images
├── blog/               # Blog post images
└── sponsors/           # Sponsor logos
```

**Dimensions**: Use appropriate sizes for context
- **Hero images**: 1920x1080px or larger (16:9 ratio)
- **Speaker headshots**: 800x800px (1:1 ratio)
- **Thumbnails**: 400x400px (1:1 ratio)
- **Blog headers**: 1200x630px (1.91:1 ratio for social sharing)
- **Sponsor logos**: Variable, but typically 400px wide max

### Image Optimization
**Critical**: All images must be optimized for web before committing

**Tools**:
- **JPEG**: Use `mozjpeg` or similar (quality 85)
- **PNG**: Use `pngquant` or similar
- **Modern formats**: Consider WebP with fallbacks for better compression
- **SVG**: Optimize with SVGO, minify markup

**Process**:
1. Resize images to appropriate dimensions (no larger than needed)
2. Compress with appropriate tool (mozjpeg for JPEG, pngquant for PNG)
3. For photos, JPEG at 85% quality is usually optimal
4. For graphics with transparency, use PNG or WebP
5. Test file sizes - hero images should be <500KB, thumbnails <100KB

---

## SEO Best Practices

**SEO is important for this project** - follow these guidelines carefully:

### Meta Tags
- Include unique `<title>` for every page (50-60 characters)
- Write compelling meta descriptions (150-160 characters)
- Use `jekyll-seo-tag` plugin properly (already installed)
- Set appropriate Open Graph and Twitter Card metadata

### Content Structure
- One `<h1>` per page (page title)
- Logical heading hierarchy (don't skip levels)
- Use descriptive, keyword-rich headings
- Write clear, informative alt text for images

### URLs
- Keep URLs clean and descriptive
- Use Jekyll's permalink structure: `/blog/:title/`
- Avoid dates in URLs (content is evergreen)
- Use hyphens, not underscores

### Performance (affects SEO)
- Optimize images (see Image Optimization above)
- Minimize render-blocking resources
- Enable compression (once we eventually turn on CloudFront)
- Use lazy loading for images below the fold

### Structured Data
- Add JSON-LD structured data for events (Schema.org Event)
- Include breadcrumbs where appropriate
- Mark up articles with Article schema
- Use Organization schema in footer

### Sitemaps & Robots
- Use `jekyll-sitemap` plugin (already installed)
- Ensure sitemap is submitted to Google Search Console
- Create appropriate `robots.txt` if needed

### Internal Linking
- Link related content naturally
- Use descriptive anchor text
- Create clear navigation hierarchy
- Include breadcrumbs on deep pages

---

## Responsiveness

**Most users will be on mobile** - build mobile-first:

### Approach
- Write base styles for mobile (320px+)
- Add media queries for larger screens
- Test at common breakpoints: 640px, 768px, 1024px, 1280px
- Use flexible units (%, em, rem, vw/vh) over fixed px
- Make touch targets at least 44x44px

### Testing
- Test on actual mobile devices when possible
- Use browser dev tools for responsive testing
- Check portrait and landscape orientations
- Verify text is readable without zooming
- Ensure horizontal scrolling is intentional only

### Common Patterns
```css
/* Mobile-first approach */
.container {
  padding: 1rem;
  font-size: 1rem;
}

/* Tablet and up */
@media (min-width: 768px) {
  .container {
    padding: 2rem;
    font-size: 1.125rem;
  }
}

/* Desktop and up */
@media (min-width: 1024px) {
  .container {
    padding: 3rem;
    font-size: 1.25rem;
  }
}
```

---

## Performance Guidelines

### Images
- No super heavy images (hero images <500KB, thumbnails <100KB)
- Use responsive images with `srcset` when appropriate
- Lazy load images below the fold
- Use modern formats (WebP) with fallbacks

### Videos
- **Important**: Don't load too many YouTube embeds at once
- Lazy load video embeds (use thumbnail + click to load)
- Consider facades for embedded videos
- Limit simultaneous embeds to prevent mobile browser crashes
- Use `loading="lazy"` attribute on iframes

### Scripts & Styles
- Minify CSS and JS (use `jekyll-minifier` plugin)
- Defer non-critical JavaScript
- Inline critical CSS for above-the-fold content if needed
- Remove unused CSS

### General
- Enable caching (handled by CloudFront)
- Minimize HTTP requests
- Use CDNs for external resources (Google Fonts)
- Test performance on slow connections

---

## Forms & External Services

### Forms
- **Preferred**: Embed forms directly on the page when possible
- **Fallback**: Button/link to external form for non-embeddable forms
- **Primary service**: Google Forms

### Form Validation
- Use HTML5 validation attributes (`required`, `type="email"`, etc.)
- Provide clear error messages
- Show validation feedback inline
- Make required fields obvious

### External Services
- **Analytics**: Google Analytics (tracking ID in `_config.yml`)
- **Forms**: Google Forms (embed when possible)
- **Tickets**: Ticketsauce (link to external ticketing page)
- **Email Newsletter**: (TBD - likely Google Forms or Mailchimp)

### Examples
```html
<!-- Embedded form (preferred) -->
<iframe src="https://docs.google.com/forms/..." width="100%" height="600"></iframe>

<!-- Link to external form (fallback) -->
<a href="https://forms.gle/..." class="button">Sign Up</a>
```

---

## Content Writing

### Brand Voice
Refer to [design-system/README.md](design-system/README.md) for complete brand voice guidelines.

### Writing Style
- Use active voice
- Keep sentences clear and concise
- Write for the web (scannable, short paragraphs)
- Use contractions naturally ("we're" not "we are")
- Focus on the audience ("you") not ourselves ("we")

### UI Copy
- Button text should be action-oriented ("Get Tickets", "Learn More")
- Error messages should be helpful and friendly
- Navigation labels should be clear and predictable
- Alt text should be descriptive, not decorative

---

## Git Workflow

### Commit Messages
- Use **imperative mood** (as if giving a command)
- Start with a capital letter
- Use a period at the end
- Be specific and descriptive

**Examples**:
- ✅ "Add a 'Get Tickets' button to the homepage header."
- ✅ "Fix speaker image aspect ratio on mobile."
- ✅ "Update FAQ page with new event information."
- ❌ "Updated stuff."
- ❌ "Fixed bug."
- ❌ "Changes to homepage."
- ❌ "Fix speaker image aspect ratio on mobile" (no period at end)

### Commit Strategy
- Break work into reasonable chunks
- Commit progressively with each atomic change
- Each commit should be a complete, working state
- Don't commit broken code
- Don't commit commented-out code (we can always restore it with git)
- Group related changes together

### Example Workflow
```bash
# Feature: Add speaker profiles
git commit -m "Add speaker collection layout."
git commit -m "Create speaker detail page template."
git commit -m "Add first three speaker profiles."
git commit -m "Update speakers page with new grid layout."
```

---

## Dependencies

### Adding Dependencies
- Use well-maintained, popular gems and plugins
- Check last update date and GitHub activity
- Read documentation before adding
- Don't reinvent the wheel
- Don't add unnecessary dependencies

### Current Key Dependencies
```ruby
# Jekyll plugins (in Gemfile)
- jekyll-feed          # RSS feed generation
- jekyll-seo-tag       # SEO meta tags
- jekyll-sitemap       # XML sitemap
- jekyll-redirect-from # URL redirects
- jekyll-minifier      # Minify HTML/CSS/JS
```

### Suggesting New Dependencies
When you identify a useful gem/plugin:
1. Explain what it does
2. Why it's beneficial
3. Maintenance status (last update, stars, downloads)
4. Implementation approach

---

## Testing Checklist

Before committing changes, verify:

### Functionality
- [ ] Page loads without errors
- [ ] All links work correctly
- [ ] Forms submit properly (or link to external forms)
- [ ] Navigation works on all pages
- [ ] Jekyll builds without warnings

### Responsive Design
- [ ] Test at 320px (mobile)
- [ ] Test at 768px (tablet)
- [ ] Test at 1024px+ (desktop)
- [ ] No horizontal scrolling (unless intentional)
- [ ] Touch targets are large enough (44x44px minimum)
- [ ] Text is readable without zooming

### Accessibility
- [ ] Images have alt text
- [ ] Headings follow logical hierarchy
- [ ] Keyboard navigation works
- [ ] Color contrast is sufficient
- [ ] Interactive elements are accessible

### Performance
- [ ] Images are optimized
- [ ] No excessively large files
- [ ] Limited video embeds per page
- [ ] Page loads reasonably fast

### SEO
- [ ] Page has unique title
- [ ] Meta description is present
- [ ] Headings are semantic and descriptive
- [ ] URLs are clean and descriptive
- [ ] Images have descriptive filenames and alt text

### Content
- [ ] Copy follows brand voice guidelines
- [ ] Spelling and grammar are correct
- [ ] Links have descriptive text (not "click here")
- [ ] No lorem ipsum or placeholder text

---

## Build Commands

Quick reference (see [README.md](README.md) for details):

```bash
# Serve locally with live reload
./build/website/serve.sh

# Build for production
./build/website/build.sh

# Deploy to AWS S3
./build/website/deploy.sh
```

---

## Additional Resources

### Internal Documentation
- [README.md](README.md) - Project overview and structure
- [design-system/](design-system/) - Brand guidelines
- [build/README.md](build/README.md) - Build system documentation
- [website/README.md](website/README.md) - Jekyll site details

### External Resources
- [Jekyll Documentation](https://jekyllrb.com/docs/)
- [Liquid Templating](https://shopify.github.io/liquid/)
- [TED Brand Guidelines](https://www.ted.com/about/our-organization/our-policies-terms/ted-brand-guidelines)
- [TEDx Organizer Guide](https://www.ted.com/participate/organize-a-local-tedx-event/tedx-organizer-guide)
- [Google PageSpeed Insights](https://pagespeed.web.dev/)
- [Can I Use](https://caniuse.com/) - Browser compatibility
- [Schema.org](https://schema.org/) - Structured data
- [Web.dev](https://web.dev/) - Performance and best practices

---

**Remember**: Keep code DRY and maintainable. Lean toward systemic solutions over inline styles. Optimize all images before committing. SEO is important - follow best practices carefully.

