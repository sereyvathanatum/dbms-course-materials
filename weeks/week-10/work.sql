-- Week 10: Objects, transactions and security
-- Read from cambodia. Create and change tables only in student_work.
-- Save the output of each task in results/.

-- ----- Lab -----

-- Lab 1: Create a view in `student_work` that shows the number of districts in each province.
-- TODO

-- Lab 2: Copy the district rows with `CREATE TABLE student_work.w10_district AS SELECT * FROM cambodia.district;` (this copies the data but not the keys or indexes). Check `SHOW INDEX FROM student_work.w10_district;`, run EXPLAIN on a query that filters by `province_pcode`, add an index on that column, and run EXPLAIN again. With only 197 rows, the time difference will be very small; compare the plans.
-- TODO

-- Lab 3: Open two SQL sessions and run `START TRANSACTION;` in both. In session A, update one row of your copy and do not commit. In session B, update the same row: it waits for A's lock. Roll back A, let B finish, then roll back B. Describe what happened.
-- TODO

-- Lab 4: Create a procedure that lists the districts of the province code it receives, and call it with a code from the data.
-- TODO

-- Lab 5: Create an AFTER DELETE trigger on your province copy that writes to an audit table. Delete one row inside a transaction, check the audit table, then roll back.
-- TODO

-- Lab 6: Self-study: run `SHOW GRANTS;` for the practice account. Then write (on paper, without running them) the CREATE USER, GRANT and REVOKE statements for an app account that may only SELECT from `cambodia`. The practice account is not allowed to create users or grant privileges.
-- TODO

-- ----- Homework -----

-- Homework 1: Use the ACID properties to explain what you saw in tasks 3 and 5.
-- TODO

-- Homework 2: Submit your view, index, procedure and trigger scripts with their output, plus your written GRANT and REVOKE statements. Note that the audit row is rolled back too, because it was written in the same transaction.
-- TODO

-- Homework 3: Use your view to explain the three-level architecture and data independence.
-- TODO
