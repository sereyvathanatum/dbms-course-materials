-- Week 03: Filtering and safe CRUD
-- Read from cambodia. Create and change tables only in student_work.
-- Save the output of each task in results/.

-- ----- Lab -----

-- Lab 1: List the provinces whose names start with K, sorted by code.
-- TODO

-- Lab 2: Run one query that returns the smallest (MIN) and the average (AVG) province area. Then use those two values in a BETWEEN filter to list the provinces in that range, sorted by area and code. (In Week 6 you will do this in one query with a subquery.)
-- TODO

-- Lab 3: Count the NULL values in each name and area column of the three tables.
-- TODO

-- Lab 4: Use your own copy of the province table in `student_work` (for example `w03_province` from the example). Inside a transaction, delete the first province and check the row count.
-- TODO

-- Lab 5: Roll back and check that the row is back. In a second transaction, delete the same row, insert it again from `cambodia.province`, then roll back.
-- TODO

-- ----- Homework -----

-- Homework 1: Write six filters that together use AND/OR, IN, BETWEEN, LIKE and IS NULL. Take your values from the data.
-- TODO

-- Homework 2: Use DISTINCT on `province_pcode` in `cambodia.district`, rename columns with AS, and add a calculated column such as `area_km2 * 100 AS area_ha` (1 km² = 100 ha). Compare `COUNT(*)` with `COUNT(DISTINCT province_pcode)`.
-- TODO

-- Homework 3: Explain why UPDATE without WHERE is dangerous. Then, in a transaction on your copy, update one row by its code, setting its name to the value it already has, and roll back.
-- TODO
