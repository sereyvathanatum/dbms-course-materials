USE cambodia;
SELECT c.commune_pcode,c.commune_name,c.area_km2 AS commune_area_km2,
 d.district_pcode,d.district_name,d.area_km2 AS district_area_km2,
 p.province_pcode,p.province_name,p.area_km2 AS province_area_km2
FROM commune c JOIN district d ON d.district_pcode=c.district_pcode
JOIN province p ON p.province_pcode=d.province_pcode ORDER BY c.commune_pcode;
