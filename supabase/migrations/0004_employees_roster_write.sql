-- ═══════════════════════════════════════════════════════════════
-- 0004_employees_roster_write.sql
-- Lets the Competency Matrix page's "Manage roster" feature push
-- add / delete / team+position changes back to the shared roster.
--
-- HOW TO RUN: Supabase Dashboard → SQL Editor → paste → Run.
-- Idempotent: safe to re-run.
-- ═══════════════════════════════════════════════════════════════
--
-- ⚠ READ THIS BEFORE RUNNING
-- -----------------------------------------------------------------
-- 0001_employees.sql deliberately set employees to "RLS on,
-- default-deny, anon read-only" because the roster is personal data.
-- The roster editor needs write access to work.
--
-- Granting `to anon` makes the roster writable by ANYONE who can load
-- the page, because the anon key ships inside index.html and the site's
-- login is currently bypassed. That means an anonymous visitor could
-- rename, re-team, add or remove anyone on the org chart.
--
--   The tidy fix  → keep RLS on, but make writes require an
--                    authenticated user (see OPTION B below) and wire
--                    Supabase Auth into the app's existing login.
--   The quick fix  → grant anon writes (OPTION A). Convenient, but the
--                    roster becomes publicly editable.
--
-- This migration runs OPTION A so the feature works as requested.
-- If you later add authentication, re-run OPTION B to close it.
-- ─────────────────────────────────────────────────────────────────

-- ── OPTION A (applied here): anon read + write ─────────────────
alter table public.employees enable row level security;

drop policy if exists "anon read employees" on public.employees;
create policy "anon read employees"
  on public.employees for select
  to anon, authenticated
  using (true);

drop policy if exists "anon write employees" on public.employees;
create policy "anon write employees"
  on public.employees for insert
  to anon, authenticated
  with check (true);

drop policy if exists "anon update employees" on public.employees;
create policy "anon update employees"
  on public.employees for update
  to anon, authenticated
  using (true) with check (true);

drop policy if exists "anon delete employees" on public.employees;
create policy "anon delete employees"
  on public.employees for delete
  to anon, authenticated
  using (true);

grant select, insert, update, delete on public.employees
  to anon, authenticated;

-- ═══════════════════════════════════════════════════════════════
-- OPTION B (safe) — run this INSTEAD of the above once Supabase Auth
-- is wired into the app. Writes require a logged-in user; anonymous
-- visitors keep read-only access.
--
--   drop policy if exists "anon write employees" on public.employees;
--   drop policy if exists "anon update employees" on public.employees;
--   drop policy if exists "anon delete employees" on public.employees;
--
--   create policy "auth write employees"
--     on public.employees for insert
--     to authenticated with check (true);
--   create policy "auth update employees"
--     on public.employees for update
--     to authenticated using (true) with check (true);
--   create policy "auth delete employees"
--     on public.employees for delete
--     to authenticated using (true);
--
--   revoke insert, update, delete on public.employees from anon;
-- ═══════════════════════════════════════════════════════════════

-- ── Verify: expect 18 rows before any roster edit ──────────────
select count(*) as rows,
       count(*) filter (where seniority = 'Team leader') as team_leaders,
       count(*) filter (where seniority = 'S.Manager')  as senior_managers
from public.employees;