# Week 03: Filtering and safe CRUD

> Printable version: [README.pdf](README.pdf)

**Learning outcomes:** CLO3, CLO6

## Lesson

`WHERE` keeps only the rows that match a condition. Combine conditions with `AND` and `OR`, and use brackets to make the order clear. `IN` matches any value in a list, `BETWEEN` matches a range (both ends included) and `LIKE` matches a text pattern (`'K%'` means "starts with K"). NULL means a value is missing; test it with `IS NULL`, never with `= NULL`.

`INSERT` adds rows, `UPDATE` changes rows and `DELETE` removes rows. Before you run UPDATE or DELETE, run a SELECT with the same WHERE to see which rows will change. While you practise, work inside a transaction: `START TRANSACTION`, make the change, check it, then `ROLLBACK` to undo it. In MySQL, `CREATE TABLE` commits automatically, so create your table before you start the transaction.

## Worked example

Run `example.sql` (see [Run a SQL file](../../setup/README.md#run-a-sql-file)) and read the output. Then open `work.sql`.

<!-- tables:start -->

## Tables for this week

Read from the `cambodia` database and make your changes in `student_work`. PK means primary key and FK means foreign key. Every column is `NOT NULL`. The sample rows are the first two rows of each table, sorted by code.

### `cambodia.province`

| Column | Type | Key | Meaning |
| --- | --- | --- | --- |
| `province_pcode` | `CHAR(4)` | PK | Province code |
| `province_name` | `VARCHAR(100)` |  | Province name (English) |
| `area_km2` | `DECIMAL(12,1)` |  | Area in km², one decimal place |

Sample rows:

| `province_pcode` | `province_name` | `area_km2` |
| --- | --- | --- |
| KH01 | Banteay Meanchey | 6145.9 |
| KH02 | Battambang | 11869.0 |

**Your table:** `example.sql` creates `student_work.w03_province`, a copy of `cambodia.province`. Practise INSERT, UPDATE and DELETE on this copy.

Run `DESCRIBE cambodia.province;` to see a table definition in MySQL. The [data guide](../../data/README.md) explains where the data comes from.

<!-- tables:end -->

## Lab tasks

1. List the provinces whose names start with K, sorted by code.
2. Run one query that returns the smallest (MIN) and the average (AVG) province area. Then use those two values in a BETWEEN filter to list the provinces in that range, sorted by area and code. (In Week 6 you will do this in one query with a subquery.)
3. Count the NULL values in each name and area column of the three tables.
4. Use your own copy of the province table in `student_work` (for example `w03_province` from the example). Inside a transaction, delete the first province and check the row count.
5. Roll back and check that the row is back. In a second transaction, delete the same row, insert it again from `cambodia.province`, then roll back.

## Homework

1. Write six filters that together use AND/OR, IN, BETWEEN, LIKE and IS NULL. Take your values from the data.
2. Use DISTINCT on `province_pcode` in `cambodia.district`, rename columns with AS, and add a calculated column such as `area_km2 * 100 AS area_ha` (1 km² = 100 ha). Compare `COUNT(*)` with `COUNT(DISTINCT province_pcode)`.
3. Explain why UPDATE without WHERE is dangerous. Then, in a transaction on your copy, update one row by its code, setting its name to the value it already has, and roll back.

## Capstone sprint

**C3 / Checkpoint 1:** Submit your proposal: the problem, your eight questions, the data source (publisher, link, licence and date), the scope, schema v0 and a script that imports your data. Do not include personal data.

## Submit

Write your answers in `work.sql` and label each one, for example `-- Lab 3`. Answer the questions in `reflection.md` and save your query output in `results/`. Then commit and push to your repository. See [SUBMISSIONS.md](../../SUBMISSIONS.md) for details.
