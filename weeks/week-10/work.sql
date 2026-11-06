-- Week 10: Objects, transactions and security
-- Read from cambodia. Create and change tables only in student_work.
-- Save the output of each task in results/.

USE cambodia;  -- for your own tables, write student_work.table_name

-- ----- Lab -----

-- Lab 1: Create a view of district counts per province in `student_work`.
-- TODO

-- Lab 2: Run `CREATE TABLE student_work.w10_district AS SELECT * FROM cambodia.district;` (no indexes copied). Check `SHOW INDEX`, run EXPLAIN on a `province_pcode` filter, add an index, run EXPLAIN again.
-- TODO

-- Lab 3: Open two sessions and run `START TRANSACTION;` in both. In each, update `student_work.w10_province` where `province_pcode = 'KH01'`, setting the name to its current value. Do A first and don't commit: B waits. Roll back A, then B.
-- TODO

-- Lab 4: Create a procedure that lists districts for an input province code; call it.
-- TODO

-- Lab 5: Create `lab10_province` (copy of provinces), `lab10_audit` and an AFTER DELETE trigger `lab10_deleted` that logs deletes. Delete a row in a transaction, check the audit table, roll back.
-- TODO

-- Lab 6: Self-study: run `SHOW GRANTS;`. On paper, write CREATE USER, GRANT and REVOKE for a SELECT-only app account (`practice` can't run them).
-- TODO

-- ----- Homework -----

-- Homework 1: Explain tasks 3 and 5 with ACID.
-- TODO

-- Homework 2: Submit your view, index, procedure and trigger scripts with output, plus your written GRANT/REVOKE. Why is the audit row rolled back too?
-- TODO

-- Homework 3: Use your view to explain the three levels and data independence.
-- TODO
