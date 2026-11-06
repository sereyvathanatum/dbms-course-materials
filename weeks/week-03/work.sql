-- Week 03: Filtering and safe CRUD
-- Read from cambodia. Create and change tables only in student_work.
-- Save the output of each task in results/.

USE cambodia;  -- for your own tables, write student_work.table_name

-- ----- Lab -----

-- Lab 1: List provinces whose names start with K, sorted by code.
-- TODO

-- Lab 2: Get the MIN and AVG province area, then use those values in BETWEEN to list provinces in that range. (Week 6 does this in one query.)
-- TODO

-- Lab 3: Count NULLs in each name and area column.
-- TODO

-- Lab 4: In a transaction, delete the first province from your copy (e.g. `w03_province`) and check the count.
-- TODO

-- Lab 5: Roll back and check the row is back. Then delete and re-insert it from `cambodia.province` in a new transaction, and roll back.
-- TODO

-- ----- Homework -----

-- Homework 1: Write six filters that use AND/OR, IN, BETWEEN, LIKE and IS NULL.
-- TODO

-- Homework 2: List the distinct `province_pcode` values in `cambodia.district`. Separately, show each district's code and `area_km2 * 100 AS area_ha` (AS renames a column). Compare `COUNT(*)` with `COUNT(DISTINCT province_pcode)`.
-- TODO

-- Homework 3: Why is UPDATE without WHERE dangerous? Update one row of your copy to its current name in a transaction, then roll back.
-- TODO
