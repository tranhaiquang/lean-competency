-- ═══════════════════════════════════════════════════════════════
-- 0005_auth_permissions.sql
-- Auth-based write permissions for the two accounts you create in
-- Supabase Authentication (one viewer = read-only, one editor = write):
--
--   1) public.app_roles      — the two accounts + their role
--   2) public.is_editor()    — true iff the JWT email has role='editor'
--   3) public.courses        — one row per course (was: localStorage only)
--   4) public.schedule_sessions — one row per session; stable text id
--
-- Then tighten the two existing tables to the same posture as 0004's
-- OPTION B (writes ⇒ editor only, anon keeps read-only):
--   - public.employees          (drop anon write from 0004 OPTION A)
--   - public.competency_matrix  (drop anon full CRUD from 0002)
--
-- HOW TO RUN: Supabase Dashboard → SQL Editor → paste → Run.
-- Idempotent: safe to re-run. The app caches editor role on login;
-- after running this, each user must sign out/in once.
--
-- AFTER RUNNING THIS FILE, insert the accounts (Authentication → Users →
-- Add user for each person, then):
--   insert into public.app_roles (email, role) values
--     ('viewer-email@example.com', 'viewer'),
--     ('editor-email@example.com', 'editor')
--   on conflict (email) do update set role = excluded.role;
-- ═══════════════════════════════════════════════════════════════

-- ── 1) Roles ──────────────────────────────────────────────────
create table if not exists public.app_roles (
  email text primary key,                       -- must equal auth.users email exactly
  role  text not null check (role in ('viewer','editor'))
);

comment on table public.app_roles is
  'App-level write permission for the 2 auth accounts. viewer = read-only, editor = full write. Managed here, not in the app.';

alter table public.app_roles enable row level security;

drop policy if exists "read roles" on public.app_roles;
create policy "read roles"
  on public.app_roles for select
  to anon, authenticated
  using (true);

-- No insert/update/delete policy ⇒ roles change only via SQL/Dashboard.
grant select on public.app_roles to anon, authenticated;

-- ── 2) is_editor() ────────────────────────────────────────────
-- Used by every write policy below. Stable, no side effects.
create or replace function public.is_editor() returns boolean
language sql stable
as $$
  select exists (
    select 1
    from public.app_roles
    where lower(email) = lower(coalesce(auth.jwt() ->> 'email', ''))
      and role = 'editor'
  );
$$;

grant execute on function public.is_editor() to anon, authenticated;

-- ── 3) Courses (one row per course) ───────────────────────────
create table if not exists public.courses (
  code       text primary key,
  position   int  not null,
  axis       text not null default 'A' check (axis in ('A','B','C')),
  tier       text,
  level_from smallint check (level_from between 0 and 4),
  level_to   smallint check (level_to between 0 and 4),
  hours      int  check (hours >= 0),
  category   smallint not null default 0,
  name_vi    text not null,
  name_en    text,
  output_vi  text,
  output_en  text,
  updated_at timestamptz not null default now()
);

alter table public.courses enable row level security;

drop policy if exists "auth read courses" on public.courses;
create policy "auth read courses"
  on public.courses for select
  to authenticated
  using (true);

drop policy if exists "editor write courses" on public.courses;
create policy "editor write courses"
  on public.courses for insert
  to authenticated
  with check (public.is_editor());

drop policy if exists "editor update courses" on public.courses;
create policy "editor update courses"
  on public.courses for update
  to authenticated
  using (public.is_editor()) with check (public.is_editor());

drop policy if exists "editor delete courses" on public.courses;
create policy "editor delete courses"
  on public.courses for delete
  to authenticated
  using (public.is_editor());

grant select, insert, update, delete on public.courses
  to authenticated;

-- ── 4) Schedule sessions (one row per session) ────────────────
-- id is a client-generated stable string ('ses-…'), not a sequence,
-- so the seeded calendar can be pushed idempotently from any browser.
create table if not exists public.schedule_sessions (
  id          text primary key,
  position    int not null,
  month       smallint not null check (month between 1 and 12),
  letter      text not null check (letter in ('A','B')),
  code        text,
  hours       int check (hours >= 0),
  title_vi    text,
  type_vi     text,
  audience_vi text,
  owner_vi    text,
  activity_vi text,
  evidence_vi text,
  title_en    text,
  type_en     text,
  audience_en text,
  owner_en    text,
  activity_en text,
  evidence_en text,
  updated_at  timestamptz not null default now()
);

alter table public.schedule_sessions enable row level security;

drop policy if exists "auth read schedule_sessions" on public.schedule_sessions;
create policy "auth read schedule_sessions"
  on public.schedule_sessions for select
  to authenticated
  using (true);

drop policy if exists "editor write schedule_sessions" on public.schedule_sessions;
create policy "editor write schedule_sessions"
  on public.schedule_sessions for insert
  to authenticated
  with check (public.is_editor());

drop policy if exists "editor update schedule_sessions" on public.schedule_sessions;
create policy "editor update schedule_sessions"
  on public.schedule_sessions for update
  to authenticated
  using (public.is_editor()) with check (public.is_editor());

drop policy if exists "editor delete schedule_sessions" on public.schedule_sessions;
create policy "editor delete schedule_sessions"
  on public.schedule_sessions for delete
  to authenticated
  using (public.is_editor());

grant select, insert, update, delete on public.schedule_sessions
  to authenticated;

-- ── 5) Tighten employees (0004 OPTION B, role-locked) ─────────
drop policy if exists "anon write employees" on public.employees;
drop policy if exists "anon update employees" on public.employees;
drop policy if exists "anon delete employees" on public.employees;

drop policy if exists "editor write employees" on public.employees;
create policy "editor write employees"
  on public.employees for insert
  to authenticated
  with check (public.is_editor());

drop policy if exists "editor update employees" on public.employees;
create policy "editor update employees"
  on public.employees for update
  to authenticated
  using (public.is_editor()) with check (public.is_editor());

drop policy if exists "editor delete employees" on public.employees;
create policy "editor delete employees"
  on public.employees for delete
  to authenticated
  using (public.is_editor());

grant select on public.employees to anon, authenticated;
revoke insert, update, delete on public.employees from anon;
grant insert, update, delete on public.employees to authenticated;

-- ── 6) Tighten competency_matrix (was anon full CRUD) ─────────
drop policy if exists "anon full competency_matrix" on public.competency_matrix;

drop policy if exists "read competency_matrix" on public.competency_matrix;
create policy "read competency_matrix"
  on public.competency_matrix for select
  to anon, authenticated
  using (true);

drop policy if exists "editor write competency_matrix" on public.competency_matrix;
create policy "editor write competency_matrix"
  on public.competency_matrix for insert
  to authenticated
  with check (public.is_editor());

drop policy if exists "editor update competency_matrix" on public.competency_matrix;
create policy "editor update competency_matrix"
  on public.competency_matrix for update
  to authenticated
  using (public.is_editor()) with check (public.is_editor());

drop policy if exists "editor delete competency_matrix" on public.competency_matrix;
create policy "editor delete competency_matrix"
  on public.competency_matrix for delete
  to authenticated
  using (public.is_editor());

grant select on public.competency_matrix to anon, authenticated;
revoke insert, update, delete on public.competency_matrix from anon;
grant insert, update, delete on public.competency_matrix to authenticated;

-- ── Roles: the 3 accounts ─────────────────────────────────────
-- 23040301 (Nguyễn Minh Quang)  & 14052701 (Nguyễn Thị Bích Liễu) → editor
-- 25102801 (Trần Hải Quang)                                     → viewer
insert into public.app_roles (email, role) values
  ('23040301@email.com', 'editor'),
  ('14052701@email.com', 'editor'),
  ('25102801@email.com', 'viewer')
on conflict (email) do update set role = excluded.role;

-- ── Verify ─────────────────────────────────────────────────────
-- select * from public.app_roles;          -- expect your 3 rows
-- select public.is_editor();               -- run as editor JWT → t
-- select count(*) from public.courses;     -- 0 until first save from the app
-- select count(*) from public.schedule_sessions;
