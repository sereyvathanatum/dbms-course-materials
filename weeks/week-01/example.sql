USE cambodia;
SELECT VERSION() AS engine_version;
SELECT province_pcode, province_name, area_km2 FROM province ORDER BY area_km2 DESC, province_pcode LIMIT 5;
SELECT 'province' AS source_table, COUNT(*) AS row_count FROM province
UNION ALL SELECT 'district', COUNT(*) FROM district
UNION ALL SELECT 'commune', COUNT(*) FROM commune;
