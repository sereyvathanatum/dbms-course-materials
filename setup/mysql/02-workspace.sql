-- student_work is where students create their own tables.
CREATE DATABASE student_work CHARACTER SET utf8mb4;
REVOKE ALL PRIVILEGES ON cambodia.* FROM 'practice'@'%';
GRANT SELECT ON cambodia.* TO 'practice'@'%';
GRANT ALL PRIVILEGES ON student_work.* TO 'practice'@'%';
