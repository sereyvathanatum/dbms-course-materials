USE student_work;
CREATE OR REPLACE VIEW w10_district_counts AS SELECT province_pcode, COUNT(*) AS district_count
FROM cambodia.district GROUP BY province_pcode;
DROP PROCEDURE IF EXISTS w10_districts;
DELIMITER //
CREATE PROCEDURE w10_districts(IN code CHAR(4)) READS SQL DATA
BEGIN SELECT district_pcode,district_name FROM cambodia.district WHERE province_pcode=code ORDER BY district_pcode; END//
DELIMITER ;
SET @code=(SELECT MIN(province_pcode) FROM cambodia.province);
CALL w10_districts(@code);
SELECT * FROM w10_district_counts ORDER BY province_pcode;
CREATE TABLE IF NOT EXISTS w10_province LIKE cambodia.province;
INSERT INTO w10_province SELECT p.* FROM cambodia.province p WHERE NOT EXISTS
(SELECT 1 FROM w10_province w WHERE w.province_pcode=p.province_pcode);
CREATE TABLE IF NOT EXISTS w10_audit (province_pcode CHAR(4), deleted_at TIMESTAMP(6) NOT NULL);
DROP TRIGGER IF EXISTS w10_deleted;
CREATE TRIGGER w10_deleted AFTER DELETE ON w10_province FOR EACH ROW
INSERT INTO w10_audit VALUES (OLD.province_pcode,CURRENT_TIMESTAMP(6));
START TRANSACTION;
DELETE FROM w10_province ORDER BY province_pcode LIMIT 1;
SELECT province_pcode FROM w10_audit ORDER BY province_pcode;
ROLLBACK;
SELECT COUNT(*) AS audit_rows_after_rollback FROM w10_audit;
