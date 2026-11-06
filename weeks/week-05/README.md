# Week 05: Joining related tables

> Printable version: [README.pdf](README.pdf)

**Learning outcomes:** CLO3

## Lesson

- `INNER JOIN`: only matching rows. `LEFT JOIN`: all left rows, NULL where no match. Join on keys in `ON`.
- Joining parent to children repeats the parent. After joining communes, `COUNT(*)` counts communes; `COUNT(DISTINCT district_pcode)` counts districts.
- **Self join:** a table joined to itself. Use `a.code < b.code` to avoid duplicate pairs.
- `UNION` removes duplicates; `UNION ALL` keeps them.
- Rows with no match: `LEFT JOIN ... WHERE right.key IS NULL`. Empty is a valid answer.

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

1. Show each district with its province name.
2. Join communes → districts → provinces, sorted by commune code.
3. LEFT JOIN provinces to districts and count districts per province.
4. Find districts with no province (LEFT JOIN + IS NULL). Report the result, even if empty.
5. Self join provinces to find equal areas; if none, explain how the query would show them. Compare UNION vs UNION ALL on the same SELECT.

## Homework

1. Join all three tables and say what one result row represents.
2. Show how joining communes changes a district count; fix it with COUNT(DISTINCT district_pcode).

## Capstone sprint

**C5:** Add two join queries. Note repeated data or queries your design made hard.

## Submit

Answers in `work.sql`, reflection in `reflection.md`, output in `results/`. Commit and push. See [SUBMISSIONS.md](../../SUBMISSIONS.md).
