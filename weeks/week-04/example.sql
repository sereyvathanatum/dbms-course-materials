-- WEEK-04 Worked Example (w04_food_prices)
USE w04_food_prices;

SELECT price_type, COUNT(*) AS obs_count
FROM food_price
GROUP BY price_type
ORDER BY price_type;
