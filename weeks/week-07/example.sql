USE cambodia;
SELECT COUNT(*) AS orphan_districts FROM district d LEFT JOIN province p
ON p.province_pcode=d.province_pcode WHERE p.province_pcode IS NULL;
SELECT COUNT(*) AS orphan_communes FROM commune c LEFT JOIN district d
ON d.district_pcode=c.district_pcode WHERE d.district_pcode IS NULL;
