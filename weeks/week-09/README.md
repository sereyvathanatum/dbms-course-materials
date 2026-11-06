# Week 09: Midterm preparation

> Printable version: [README.pdf](README.pdf)

**Learning outcomes:** CLO1, CLO2, CLO3

## Lesson

- The midterm covers Weeks 1–8. Your instructor gives the time, rules and allowed materials.
- These tasks are practice, not the exam. Try them without notes first.
- For each query, know: what one row means, the join keys, the filter and the sort.

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

**`example.sql`** lists the `cambodia` columns from `information_schema.COLUMNS`.

More: [data guide](../../data/README.md).

<!-- tables:end -->

## Lab tasks

1. List province names and areas by area, then code.
2. Count districts per province, keeping provinces with none.
3. Find districts larger than their province's average district.
4. Draw the three-table ERD; explain PKs and FKs.
5. Explain how to normalize the Week 8 report. Create `student_work.w09_province` from `cambodia.province`, delete one row in a transaction, then roll back.

## Homework

1. After feedback, write your mistakes and corrected queries in `reflection.md`.
2. Make a one-page study sheet.

## Capstone sprint

No sprint. Keep Checkpoint 2 committed and list your next tasks by priority.

## Submit

Answers in `work.sql`, reflection in `reflection.md`, output in `results/`. Commit and push. See [SUBMISSIONS.md](../../SUBMISSIONS.md).
