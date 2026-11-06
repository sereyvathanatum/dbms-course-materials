USE student_work;
CREATE TABLE IF NOT EXISTS w02_province (
 province_pcode CHAR(4) PRIMARY KEY, province_name VARCHAR(100) NOT NULL,
 area_km2 DECIMAL(12,1) NOT NULL CHECK (area_km2 > 0));
INSERT INTO w02_province SELECT p.* FROM cambodia.province p
WHERE p.province_pcode IN (SELECT province_pcode FROM
 (SELECT province_pcode FROM cambodia.province ORDER BY province_pcode LIMIT 2) AS chosen)
AND NOT EXISTS (SELECT 1 FROM w02_province w WHERE w.province_pcode=p.province_pcode);
SELECT * FROM w02_province ORDER BY province_pcode;
