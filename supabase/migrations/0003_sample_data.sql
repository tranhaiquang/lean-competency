-- ═══════════════════════════════════════════════════════════════
-- 0003_sample_data.sql  ·  Sample rows for competency_matrix
--
-- Roster: employee_list.csv (18 people, numeric employee IDs).
-- NOTE: the CSV carries NO skill scores, so the 0–4 values below
-- are illustrative placeholders shaped by each person's seniority:
--   Team leader / Manager → generally 2–4
--   Staff                  → generally 1–3, LSS bands often 0
-- NULL = not assessed.
--
-- 2026-10 = current month  → the live matrix
-- 2026-09 = prior month    → exercises the trend / delta arrows
--
-- Idempotent: re-running updates instead of duplicating.
-- Supabase Dashboard → SQL Editor → paste → Run.
-- ═══════════════════════════════════════════════════════════════

insert into public.competency_matrix (
  person_id, period, person_name,
  s00_sixs, s01_waste8, s02_gemba, s03_time_study, s04_vsm,
  s05_line_balancing, s06_qco, s07_tpm, s08_andon,
  s09_kaizen, s10_pdca,
  s11_autocad2d, s12_sketchup3d,
  s13_twi,
  s14_lss_yellow, s15_lss_green, s16_lss_black,
  s17_communication, s18_listening, s19_teamwork,
  s20_problem_solving, s21_critical, s22_leadership,
  s23_presentation, s24_feedback, s25_conflict,
  s26_ai, s27_language
) values

-- ═══════════════════════════════════════════════════════════
-- Current month: 2026-10  ·  all 18 employees
-- ═══════════════════════════════════════════════════════════

-- ── Leaders & managers ───────────────────────────────────────
('12080610', '2026-10', 'Nguyễn Thị Thanh Trang',   -- Team leader · LEAN CI
   3, 3, 3, 3, 3,
   3, 3, 3, 3,
   4, 4,
   2, 1,
   4,
   4, 2, null,
   3, 3, 4,
   3, 3, 4,
   3, 3, 3,
   3, 4),

('14052701', '2026-10', 'Nguyễn Thị Bích Liễu',     -- Team leader · ADMIN
   3, 3, 2, 3, 3,
   2, 2, 2, 3,
   3, 3,
   2, 1,
   4,
   3, 1, null,
   3, 3, 3,
   3, 3, 3,
   3, 3, 3,
   2, 4),

('21051708', '2026-10', 'Chau Khách Huy',           -- A.Manager · LEAN TECHNOLOGY
   4, 4, 3, 4, 4,
   4, 3, 3, 3,
   4, 4,
   4, 3,
   4,
   4, 3, 1,
   3, 3, 4,
   4, 3, 4,
   4, 3, 3,
   3, 4),

('23032701', '2026-10', 'Vương Quốc Bảo',           -- Team leader · LEAN IE
   3, 3, 3, 3, 2,
   3, 2, 2, 3,
   3, 3,
   3, 2,
   4,
   3, 1, null,
   3, 3, 3,
   3, 3, 3,
   3, 2, 3,
   3, 3),

('23040301', '2026-10', 'Nguyễn Minh Quang',        -- S.Manager · (team blank in CSV)
   4, 3, 3, 3, 3,
   3, 3, 3, 3,
   4, 4,
   3, 2,
   4,
   4, 2, null,
   3, 3, 3,
   3, 3, 4,
   4, 3, 3,
   3, 4),

-- ── LEAN IE staff ────────────────────────────────────────────
('16031603', '2026-10', 'Võ Thị Thủy Tiên',         -- Staff · LEAN IE
   2, 2, 2, 3, 2,
   2, 2, 2, 2,
   2, 2,
   2, 1,
   3,
   2, 0, null,
   2, 2, 2,
   2, 2, 2,
   2, 2, 2,
   2, 3),

('22022301', '2026-10', 'Trương Thị Cẩm Tú',        -- Staff · LEAN IE
   2, 3, 2, 2, 1,
   1, 1, 1, 2,
   2, 2,
   null, null,
   null,
   1, 0, null,
   2, 2, 2,
   2, 1, 1,
   2, 2, 2,
   2, 2),

-- ── LEAN CI staff ────────────────────────────────────────────
('16111801', '2026-10', 'Trần Thị Mỹ Diễm',         -- Staff · LEAN CI
   3, 3, 3, 3, 3,
   3, 2, 3, 2,
   3, 3,
   2, 2,
   3,
   3, 1, null,
   3, 3, 3,
   3, 2, 3,
   3, 3, 3,
   2, 4),

('24091901', '2026-10', 'Ngô Trần Phương Nguyên',   -- Staff · LEAN CI
   2, 2, 2, 2, 2,
   2, 2, 2, 2,
   2, 2,
   2, 1,
   3,
   2, 0, null,
   2, 2, 3,
   2, 2, 2,
   2, 2, 2,
   2, 3),

('25040201', '2026-10', 'Nguyễn Thanh Bình',        -- Staff · LEAN CI
   3, 2, 3, 3, 3,
   3, 3, 2, 3,
   3, 3,
   2, 2,
   3,
   3, 1, null,
   2, 3, 3,
   3, 2, 3,
   2, 2, 2,
   2, 3),

('25110301', '2026-10', 'Nguyễn Thế Quân',          -- Staff · LEAN CI
   1, 2, 2, 2, 1,
   1, 1, 1, 2,
   2, 1,
   null, null,
   null,
   1, 0, null,
   2, 2, 2,
   1, 2, 1,
   2, 1, 2,
   1, 2),

-- ── LEAN TPM staff ───────────────────────────────────────────
('24031102', '2026-10', 'Nguyễn Thanh Phương',      -- Staff · LEAN TPM
   3, 3, 3, 3, 3,
   3, 3, 4, 3,
   3, 3,
   2, 1,
   4,
   3, 1, null,
   3, 3, 3,
   3, 3, 3,
   3, 3, 3,
   3, 4),

('25102001', '2026-10', 'Phạm Duy Hậu',             -- Staff · LEAN TPM
   2, 2, 3, 3, 2,
   2, 3, 3, 2,
   3, 3,
   3, 2,
   4,
   3, 1, null,
   3, 3, 3,
   3, 2, 3,
   3, 3, 2,
   2, 3),

('26031603', '2026-10', 'Đoàng Huỳnh Minh Trung',   -- Staff · LEAN TPM
   2, 2, 2, 2, 1,
   1, 2, 1, 2,
   2, 2,
   null, 1,
   null,
   2, 0, null,
   2, 2, 2,
   2, 2, 2,
   2, 1, 2,
   2, 2),

-- ── LEAN TECHNOLOGY staff ────────────────────────────────────
('25102801', '2026-10', 'Trần Hải Quang',           -- Staff · LEAN TECHNOLOGY
   2, 2, 2, 3, 2,
   2, 2, 3, 3,
   2, 3,
   3, 2,
   3,
   2, 1, null,
   2, 2, 2,
   2, 2, 2,
   2, 2, 2,
   3, 3),

('26061101', '2026-10', 'Phạm Ngọc Minh',           -- Staff · LEAN TECHNOLOGY
   3, 3, 2, 3, 3,
   3, 2, 2, 2,
   3, 3,
   3, 2,
   3,
   3, 1, null,
   3, 3, 3,
   3, 2, 3,
   2, 3, 2,
   3, 3),

('26070601', '2026-10', 'Hoàng Minh Chiến',          -- Staff · LEAN TECHNOLOGY
   2, 3, 2, 2, 2,
   2, 2, 2, 2,
   2, 2,
   2, 1,
   null,
   2, 0, null,
   2, 3, 2,
   2, 2, 2,
   2, 2, 1,
   2, 3),

-- ═══════════════════════════════════════════════════════════
-- Prior month: 2026-09  → shows ▲ deltas on a few cells
-- ═══════════════════════════════════════════════════════════

('12080610', '2026-09', 'Nguyễn Thị Thanh Trang',
   2, 3, 3, 3, 3,
   3, 3, 3, 3,
   3, 4,
   2, 1,
   4,
   3, 2, null,
   3, 3, 4,
   3, 3, 3,
   3, 3, 3,
   3, 3),

('23032701', '2026-09', 'Vương Quốc Bảo',
   2, 3, 3, 3, 2,
   3, 2, 2, 3,
   3, 3,
   3, 2,
   4,
   3, 1, null,
   3, 3, 3,
   3, 3, 3,
   3, 2, 3,
   3, 2),

('16111801', '2026-09', 'Trần Thị Mỹ Diễm',
   2, 3, 2, 3, 2,
   3, 2, 3, 2,
   3, 3,
   2, 2,
   3,
   3, 1, null,
   3, 3, 3,
   2, 2, 3,
   3, 2, 3,
   2, 3),

('24031102', '2026-09', 'Nguyễn Thanh Phương',
   2, 3, 2, 3, 3,
   3, 3, 4, 3,
   3, 3,
   2, 1,
   4,
   3, 1, null,
   3, 3, 3,
   3, 3, 3,
   3, 3, 3,
   3, 3),

('21051708', '2026-09', 'Chau Khách Huy',
   3, 4, 3, 4, 4,
   4, 3, 3, 3,
   4, 4,
   4, 3,
   4,
   4, 3, 1,
   3, 3, 4,
   3, 3, 4,
   4, 3, 3,
   3, 3),

('26070601', '2026-09', 'Hoàng Minh Chiến',
   2, 2, 2, 2, 2,
   2, 2, 2, 2,
   2, 2,
   2, 1,
   null,
   2, 0, null,
   2, 3, 2,
   2, 2, 2,
   2, 2, 1,
   2, 3)

on conflict (person_id, period) do update set
  person_name = excluded.person_name,
  s00_sixs            = excluded.s00_sixs,
  s01_waste8          = excluded.s01_waste8,
  s02_gemba           = excluded.s02_gemba,
  s03_time_study      = excluded.s03_time_study,
  s04_vsm             = excluded.s04_vsm,
  s05_line_balancing  = excluded.s05_line_balancing,
  s06_qco             = excluded.s06_qco,
  s07_tpm             = excluded.s07_tpm,
  s08_andon           = excluded.s08_andon,
  s09_kaizen          = excluded.s09_kaizen,
  s10_pdca            = excluded.s10_pdca,
  s11_autocad2d       = excluded.s11_autocad2d,
  s12_sketchup3d      = excluded.s12_sketchup3d,
  s13_twi             = excluded.s13_twi,
  s14_lss_yellow      = excluded.s14_lss_yellow,
  s15_lss_green       = excluded.s15_lss_green,
  s16_lss_black       = excluded.s16_lss_black,
  s17_communication   = excluded.s17_communication,
  s18_listening       = excluded.s18_listening,
  s19_teamwork        = excluded.s19_teamwork,
  s20_problem_solving = excluded.s20_problem_solving,
  s21_critical        = excluded.s21_critical,
  s22_leadership      = excluded.s22_leadership,
  s23_presentation    = excluded.s23_presentation,
  s24_feedback        = excluded.s24_feedback,
  s25_conflict        = excluded.s25_conflict,
  s26_ai              = excluded.s26_ai,
  s27_language        = excluded.s27_language;

-- ── Verify (expect 24 rows: 18 for 2026-10, 6 for 2026-09)
select period, person_id, person_name,
       (select count(*) from unnest(array[
          s00_sixs, s01_waste8, s02_gemba, s03_time_study, s04_vsm,
          s05_line_balancing, s06_qco, s07_tpm, s08_andon, s09_kaizen,
          s10_pdca, s11_autocad2d, s12_sketchup3d, s13_twi,
          s14_lss_yellow, s15_lss_green, s16_lss_black,
          s17_communication, s18_listening, s19_teamwork, s20_problem_solving,
          s21_critical, s22_leadership, s23_presentation, s24_feedback,
          s25_conflict, s26_ai, s27_language
       ]) x(v) where v is not null) as assessed_skills
from public.competency_matrix
order by period desc, person_id;