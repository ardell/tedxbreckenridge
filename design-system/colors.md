# Color Palette

## Brand Colors (Permanent)

These colors are core to the TEDx brand and must be used consistently:

| Color | Hex | RGB | Usage |
|-------|-----|-----|-------|
| **TED Red** | `#e62b1e` | 230, 43, 30 | Logo, primary CTAs, brand accent |
| **Black** | `#000000` | 0, 0, 0 | Logo text on light backgrounds |
| **White** | `#FFFFFF` | 255, 255, 255 | Logo text on dark backgrounds, page backgrounds |

---

## Current Website Color Palette

Earth tones and natural colors inspired by the Colorado mountains:

### Warm Tones
| Color | Hex | RGB | Usage |
|-------|-----|-----|-------|
| **Terracotta** | `#C75B4D` | 199, 91, 77 | Primary warm accent, section highlights |
| **Terracotta Light** | `#E6A199` | 230, 161, 153 | Lighter warm accent, hover states |
| **Rust** | `#B8503F` | 184, 80, 63 | Deep warm accent, emphasis |

### Cool Tones
| Color | Hex | RGB | Usage |
|-------|-----|-----|-------|
| **Teal** | `#5B8E8E` | 91, 142, 142 | Primary cool accent, links |
| **Teal Light** | `#A3C4C4` | 163, 196, 196 | Lighter cool accent, backgrounds |
| **Forest** | `#4A7470` | 74, 116, 112 | Deep cool accent, depth |

### Neutrals
| Color | Hex | RGB | Usage |
|-------|-----|-----|-------|
| **Charcoal** | `#2A2A2A` | 42, 42, 42 | Primary text, headlines |
| **Stone** | `#6B6B6B` | 107, 107, 107 | Secondary text, captions |
| **Cream** | `#F5F3F0` | 245, 243, 240 | Light backgrounds, cards |
| **Cream Dark** | `#EAE7E3` | 234, 231, 227 | Slightly darker cream |
| **Sand** | `#E8E6E3` | 232, 230, 227 | Subtle backgrounds |
| **Sand Light** | `#F2F0ED` | 242, 240, 237 | Very light backgrounds |

---

## Implementation

The website uses CSS custom properties (variables) defined in `website/assets/css/main.css`:

```css
:root {
    /* Brand Colors */
    --ted-red: #e62b1e;
    --ted-black: #000000;
    --white: #FFFFFF;

    /* Warm Tones */
    --terracotta: #C75B4D;
    --terracotta-light: #E6A199;
    --rust: #B8503F;

    /* Cool Tones */
    --teal: #5B8E8E;
    --teal-light: #A3C4C4;
    --forest: #4A7470;

    /* Neutrals */
    --charcoal: #2A2A2A;
    --stone: #6B6B6B;
    --cream: #F5F3F0;
    --cream-dark: #EAE7E3;
    --sand: #E8E6E3;
    --sand-light: #F2F0ED;
}
```

Reference these variables in your CSS:
```css
.element {
    color: var(--ted-red);
    background: var(--cream);
}
```

---

## Color Usage Guidelines

### Accessibility
- Maintain minimum contrast ratio of 4.5:1 for body text
- Use Charcoal or Stone for text on light backgrounds
- Use White for text on dark backgrounds (Charcoal, Forest, Teal)
- Test all color combinations for readability

### Hierarchy
- **TED Red**: Use sparingly for primary CTAs and important elements
- **Terracotta/Teal**: Use for section accents and highlights
- **Charcoal/Stone**: Use for text hierarchy (headlines vs. body)
- **Cream/Sand**: Use for backgrounds and subtle separation

### Consistency
- Always use the defined CSS variables (never hardcode hex values)
- Maintain color meaning across the site (e.g., Teal always for links)
- Keep warm and cool tones balanced

### Gradients
The hero section uses a gradient combining warm and cool tones:
```css
background: linear-gradient(135deg, rgba(199,91,77,0.85) 0%, rgba(91,142,142,0.9) 100%);
```

---

## Future Themes

When creating a new annual theme, you may introduce additional accent colors while maintaining:
1. TED Red as the primary brand color
2. Black and white for logo usage
3. The neutral palette (charcoal, stone, cream, sand) for text and backgrounds

Document new theme colors in a `theme-YEAR.md` file in this directory.
