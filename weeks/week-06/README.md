# Week 06: Subqueries and CTEs

> Printable version: [README.pdf](README.pdf)

**Learning outcomes:** CLO3, CLO6

## Lesson

Some questions need two steps: first calculate something, then use it. A **subquery** is a query inside another query.

- A scalar subquery returns one value: `WHERE area_km2 > (SELECT AVG(area_km2) FROM province)`.
- `IN (subquery)` checks whether a value is in the list the subquery returns.
- `EXISTS (subquery)` checks whether at least one matching row exists. Unlike a join, it never repeats the outer rows.
- A **correlated** subquery uses a value from the outer row, so it is evaluated for each outer row.

A **derived table** is a subquery in the FROM clause, with a name. A **CTE** (`WITH name AS (...)`) does the same job but puts the first step at the top, which makes long queries easier to read. When you write the same question in two ways, compare the outputs to check that they match.

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

### `cambodia.district`

| Column | Type | Key | Meaning |
| --- | --- | --- | --- |
| `district_pcode` | `CHAR(6)` | PK | District code |
| `district_name` | `VARCHAR(100)` |  | District name (English) |
| `area_km2` | `DECIMAL(12,1)` |  | Area in km², one decimal place |
| `province_pcode` | `CHAR(4)` | FK | Province code |

Sample rows:

| `district_pcode` | `district_name` | `area_km2` | `province_pcode` |
| --- | --- | --- | --- |
| KH0102 | Mongkol Borei | 807.2 | KH01 |
| KH0103 | Phnum Srok | 761.7 | KH01 |

**Join keys:** `district.province_pcode = province.province_pcode`. Join on the codes, not the names.

Run `DESCRIBE cambodia.province;` to see a table definition in MySQL. The [data guide](../../data/README.md) explains where the data comes from.

<!-- tables:end -->

## Lab tasks

1. Find the provinces larger than the average province area, using a scalar subquery.
2. Return the provinces that have at least one district, first with IN and a subquery, then with EXISTS. Compare the two outputs.
3. Write a correlated subquery that finds the districts larger than the average district in their own province.
4. Use a CTE to count districts per province, then keep the provinces whose count is above the average count.
5. Rewrite task 4 with a derived table instead of a CTE and compare the two outputs.

## Homework

1. Answer one question with a JOIN and again with EXISTS. Explain when the JOIN can return duplicate rows.
2. Review a classmate's schema and write two useful suggestions.

## Capstone sprint

**C6:** Add two multi-step queries (subquery or CTE) to your project. Record the feedback you received on your schema and what you changed.

## Submit

Write your answers in `work.sql` and label each one, for example `-- Lab 3`. Answer the questions in `reflection.md` and save your query output in `results/`. Then commit and push to your repository. See [SUBMISSIONS.md](../../SUBMISSIONS.md) for details.
