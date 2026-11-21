-- student_work is where students create their own practice tables, views,
-- procedures, and triggers.
-- Granting full local privileges to 'practice'@'%' allows students to import
-- any week's dataset.sql (w01_cambodia .. w11_movielens) directly from DBeaver.
CREATE DATABASE IF NOT EXISTS student_work
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

GRANT ALL PRIVILEGES ON *.* TO 'practice'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
