# Design — LEAN Competency System

The visual system for this app. Every page redesign reads this file before
emitting code. Do not regenerate per page — extend or amend this file when the
system needs to grow.

> **Amended 2026-10-05** — tokens were replaced wholesale to match
> `SA1 Lean Competency.html`. The previous Hallmark palette
> (`#5B8DEF` accent, Geist, `#FAFBFF` paper) is gone; the values below are
> the single source of truth.

## Genre
modern-minimal

## Macrostructure family
- App pages: **Workbench** — the UI IS the content, function carries the page.
- Sidebar is a floating card (white, 20px radius, soft shadow, 12px inset),
  not a full-bleed coloured rail.

## Theme
| Token | Value | SA1 source |
|---|---|---|
| `--primary` | `#2F4B9E` | `rgb(47,75,158)` |
| `--primary-hover` | `#24407F` | darkened |
| `--primary-light` | `#4062B5` | lightened |
| `--brand-bar` | `#4C6EF5` | `rgb(76,110,245)` — top bar |
| `--brand-tint` | `#EAF0FE` | `rgb(234,240,254)` — active nav fill |
| `--bg` | `#EFF1F8` | `rgb(239,241,248)` |
| `--surface` | `#FFFFFF` | cards, sidebar |
| `--header` | `#EDEFF7` | table header tint |
| `--border` | `#EDEBF7` | `rgb(237,235,247)` |
| `--rule-strong` | `#D8D5EA` | `rgb(216,213,234)` — connectors |
| `--ink` | `#17202B` | `rgb(23,32,43)` |
| `--ink-muted` | `#64717F` | `rgb(100,113,127)` |
| `--ink-dim` | `#B7BFC8` | `rgb(183,191,200)` |

## Typography
- Body: **Plus Jakarta Sans**, weights 400/500/600/700
- Mono: **IBM Plex Mono**, weight 500 — tabular data only (scores, gap values)
- Base size 13px / line-height 1.5, `font-variant-numeric: tabular-nums`
- Display tracking: -0.015em

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

## Shape
- `--radius-card`: 20px — cards, sidebar, editor panel, gap section
- `--radius-ctl`: 7px — nav items, filter buttons
- Pills: 999px; avatars: 50%
- `--shadow-card`: `0 4px 18px rgba(31, 53, 115, 0.07)`

## Motion
- Easings: `cubic-bezier(0.16, 1, 0.3, 1)` named `--ease-out`
- Durations: `--dur-short: 220ms`

## Microinteractions stance
- Silent success (no toasts)
- Hover delay 800 ms
- No bouncy / overshoot easings

## CTA voice
- Primary CTA: filled, 7px radius, `--primary` background, white text
- Secondary CTA: outlined, 7px radius, border colour, ink text
- Nav items: floating pills, `--brand-tint` fill + `--primary` text when active

## Data colors (semantic)
- Level ramp (0–4): `#E8ECF7` → `#C9D3EE` → `#A3B4DE` → `#6C86C4` → `#2F4B9E`
  (derived from `--primary`; SA1 defines no ramp — **append-only, do not reorder**)
- Axis Technical: `#2F4B9E`
- Axis Application: `#F5A66E` (orange)
- Axis Behavioral: `#1F6459` (teal)
- Positive: `#2F7355` · Negative: `#B5493A`
- Evidence flag: `#F5A66E`
- Org-chart tiers: GM `#0E8074`, S.Manager `#1D4ED8`,
  Team leader `#15803D`, Staff `#2F4B9E` — exposed as `--tier-*` tokens, never
  as a JS colour map. (A.Manager `#15803D` was removed 2026-10-07 when the tier
  left the org; its `--tier-amgr` token is gone too)

## Org chart

Redesigned 2026-10-07 to **Design C — leadership spine + team lanes**.
Reporting lines read down a vertical spine on the left; team membership reads
across swimlanes on the right. Two views of the same `ORG_CHART` data, which is
what makes Huy owning both TPM and TECHNOLOGY legible at a glance.

- Split layout: spine `250px` | lanes `minmax(0,1fr)`, collapsing to one column
  at 900 px
- Lanes are `repeat(auto-fit, minmax(196px, 1fr))`, one column at 640 px
- Nodes are real `<button>`s with hover / focus-visible / active / disabled.
  Disabled = the GM, who has no record in `employees` and so has no plan
- Depth is `data-depth` on the spine item — no inline custom properties
- Tier colour is applied purely by `data-org-tier` + `--tier-*`
- Clicking a node preselects that person on the IDP page (`idpPersonId`)
- The previous inline-style tree is archived at `org-chart-legacy-backup.html`;
  `git HEAD` before the redesign also has it

## Hardcoded colour policy
All UI colour must come from a custom property. The remaining literal hex
values in `index.html` are legacy course/status badge fills — migrate them to
tokens when touched; do not add new ones.

## Exports

### tokens.css
```css
:root {
  --primary:       #2F4B9E;
  --primary-hover: #24407F;
  --primary-light: #4062B5;
  --brand-bar:     #4C6EF5;
  --brand-tint:    #EAF0FE;

  --level-0: #E8ECF7;  --level-1: #C9D3EE;  --level-2: #A3B4DE;
  --level-3: #6C86C4;  --level-4: #2F4B9E;

  --bg: #EFF1F8;  --surface: #FFFFFF;  --header: #EDEFF7;
  --border: #EDEBF7;  --row-border: #F3F2FA;  --rule-strong: #D8D5EA;

  --ink: #17202B;  --ink-muted: #64717F;  --ink-dim: #B7BFC8;

  --evidence-flag: #F5A66E;
  --axis-lean: #2F4B9E;  --axis-soft: #1F6459;  --axis-language: #F5A66E;
  --positive: #2F7355;  --negative: #B5493A;

  /* Org-chart tiers */
  --tier-gm: #0E8074;  --tier-smgr: #1D4ED8;
  --tier-lead: #15803D;  --tier-staff: #2F4B9E;

  --radius-card: 20px;  --radius-ctl: 7px;
  --shadow-card: 0 4px 18px rgba(31, 53, 115, 0.07);

  --font: "Plus Jakarta Sans", "Segoe UI", system-ui, sans-serif;
  --mono: "IBM Plex Mono", ui-monospace, monospace;

  --space-3xs: 0.25rem;  --space-2xs: 0.5rem;  --space-xs: 0.75rem;
  --space-sm: 1rem;      --space-md: 1.5rem;  --space-lg: 2rem;
  --space-xl: 3rem;      --space-2xl: 4.5rem;

  --ease-out: cubic-bezier(0.16, 1, 0.3, 1);
  --dur-short: 220ms;
}
```