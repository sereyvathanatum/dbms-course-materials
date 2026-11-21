-- WEEK-01 Worked Example (w01_cambodia)
USE w01_cambodia;

SELECT province_pcode, province_name, area_km2
FROM province
ORDER BY province_pcode
LIMIT 3;
