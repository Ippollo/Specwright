---
name: design-system
description: Use when choosing color palettes, typography, or UI styles for a new project, designing landing pages or dashboards, or implementing accessibility requirements. Generates full design systems with searchable styles, font pairings, and stack-specific guidelines. For implementation code patterns, see frontend-design.
metadata:
  pattern: generator
---

# Design System - Design Intelligence

Comprehensive design guide for web and mobile applications. Contains 50+ styles, 97 color palettes, 57 font pairings, 99 UX guidelines, and 25 chart types across 9 technology stacks.

## When to Apply

- Designing new UI components or pages
- Choosing color palettes and typography
- Building landing pages or dashboards
- Implementing accessibility requirements

## Quick Start

**Generate a full design system (REQUIRED first step):**

```bash
python3 skills/design-system/scripts/search.py "<product_type> <industry> <keywords>" --design-system [-p "Project Name"]
```

**Example:**

```bash
python3 skills/design-system/scripts/search.py "beauty spa wellness" --design-system -p "Serenity Spa"
```

## Priority Categories

| Priority | Category            | Impact   |
| -------- | ------------------- | -------- |
| 1        | Accessibility       | CRITICAL |
| 2        | Touch & Interaction | CRITICAL |
| 3        | Performance         | HIGH     |
| 4        | Layout & Responsive | HIGH     |
| 5        | Typography & Color  | MEDIUM   |
| 6        | Animation           | MEDIUM   |

## Essential Rules (CRITICAL)

### Accessibility

- Minimum 4.5:1 color contrast for text
- Visible focus rings on interactive elements
- Alt text for images, aria-label for icon buttons

### Touch & Interaction

- Minimum 44x44px touch targets
- Add `cursor-pointer` to clickable elements
- Disable buttons during async operations

### Performance

- Use WebP images with lazy loading
- Check `prefers-reduced-motion`
- Reserve space for async content

## Available Domains

| Domain       | Use For                      |
| ------------ | ---------------------------- |
| `product`    | Product type recommendations |
| `style`      | UI styles, colors, effects   |
| `typography` | Font pairings, Google Fonts  |
| `color`      | Color palettes by product    |
| `landing`    | Page structure, CTA          |
| `chart`      | Chart types, libraries       |
| `ux`         | Best practices               |

**Domain search:**

```bash
python3 skills/design-system/scripts/search.py "<keyword>" --domain <domain>
```

## Available Stacks

`html-tailwind` (default), `react`, `nextjs`, `vue`, `svelte`, `swiftui`, `react-native`, `flutter`, `shadcn`, `jetpack-compose`

**Stack guidelines:**

```bash
python3 skills/design-system/scripts/search.py "<keyword>" --stack html-tailwind
```

## Persist Design System

Save for hierarchical retrieval across sessions:

```bash
python3 skills/design-system/scripts/search.py "<query>" --design-system --persist -p "Project Name"
```

Creates `design-system/MASTER.md` as global source of truth.

---

## Additional Resources

For detailed documentation, see:

- [REFERENCE.md](file:///c:/Projects/specwright/skills/design-system/REFERENCE.md) - Full examples, anti-patterns, checklists
- [Vercel Guidelines](https://raw.githubusercontent.com/vercel-labs/web-interface-guidelines/main/command.md) - Web interface compliance
