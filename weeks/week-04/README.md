# Week 04: Functions and grouped reports

> Printable version: [README.pdf](README.pdf)

**Learning outcomes:** CLO3

## Lesson

A **single-row function** works on each row: `UPPER(name)`, `CHAR_LENGTH(name)`, `ROUND(area_km2)`. An **aggregate function** turns many rows into one value: `COUNT`, `SUM`, `AVG`, `MIN` and `MAX`. `COUNT(*)` counts rows; `COUNT(column)` skips NULLs.

`GROUP BY` makes one group for each value, and the aggregate is calculated for each group. `WHERE` filters rows before grouping; `HAVING` filters groups after grouping. `CASE` creates a label from a rule, and `COALESCE(x, y)` returns `y` when `x` is NULL.

Keep two points in mind with this data. An average area is an average of administrative units, not of people. The dataset has no population and no dates; the only date is the boundary date, 4 October 2018.

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

1. Show each province name next to its UPPER version and its CHAR_LENGTH.
2. Find the MIN, MAX, SUM and AVG district area. State the unit (km²) and round the average to one decimal place.
3. Group districts by `province_pcode` and show COUNT(*) and AVG(area_km2) for each province.
4. Calculate the average number of districts per province (total districts ÷ number of provinces). Then use HAVING to keep only the provinces above that value.
5. Use CASE to label each province as above or not above the average province area. Then use `YEAR('2018-10-04')` to show the year of the boundary data.

## Homework

1. Write three grouped reports. Use one of them to explain the difference between WHERE and HAVING.
2. Add up the district areas of one province and compare the total with the province's own area. Explain why rounded values may not add up exactly, and why area tells you nothing about population.
3. Use COALESCE in one query, for example after a LEFT JOIN, and explain which NULL it would replace. Say whether any NULL appeared in your result.

## Capstone sprint

**C4:** Write five report queries that answer your capstone questions. Save each query with its output.

## Submit

Write your answers in `work.sql` and label each one, for example `-- Lab 3`. Answer the questions in `reflection.md` and save your query output in `results/`. Then commit and push to your repository. See [SUBMISSIONS.md](../../SUBMISSIONS.md) for details.
