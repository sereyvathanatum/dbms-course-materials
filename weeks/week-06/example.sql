USE cambodia;
WITH totals AS (SELECT province_pcode, COUNT(*) AS district_count FROM district GROUP BY province_pcode)
SELECT province_pcode, district_count FROM totals
WHERE district_count > (SELECT AVG(district_count) FROM totals) ORDER BY province_pcode;
SELECT p.province_pcode FROM province p WHERE EXISTS
 (SELECT 1 FROM district d WHERE d.province_pcode=p.province_pcode) ORDER BY p.province_pcode;
