-- Week 02: Tables, keys and constraints
-- Read from cambodia. Create and change tables only in student_work.
-- Save the output of each task in results/.

-- ----- Lab -----

-- Lab 1: Describe each column of the three tables and explain why its data type fits.
-- TODO

-- Lab 2: In `student_work`, create your own province table with a primary key, NOT NULL columns and a CHECK that the area is positive.
-- TODO

-- Lab 3: Copy the first two provinces (by code) into your table with `INSERT ... SELECT`.
-- TODO

-- Lab 4: Insert one of those two rows again and save the duplicate-key error.
-- TODO

-- Lab 5: Create a district table with a foreign key to your province table. Insert only the districts that belong to your two provinces. Explain why the parent rows must be loaded first.
-- TODO

-- ----- Homework -----

-- Homework 1: Create a commune table with a foreign key to your district table, and insert only the communes that belong to your districts.
-- TODO

-- Homework 2: Run `SHOW CREATE TABLE` on your tables. For each constraint, describe what kind of change it would block.
-- TODO

-- Homework 3: Use ALTER TABLE to add one nullable column to your province table, then DESCRIBE it. Next, try to delete a province that still has districts in your district table, and save the foreign-key error. Explain the difference between ON DELETE RESTRICT and ON DELETE CASCADE.
-- TODO
