-- WEEK-11 Worked Example (w11_movielens)
USE w11_movielens;

PREPARE w11_demo FROM 'SELECT movie_id, title, release_year FROM movie WHERE movie_id = ?';
SET @id = 2;
EXECUTE w11_demo USING @id;
DEALLOCATE PREPARE w11_demo;
