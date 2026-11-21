-- WEEK-03 Worked Example (w03_aviation)
USE w03_aviation;

SELECT ident, airport_name, scheduled_service
FROM airport
WHERE country_code = 'KH' AND airport_type = 'large_airport'
ORDER BY ident;
