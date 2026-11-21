-- WEEK-08 Worked Example (w08_normalization)
USE w08_normalization;

SELECT COUNT(*) AS multi_genre_movies
FROM raw_movies
WHERE genres LIKE '%|%';
