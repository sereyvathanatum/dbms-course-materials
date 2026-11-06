-- Week 02: Tables, keys and constraints
-- Read from cambodia. Create and change tables only in student_work.
-- Save the output of each task in results/.

USE cambodia;  -- for your own tables, write student_work.table_name

-- ----- Lab -----

-- Lab 1: Explain the data type of each column in the three tables.
-- TODO

-- Lab 2: Create `student_work.lab02_province` with a PK, NOT NULL columns and `CHECK (area_km2 > 0)`.
-- TODO

-- Lab 3: Copy the first two provinces by code into it with `INSERT ... SELECT`.
-- TODO

-- Lab 4: Insert one of them again and save the duplicate-key error.
-- TODO

-- Lab 5: Create `student_work.lab02_district` with an FK to `lab02_province` and load only matching districts. Why load parents first?
-- TODO

-- ----- Homework -----

-- Homework 1: Create `student_work.lab02_commune` with an FK to `lab02_district` and load only matching communes.
-- TODO

-- Homework 2: Run `SHOW CREATE TABLE` and say what each constraint blocks.
-- TODO

-- Homework 3: Add a nullable column to `lab02_province` with ALTER TABLE. Then delete a province that still has districts in `lab02_district` and save the FK error. Explain ON DELETE RESTRICT vs CASCADE.
-- TODO
