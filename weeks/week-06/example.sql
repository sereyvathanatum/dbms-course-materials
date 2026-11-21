-- WEEK-06 Worked Example (w06_olist)
USE w06_olist;

SELECT COUNT(*) AS above_avg_items
FROM order_items
WHERE price > (SELECT AVG(price) FROM order_items);
