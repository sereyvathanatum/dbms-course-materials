USE cambodia;
SELECT d.district_pcode, d.district_name, p.province_name
FROM district d JOIN province p ON p.province_pcode=d.province_pcode
ORDER BY d.district_pcode LIMIT 10;
SELECT p.province_pcode, p.province_name, COUNT(d.district_pcode) AS district_count
FROM province p LEFT JOIN district d ON d.province_pcode=p.province_pcode
GROUP BY p.province_pcode, p.province_name ORDER BY p.province_pcode;
