USE cambodia;
SELECT province_pcode, COUNT(*) AS districts, ROUND(AVG(area_km2),1) AS mean_district_km2
FROM district GROUP BY province_pcode ORDER BY province_pcode;
SELECT province_pcode, province_name, CASE WHEN area_km2 > (SELECT AVG(area_km2) FROM province)
 THEN 'above average' ELSE 'at or below average' END AS area_group
FROM province ORDER BY province_pcode;
