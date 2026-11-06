# Week 01: Welcome and first queries

> Printable version: [README.pdf](README.pdf)

**Learning outcomes:** CLO1, CLO3, CLO6

## Lesson

A **database** is an organised collection of related data. A **DBMS** (database management system), such as MySQL, is the software that stores the data and lets people read and change it safely. Unlike a spreadsheet, a DBMS checks rules on the data, lets many users work at the same time without overwriting each other, and answers questions with a query language (SQL). In a relational database, data is kept in **tables**. Each table has named **columns**, and each **row** is one record. A **primary key** is a column whose value identifies exactly one row.

This course uses real data about Cambodia's 25 provinces, 197 districts and 1,633 communes. Each one has a code (called a P-code, for example `KH12`), an English name and an area in km². The boundaries are from 2018, so some may differ from today's.

`SELECT` chooses the columns, `FROM` chooses the table and `ORDER BY` sorts the rows. Without `ORDER BY`, MySQL may return rows in any order. `LIMIT 5` returns only the first five rows of the result, and `OFFSET` skips rows before them. If two rows can have the same value in the sort column, add the code as a second sort column so the order is always the same.

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

### `cambodia.commune`

| Column | Type | Key | Meaning |
| --- | --- | --- | --- |
| `commune_pcode` | `CHAR(8)` | PK | Commune code |
| `commune_name` | `VARCHAR(100)` |  | Commune name (English) |
| `area_km2` | `DECIMAL(12,1)` |  | Area in km², one decimal place |
| `district_pcode` | `CHAR(6)` | FK | District code |

Sample rows:

| `commune_pcode` | `commune_name` | `area_km2` | `district_pcode` |
| --- | --- | --- | --- |
| KH010201 | Banteay Neang | 52.0 | KH0102 |
| KH010202 | Bat Trang | 40.3 | KH0102 |

**Join keys:** `district.province_pcode = province.province_pcode`; `commune.district_pcode = district.district_pcode`. Join on the codes, not the names.

Run `DESCRIBE cambodia.province;` to see a table definition in MySQL. The [data guide](../../data/README.md) explains where the data comes from.

<!-- tables:end -->

## Lab tasks

1. Connect to MySQL and run `SELECT VERSION();`. In one or two sentences, explain the difference between the client, the server and a database.
2. Run `SHOW TABLES;` and `DESCRIBE` each of the three tables. Write down the primary key of each table.
3. List all province codes and names, sorted by code.
4. List the five provinces with the largest area. Sort by area (largest first), then by code.
5. Count the rows in each of the three tables. Compare the numbers with the CSV files in `data/` (each file also has one header line).

## Homework

1. Write five more SELECT queries. Name the columns you want (do not use `*`) and always use ORDER BY.
2. Using one of your results, explain the difference between data and information.
3. Show the provinces in code order, two rows at a time, with `LIMIT 2 OFFSET ...`. Explain what OFFSET counts and why paging needs ORDER BY.

## Capstone sprint

**C1:** Form your team (3–4 students) and choose a problem that public data can answer. Write eight questions your database should answer, and note where the data will come from (publisher, link and licence). You may use the Cambodia data from this course.

## Submit

Write your answers in `work.sql` and label each one, for example `-- Lab 3`. Answer the questions in `reflection.md` and save your query output in `results/`. Then commit and push to your repository. See [SUBMISSIONS.md](../../SUBMISSIONS.md) for details.
