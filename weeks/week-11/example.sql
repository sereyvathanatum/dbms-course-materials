USE cambodia;
PREPARE district_report FROM 'SELECT district_pcode,district_name FROM district WHERE province_pcode=? ORDER BY district_pcode';
SET @province_code=(SELECT MIN(province_pcode) FROM province);
EXECUTE district_report USING @province_code;
DEALLOCATE PREPARE district_report;
