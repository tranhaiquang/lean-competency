-- ═══════════════════════════════════════════════════════════════
-- 0002_matrix.sql  ·  Competency Matrix → Supabase
--
-- Single-table, wide design: one row per person per assessment
-- month, with one column per skill holding the 0–4 score.
--
-- Grain:   one row = one person's matrix for one month
-- Size:    19 people × N months
-- Scores:  0–4 = assessed at that level, NULL = not assessed
--
-- Idempotent: safe to re-run.
-- Supabase Dashboard → SQL Editor → paste → Run.
-- ═══════════════════════════════════════════════════════════════

create table if not exists public.competency_matrix (
  -- ── Identity ───────────────────────────────────────────────
  person_id   text        not null,          -- 'LT001' … 'LT018' (PEOPLE[].id)
  period      text        not null,          -- 'YYYY-MM' monthly, 2026-01 → current

  -- ── Cached name (source of truth is the app) ──────────────
  person_name text,

  -- ═══════════════════════════════════════════════════════════
  -- SCORES · 28 skills, 0–4 or NULL
  -- Order matches SKILLS[] in index.html.
  -- ═══════════════════════════════════════════════════════════

  -- A · Kỹ thuật / Technical
  s00_sixs             smallint check (s00_sixs             between 0 and 4),
  s01_waste8           smallint check (s01_waste8           between 0 and 4),
  s02_gemba            smallint check (s02_gemba            between 0 and 4),
  s03_time_study       smallint check (s03_time_study       between 0 and 4),
  s04_vsm              smallint check (s04_vsm              between 0 and 4),
  s05_line_balancing   smallint check (s05_line_balancing   between 0 and 4),
  s06_qco              smallint check (s06_qco              between 0 and 4),
  s07_tpm              smallint check (s07_tpm              between 0 and 4),
  s08_andon            smallint check (s08_andon            between 0 and 4),
  s11_autocad2d        smallint check (s11_autocad2d        between 0 and 4),
  s12_sketchup3d       smallint check (s12_sketchup3d       between 0 and 4),

  -- B · Ứng dụng / Application
  s09_kaizen           smallint check (s09_kaizen           between 0 and 4),
  s10_pdca             smallint check (s10_pdca             between 0 and 4),
  s14_lss_yellow       smallint check (s14_lss_yellow       between 0 and 4),
  s15_lss_green        smallint check (s15_lss_green        between 0 and 4),
  s16_lss_black        smallint check (s16_lss_black        between 0 and 4),

  -- C · Hành vi / Behavioral
  s13_twi              smallint check (s13_twi              between 0 and 4),
  s17_communication    smallint check (s17_communication    between 0 and 4),
  s18_listening        smallint check (s18_listening        between 0 and 4),
  s19_teamwork         smallint check (s19_teamwork         between 0 and 4),
  s20_problem_solving  smallint check (s20_problem_solving  between 0 and 4),
  s21_critical         smallint check (s21_critical         between 0 and 4),
  s22_leadership       smallint check (s22_leadership       between 0 and 4),
  s23_presentation     smallint check (s23_presentation     between 0 and 4),
  s24_feedback         smallint check (s24_feedback         between 0 and 4),
  s25_conflict         smallint check (s25_conflict         between 0 and 4),
  s26_ai               smallint check (s26_ai               between 0 and 4),
  s27_language         smallint check (s27_language         between 0 and 4),

  primary key (person_id, period),
  check (period ~ '^[0-9]{4}-(0[1-9]|1[0-2])$')
);

-- Load path: one query per page load → WHERE period = eq.X
create index if not exists competency_matrix_period_idx
  on public.competency_matrix (period, person_id);

-- RLS: anon full CRUD on this table; everything else stays
-- default-deny. The anon key ships inside index.html, so this
-- policy is the only gate — same posture as the app today.
alter table public.competency_matrix enable row level security;

drop policy if exists "anon full competency_matrix" on public.competency_matrix;
create policy "anon full competency_matrix"
  on public.competency_matrix for all
  to anon, authenticated
  using (true) with check (true);

grant select, insert, update, delete on public.competency_matrix
  to anon, authenticated;

-- ── Verify after running (expect 0 rows — cloud starts clean)
select count(*) as rows, min(period) as first_period, max(period) as last_period
from public.competency_matrix;