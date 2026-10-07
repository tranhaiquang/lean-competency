# AGENTS.md

## What this is

Single-file HTML app (`index.html`) — all CSS, JS, and data inline. No build system, no framework, no npm. Open directly in a browser.

## Quick start

```
start index.html
```

No server required. No install steps.

## Key files

- `index.html` — the entire app (CSS + HTML + JS + data)
- `design.md` — Hallmark design system (active spec; app uses Hallmark tokens)

## Architecture

- **8 pages**: Overview, Competency Matrix, Scale, Training Calendar, Courses, Individual Plan, GL Proposals, Exam Scores
- **Rendering**: each page has a `renderXxx(el)` function that writes HTML into `#mainContent`
  - Overview: `renderDashboard(el)` → Org chart → Gap chart → KPI row → Team Trends (3 SVG charts) → By Function → By Tier → Donut → Courses Run
  - Competency Matrix: `renderMatrix(el)` → sticky table with skill headers
  - Scale: `renderScale(el)` → 5-level cards with gradient purple + evidence rules + 2-column core skills & axes
  - Training Calendar: `renderCalendar(el)` → month filter + session cards + detail sidebar
  - Courses: `renderCourses(el)` → year filter + 4 category tables + inline editing
  - Individual Plan: `renderIDP(el)` → person selector → scores by category (2×2 dot grid) + trend chart + gap rankings + certifications + proposals
  - GL Proposals: `renderSurvey(el)` → form (GL name, team, person, priority courses, hours) + submitted proposals table
  - Exam Scores: `renderExam(el)` → period filter + editable scores table
- **Navigation**: `navigate(page)` sets `currentPage`, calls `renderPage()` which switches on page name, wrapped in try-catch
- **State**: all edits stored in `localStorage` (`lean_competency_v20` key)
- **Init order**: `loadState()` → `setLang(lang)` → `renderPage()` → attach sidebar listeners
- **i18n**: `t(vi, en)` helper; `lang` variable toggles Vietnamese/English; sidebar uses `data-i18n` attributes with `updateSidebar()` and `NAV_I18N` map

## Org chart (top of Overview)

Design C — **leadership spine + team lanes**. Reporting lines run down a spine on
the left; team membership runs across swimlanes on the right. Toggled with
`SHOW_ORG_CHART`.

- **Data**: `ORG_CHART` (`root` / `reports` / `teamsUnder` / `above`), `ORG_TEAM_LABEL`
- **Render**: `renderOrgChart()` → `orgSpineHtml()` + `orgLanesHtml()` → `orgNodeHtml()`
- **Helpers**: `orgPlacedIds()` (IDs already drawn as nodes, so nobody is
  listed twice), `orgLeaderOf(team)` (inverts `teamsUnder`; Huy leads both TPM
  and TECHNOLOGY)
- **Styling**: `.orgc-*` CSS classes. Depth is `data-depth`, tier is
  `data-org-tier`. **No inline styles, no colour map in JS** — tier colour comes
  from the `--tier-*` tokens
- **Interaction**: nodes are `<button data-org-person="ID">`. One delegated
  listener in INIT calls `openOrgPanel(id)` — a right-hand drawer
  (`.orgc-panel` + `.orgc-scrim`, `.is-open`) showing the person's summary.
  The panel's primary button sets `idpPersonId` and `navigate('idp')`, where
  `renderIDP` preselects that person. Escape / scrim / × closes the drawer.
- **Structure**: four Team leaders report to the S.Manager: Huy (TPM + TECH),
  Bảo (IE), Trang (CI), Liễu (ADMIN). The ADMIN lane renders as a leader node
  in the spine, not a staff card — the lane itself is skipped because it has no
  unplaced staff.
- **Avatar fallback**: `bindOrgAvatars(el)` attaches `error` listeners after each
  render (the `.orgc-av::after` initial shows through) — never an inline `onerror`
- The GM is not in `PEOPLE`, so his node renders **disabled** — no plan to open
- Previous inline-style tree archived at `org-chart-legacy-backup.html`

## Data (hardcoded JS arrays)

- `PEOPLE` — 19 team members, each with 28 skill scores
- `SKILLS` — 28 competencies (axes: T=Technical, A=Application, C=Behavioral)
- `TARGET` — required levels per team × position
- `COURSES` — 34 courses (VI names); `COURSES_EN` — English translations
- `SCHEDULE` — 24 training sessions (12 months × A/B); `SCHEDULE_EN` — English
- `LEVELS` — 0–4 competency scale definitions
- `SKILL_COURSE` — maps skill index to course code
- `COURSE_CERTS` — maps course code → array of certified person IDs
- `PERIODS` / `PERIOD_LABELS` / `PERIOD_LABELS_EN` — exam period keys and labels

Gap chart, KPIs, and trend charts are computed live from `PEOPLE` vs `TARGET`.

## Auth

**Bypassed** — app loads directly into the dashboard. Login form exists but is skipped.

Credentials (4 accounts):
| User  | Pass     | Role  | Team scope |
|-------|----------|-------|------------|
| Admin | tai123   | admin | all        |
| IE    | nga123   | lead  | IE         |
| CI    | tinh123  | lead  | CI         |
| Tech  | vu123    | lead  | TECH/PE    |

## Editing rules

- All rendering functions reference data arrays directly. If you change a data array's shape, update the matching renderer.
- Vanilla JS only — no libraries, no transpilation.
- CSS uses custom properties (`--primary`, `--ink`, `--border`, etc.) defined in `:root`.
- Hallmark design is active: Geist fonts, cornflower `#5B8DEF` accent, Hallmark paper tokens (`#FAFBFF` bg), blue level ramp `#EEF4FD→#5B8DEF`, orange evidence flag `#FF9F5A`.
- All colors use CSS custom properties — no hardcoded hex in JS render functions.
- Use `data-*` attributes instead of inline `onchange`/`onclick` with string escaping in HTML templates.
- Event listeners attached before `setLang(lang)` so nav works even if `renderPage()` throws.
