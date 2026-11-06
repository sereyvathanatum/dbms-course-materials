# Week 04: Functions and grouped reports

> Printable version: [README.pdf](README.pdf)

**Learning outcomes:** CLO3

## Lesson

- **Single-row functions** work per row: `UPPER`, `CHAR_LENGTH`, `ROUND`.
- **Aggregates** return one value: `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`. `COUNT(col)` skips NULLs.
- `GROUP BY` = one result per group. `WHERE` filters rows before grouping; `HAVING` filters groups after.
- `CASE` makes labels; `COALESCE(x, y)` returns y when x is NULL.
- Average area is per unit, not per person. The only date in the data is 2018-10-04.

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

**Join keys:** `district.province_pcode = province.province_pcode`.

More: [data guide](../../data/README.md).

<!-- tables:end -->

## Lab tasks

1. Show each province name with its UPPER version and CHAR_LENGTH.
2. Find MIN, MAX, SUM and AVG district area (km², AVG to one decimal).
3. Group districts by `province_pcode`: COUNT(*) and AVG(area_km2).
4. Work out the average districts per province (197 ÷ 25), then use HAVING to keep provinces above it.
5. Label provinces above / not above the average area with CASE. Show `YEAR('2018-10-04')`.

## Homework

1. Write three grouped reports; use one to explain WHERE vs HAVING.
2. Sum one province's district areas and compare with its area. Why can they differ? Why can't area tell you population?
3. Use COALESCE once (e.g. after a LEFT JOIN). Did any NULL appear?

## Capstone sprint

**C4:** Write five report queries for your capstone questions and save their output.

## Submit

Answers in `work.sql`, reflection in `reflection.md`, output in `results/`. Commit and push. See [SUBMISSIONS.md](../../SUBMISSIONS.md).
