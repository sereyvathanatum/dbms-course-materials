-- WEEK-02 Worked Example (w02_meteorites)
USE w02_meteorites;

CREATE DATABASE IF NOT EXISTS student_work;
DROP TABLE IF EXISTS student_work.w02_demo;

CREATE TABLE student_work.w02_demo (
    meteorite_id INT PRIMARY KEY,
    name VARCHAR(150) NOT NULL
);

INSERT INTO student_work.w02_demo (meteorite_id, name)
SELECT meteorite_id, name
FROM meteorite_landing
ORDER BY meteorite_id
LIMIT 2;

SELECT meteorite_id, name FROM student_work.w02_demo ORDER BY meteorite_id;
DROP TABLE student_work.w02_demo;
