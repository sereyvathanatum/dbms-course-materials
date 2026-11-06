USE student_work;
CREATE TABLE IF NOT EXISTS w03_province LIKE cambodia.province;
INSERT INTO w03_province SELECT p.* FROM cambodia.province p
WHERE NOT EXISTS (SELECT 1 FROM w03_province w WHERE w.province_pcode=p.province_pcode);
START TRANSACTION;
DELETE FROM w03_province ORDER BY province_pcode LIMIT 1;
SELECT COUNT(*) AS during_delete FROM w03_province;
ROLLBACK;
SELECT COUNT(*) AS after_rollback FROM w03_province;
SELECT province_pcode, province_name FROM cambodia.province WHERE province_name LIKE 'K%' ORDER BY province_pcode;
