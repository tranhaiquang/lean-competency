# Design — LEAN Competency System

A locked design system for this app. Every page redesign reads this file before
emitting code. Do not regenerate per page — extend or amend this file when the
system needs to grow.

## Genre
modern-minimal

## Macrostructure family
- App pages: **Workbench** — the UI IS the content, function carries the page.
  Variation knobs: sidebar collapsed/expanded, content density (compact/standard).

## Theme
- `--color-paper`:   `#FAFBFF`
- `--color-paper-2`: `#F0F2FC`
- `--color-ink`:     `#1A1D2E`
- `--color-ink-2`:   `#6B7080`
- `--color-rule`:    `#E3E5F0`
- `--color-accent`:  `#5B8DEF`
- `--color-accent-ink`: `#FFFFFF`
- `--color-focus`:   `#5B8DEF`

## Typography
- Display: Geist Sans, weight 600, style normal
- Body:    Geist Sans, weight 400
- Mono:    Geist Mono, weight 500 (tabular data only: gap values, scores)
- Display tracking: -0.025em
- Type scale anchor: text-display = clamp(1.75rem, 2vw + 1rem, 2.25rem)

## Spacing
4-point named scale:
- `--space-3xs`: 0.25rem
- `--space-2xs`: 0.5rem
- `--space-xs`:  0.75rem
- `--space-sm`:  1rem
- `--space-md`:  1.5rem
- `--space-lg`:  2rem
- `--space-xl`:  3rem
- `--space-2xl`: 4.5rem
- `--space-3xl`: 7rem

## Motion
- Easings: cubic-bezier(0.16, 1, 0.3, 1) named `--ease-out`
- Durations: `--dur-short: 220ms`
- Reveal pattern: fade-up stagger on page content load
- Reduced-motion fallback: opacity-only, ≤ 150 ms

## Microinteractions stance
- Silent success (no toasts)
- Hover delay 800 ms
- Focus delay 0 ms
- No bouncy / overshoot easings

## CTA voice
- Primary CTA: filled, 6px radius, accent background, accent-ink text
- Secondary CTA: outlined, 6px radius, rule border, ink text
- Nav items: edge-aligned, left accent border on active, no fill

## Per-page allowances
- App pages MUST NOT use enrichment — function carries the page.
- Dashboard pages MAY use data visualization (gap chart, progress bars).
- All data rendering uses the locked token scale.

## What pages MUST share
- The wordmark / logotype ("LEAN Competency System").
- The accent colour and its placement (sidebar background, active states).
- The display + body fonts (Geist Sans).
- The CTA voice (button shape, border-radius, padding rhythm).
- Section heading rhythm (display heading + muted description pattern).

## What pages MAY differ on
- Content density within the Workbench family.
- Data visualization type (chart vs. table vs. card grid).
- Filter / tab arrangements per page needs.

## Data colors (semantic)
- Level ramp (0–4): `#EEF4FD` → `#D6E4FB` → `#A8C8F7` → `#7AAAF2` → `#5B8DEF`
- Axis Technical: `#5B8DEF` (accent)
- Axis Application: `#FF9F5A` (orange)
- Axis Behavioral: `#2F9E8F` (teal)
- Evidence flag: `#FF9F5A` (orange)
- Active nav border: `#FF9F5A` (orange)

## Exports

### tokens.css
```css
:root {
  --color-paper:      #FAFBFF;
  --color-paper-2:    #F0F2FC;
  --color-ink:        #1A1D2E;
  --color-ink-2:      #6B7080;
  --color-rule:       #E3E5F0;
  --color-accent:     #5B8DEF;
  --color-accent-ink: #FFFFFF;
  --color-focus:      #5B8DEF;

  --font-display: "Geist", ui-sans-serif, system-ui, sans-serif;
  --font-body:    "Geist", ui-sans-serif, system-ui, sans-serif;
  --font-mono:    "Geist Mono", ui-monospace, monospace;

  --space-3xs: 0.25rem;  --space-2xs: 0.5rem;  --space-xs: 0.75rem;
  --space-sm:  1rem;     --space-md:  1.5rem;  --space-lg: 2rem;
  --space-xl:  3rem;     --space-2xl: 4.5rem;  --space-3xl: 7rem;

  --text-xs: 0.75rem;  --text-sm: 0.875rem; --text-md: 1.125rem;
  --text-lg: 1.375rem; --text-xl: 1.75rem;  --text-2xl: 2.25rem;

  --ease-out: cubic-bezier(0.16, 1, 0.3, 1);
  --dur-short: 220ms;
  --radius-card: 6px; --radius-pill: 999px; --radius-input: 4px;
}
```
