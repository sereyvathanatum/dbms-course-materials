# Week 05: Joining related tables

> Printable version: [README.pdf](README.pdf)

**Learning outcomes:** CLO3

## Lesson

Related data lives in separate tables that are linked by keys. A **JOIN** puts them back together. `INNER JOIN` returns only the rows that match in both tables. `LEFT JOIN` returns every row from the left table, with NULLs where there is no match. Always join on the key columns in the `ON` clause.

When you join a parent to its children, each parent row appears once for every child. Count carefully: after joining communes, `COUNT(*)` counts communes, while `COUNT(DISTINCT district_pcode)` counts districts.

A **self join** joins a table to itself, for example to compare two provinces. Use a condition such as `a.province_pcode < b.province_pcode` so that each pair appears only once. `UNION` combines two results and removes duplicate rows; `UNION ALL` keeps them. To find rows without a match, use a LEFT JOIN and keep the rows where the right side IS NULL. An empty result is a valid answer.

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

1. Join districts to provinces to show each district with its province name.
2. Join communes to districts and provinces, sorted by commune code.
3. LEFT JOIN provinces to districts and count the districts in each province.
4. Use LEFT JOIN and IS NULL to look for districts without a province. Record what you find, even if the result is empty.
5. Self join the province table to find pairs of provinces with the same area. If there are none, explain how your query would show them. Then compare UNION and UNION ALL by combining the same SELECT twice.

## Homework

1. Write one report that joins all three tables, and explain what one row of the result represents.
2. Join districts to communes and show how COUNT(*) per province changes. Fix the count with COUNT(DISTINCT district_pcode).

## Capstone sprint

**C5:** Add two join queries to your project. Note any repeated data, confusing keys or queries that were hard to write because of your design.

## Submit

Write your answers in `work.sql` and label each one, for example `-- Lab 3`. Answer the questions in `reflection.md` and save your query output in `results/`. Then commit and push to your repository. See [SUBMISSIONS.md](../../SUBMISSIONS.md) for details.
