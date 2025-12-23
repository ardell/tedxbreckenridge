# TEDxBreckenridge 2026 Style Guide

## Theme: Inversion

**"What happens when we flip our assumptions?"**

Inversion is a way of thinking that challenges conventional wisdom. By turning perspectives upside down, we discover insights hidden in plain sight. The 2026 visual identity reflects this concept through inverted perspectives, Northern Lights-inspired colors, and dynamic contrasts.

## Brand Colors

### Core TED Brand
- **TED Red**: `#EB0028` - Official TED brand color (required by license)
- **TED Black**: `#000000` - Primary text and structural elements
- **White**: `#FFFFFF` - Backgrounds and contrast

### 2026 Inversion Palette - Northern Lights Inspired

Our color palette draws inspiration from the Northern Lights (aurora borealis), reflecting the theme of inversion - the moment when day turns to night and nature reveals hidden wonders.

#### Primary Colors
- **Violet**: `#E6DFE3` - Soft twilight base
- **Lilac**: `#9657A3` - Purple aurora glow
- **Twilight**: `#4E4484` - Deep evening purple
- **Aqua**: `#67A1D0` - Cool northern blue
- **Mint**: `#AED2C0` - Fresh arctic green
- **Eclipse**: `#2A4B5B` - Deep night shadow

#### Tints & Variations
- **Violet 80%**: `#EBE5E8` - Lighter backgrounds
- **Mint 40%**: `#D7E9E0` - Subtle accents
- **Aqua 20%**: `#E1EEF6` - Very light highlights
- **Twilight 80%**: `#625799` - Mid-tone purple

### Color Usage Guidelines

1. **Hero Sections**: Use gradient overlays (Twilight → Eclipse) over imagery
2. **Backgrounds**: Alternate between Violet and Mint-40 for section variety
3. **Text**: Eclipse for body text, TED Black for headings
4. **Accents**: Lilac for eyebrows/labels, Aqua for meta information
5. **CTAs**: TED Red for primary actions, Eclipse for secondary

## Typography

### Fonts
- **Primary Font**: Helvetica Neue, Helvetica, Arial, sans-serif (headings, labels)
- **Alternative Font**: Inter (body text, UI elements)

### Type Scale
- **Hero Title**: clamp(56px, 8vw, 88px) - Large, dramatic
- **Hero Date**: clamp(36px, 5vw, 56px) - Emphasis on event
- **Section Title**: clamp(28px, 4vw, 40px) - Section headers
- **Body Text**: 16-17px - Comfortable reading
- **Small Text**: 11-14px - Labels and meta

### Font Weights
- **Light (300)**: Body text, descriptions
- **Regular (400)**: Headings, navigation
- **Medium (500)**: Buttons, eyebrows

### Letter Spacing
- **Headings**: -0.02em to -0.03em (tight)
- **Labels/Eyebrows**: 0.1em to 0.12em (wide, uppercase)
- **Body**: Normal

## Logo Guidelines

### TEDxBreckenridge Logo

Two versions available:
- `tedx-breckenridge-logo-black.png` - Use on light backgrounds
- `tedx-breckenridge-logo-white.png` - Use on dark backgrounds

### Logo Usage
- Height: 60px in navigation, 40px in footer
- Maintain clear space around logo
- Do not modify colors or proportions
- Must use official TEDx logo as provided by TED

## Photography Style

### Image Treatment
- **Filters**: Slight grayscale (20%) on hover transitions to full color
- **Overlays**: Dark gradients (black 70-80% opacity) on imagery
- **Style**: Professional event photography from past TEDx events
- **Source**: Flickr photo collection from previous years

### Photo Banner
- Grid of 5 square photos (1:1 aspect ratio)
- 4px gap between images
- Hover effect: Scale 1.05x transform

## Layout & Spacing

### Grid System
- **Container**: Max-width 1400px
- **Section Padding**: 100px vertical, 48px horizontal
- **Inner Spacing**: 80px gaps between major elements
- **Card Gaps**: 20-24px

### Responsive Breakpoints
- **Desktop**: > 1024px
- **Tablet**: 768px - 1024px
- **Mobile**: < 768px

## Design Elements

### Sections
- **Hero**: Split 50/50 grid (content | visual)
- **Photo Banner**: 5-column grid with hover effects
- **Theme**: 50/50 grid with image overlay
- **Speakers**: 4-column grid (2 on tablet, 1 on mobile)
- **Gallery**: 4-column masonry (large item spans 2x2)
- **Salon**: Asymmetric 1.1:1 grid
- **Support**: 3-column cards
- **Sponsors**: Tiered horizontal layout

### Cards & Components
- **Speaker Cards**: 3:4 aspect ratio, gradient placeholder
- **Support Cards**: Min-height 280px, violet background
- **Buttons**: 14px padding vertical, 28px horizontal

### Hover States
- **Links**: Color shift to Twilight or TED Red
- **Images**: Scale transform or filter change
- **Cards**: Slight translateY(-4px) lift

### Animations
- **Fade In**: 0.6s ease with staggered delays
- **Transform**: translateY(16px) → 0
- **Timing**: 0.2-0.4s for interactions

## Iconography

Simple geometric shapes for support cards:
- ◇ (diamond) - Donate
- ○ (circle) - Volunteer
- □ (square) - Sponsor

## Key Design Principles

1. **Contrast**: Bold juxtaposition of light and dark
2. **Movement**: Animations suggest flipping/inverting
3. **Atmosphere**: Northern Lights color palette creates wonder
4. **Clarity**: Clean typography and generous white space
5. **Depth**: Layered overlays and gradients

## CSS Variables

All colors and fonts are defined as CSS custom properties in `assets/css/main.css`:

```css
:root {
    --ted-red: #EB0028;
    --violet: #E6DFE3;
    --lilac: #9657A3;
    --twilight: #4E4484;
    --aqua: #67A1D0;
    --mint: #AED2C0;
    --eclipse: #2A4B5B;

    --font-primary: 'Helvetica Neue', Helvetica, Arial, sans-serif;
    --font-alt: 'Inter', Arial, sans-serif;
}
```

## Implementation Notes

- Use `relative_url` filter for all asset paths in Jekyll
- Maintain semantic HTML structure
- Ensure WCAG 2.1 AA accessibility standards
- Test across browsers and devices
- Optimize images for web (JPEGs for photos)

## References

- [TED Brand Guidelines](https://www.ted.com/about/our-organization/our-policies-terms/ted-brand-guidelines)
- [TEDx Logo Templates](https://www.ted.com/participate/organize-a-local-tedx-event/tedx-organizer-guide/branding-promotion/logo)
- [Past Event Photos](https://www.flickr.com/photos/tedxbreckenridge/)
