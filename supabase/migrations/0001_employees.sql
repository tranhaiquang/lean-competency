-- ═══════════════════════════════════════════════════════════════
-- 0001_employees.sql
-- Roster imported from: employee_list.csv (20260822 LEAN ORG chart)
-- 18 rows. Scope: table only — index.html still uses hardcoded PEOPLE.
--
-- HOW TO RUN: Supabase Dashboard → SQL Editor → paste → Run.
-- Idempotent: safe to re-run (ON CONFLICT DO UPDATE).
-- ═══════════════════════════════════════════════════════════════

create table if not exists public.employees (
  employee_id  bigint        primary key,          -- CSV "ID", verified unique across all 18 rows
  full_name    text          not null,
  seniority    text,                               -- Team leader | S.Manager | Staff
  team         text,                               -- nullable: CSV row 9 (Nguyễn Minh Quang) is blank
  education    text,
  hometown     text,
  languages    text[]         not null default '{}',
  created_at   timestamptz   not null default now()
);

comment on table public.employees is
  'Lean roster imported from employee_list.csv. Standalone: not yet referenced by index.html.';

-- ── RLS ────────────────────────────────────────────────────────
-- Q5(a) posture: RLS on, default-deny; anon gets an explicit,
-- minimal grant. Read-only for now — writes go through SQL/Dashboard
-- until a write path is designed.
alter table public.employees enable row level security;

drop policy if exists "anon read employees" on public.employees;
create policy "anon read employees"
  on public.employees for select
  to anon, authenticated
  using (true);

-- No INSERT/UPDATE/DELETE policy ⇒ anon cannot modify the roster.

-- ── Data ───────────────────────────────────────────────────────
-- Normalizations applied (flagged as dirty-data branches, defaults chosen):
--   languages : 'VN,EN' | 'VN, EN' | 'VN. ENG'  → {vn,en}
--   education : 'Highschool' → 'High School'
--   team      : blank left as NULL (not guessed)
insert into public.employees
  (employee_id, full_name, seniority, team, education, hometown, languages)
values
  (12080610, 'Nguyễn Thị Thanh Trang',    'Team leader', 'LEAN CI',          'High School', 'HCMC',       '{vn,en}'),
  (14052701, 'Nguyễn Thị Bích Liễu',      'Team leader', 'ADMIN',            'College',     'HCMC',       '{vn,en}'),
  (16031603, 'Võ Thị Thủy Tiên',         'Staff',       'LEAN IE',          'College',     'HCMC',       '{vn,en}'),
  (16111801, 'Trần Thị Mỹ Diễm',         'Staff',       'LEAN CI',          'University',  'Quảng Nam',  '{vn,en}'),
  (21051708, 'Chau Khách Huy',           'Team leader',  'LEAN TECHNOLOGY',  'University',  'An Giang',   '{vn,en}'),
  (22022301, 'Trương Thị Cẩm Tú',        'Staff',       'LEAN IE',          'High School', 'Ca Mau',     '{vn,en}'),
  (23032701, 'Vương Quốc Bảo',           'Team leader', 'LEAN IE',          'High School', 'HCMC',       '{vn,en}'),
  (23040301, 'Nguyễn Minh Quang',        'S.Manager',   NULL,               'University',  'Dong Nai',   '{vn,en}'),
  (24031102, 'Nguyễn Thanh Phương',      'Staff',       'LEAN TPM',         'University',  'HCMC',       '{vn,en}'),
  (24091901, 'Ngô Trần Phương Nguyên',   'Staff',       'LEAN CI',          'University',  'HCMC',       '{vn,en}'),
  (25040201, 'Nguyễn Thanh Bình',        'Staff',       'LEAN CI',          'College',     'HCMC',       '{vn,en}'),
  (25051501, 'Lê Thị Hồng Vân',          'Staff',       'LEAN IE',          'University',  'HCMC',       '{vn,en}'),
  (25102001, 'Phạm Duy Hậu',             'Staff',       'LEAN TPM',         'University',  'HCMC',       '{vn,en}'),
  (25102801, 'Trần Hải Quang',           'Staff',       'LEAN TECHNOLOGY',  'University',  'HCMC',       '{vn,en}'),
  (25110301, 'Nguyễn Thế Quân',          'Staff',       'LEAN CI',          'University',  'HCMC',       '{vn,en}'),
  (26031603, 'Đoàng Huỳnh Minh Trung',   'Staff',       'LEAN TPM',         'College',     'Dong Nai',   '{vn,en}'),
  (26061101, 'Phạm Ngọc Minh',           'Staff',       'LEAN TECHNOLOGY',  'University',  'Hưng Yên',   '{vn,en}'),
  (26070601, 'Hoàng Minh Chiến',          'Staff',       'LEAN TECHNOLOGY',  'University',  'Dong Nai',   '{vn,en}')
on conflict (employee_id) do update set
  full_name  = excluded.full_name,
  seniority  = excluded.seniority,
  team       = excluded.team,
  education  = excluded.education,
  hometown   = excluded.hometown,
  languages  = excluded.languages;
