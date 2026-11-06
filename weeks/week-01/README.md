# Week 01: Welcome and first queries

> Printable version: [README.pdf](README.pdf)

**Learning outcomes:** CLO1, CLO3, CLO6

## Lesson

- **Database:** organised, related data. **DBMS** (e.g. MySQL): software that stores it, enforces rules, handles many users at once and answers SQL queries.
- **Table** = columns + rows. **Primary key** = column that identifies one row.
- Data: Cambodia's 25 provinces, 197 districts and 1,633 communes (2018 boundaries). Each has a code (P-code, e.g. `KH12`), a name and an area in km².
- `SELECT` columns, `FROM` table, `ORDER BY` sort. No `ORDER BY` = no guaranteed order.
- `LIMIT n` keeps n rows; `OFFSET n` skips n rows first. Add the code as the last sort column so the order is stable.

## Worked example

Run `example.sql` ([how](../../setup/README.md#run-a-sql-file)), then answer in `work.sql`.

<!-- tables:start -->

## Tables for this week

Read `cambodia`, write `student_work`. All columns are `NOT NULL`. Samples are the first two rows by code.

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

**Join keys:** `district.province_pcode = province.province_pcode`; `commune.district_pcode = district.district_pcode`.

More: [data guide](../../data/README.md).

<!-- tables:end -->

## Lab tasks

1. Run `SELECT VERSION();`. Explain client, server and database in two sentences.
2. Run `SHOW TABLES;` and `DESCRIBE` each table. Name each primary key.
3. List all province codes and names, sorted by code.
4. List the five largest provinces by area (then by code).
5. Count the rows in each table and compare with the CSV files in `data/`.

## Homework

1. Write five SELECT queries with named columns (no `*`) and ORDER BY.
2. Use one result to explain data vs information.
3. Page through provinces two at a time with `LIMIT 2 OFFSET ...`. Why does paging need ORDER BY?

## Capstone sprint

**C1:** Form a team of 3–4, pick a problem, write eight questions and name your data source (publisher, link, licence).

## Submit

Answers in `work.sql`, reflection in `reflection.md`, output in `results/`. Commit and push. See [SUBMISSIONS.md](../../SUBMISSIONS.md).
