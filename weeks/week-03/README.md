# Week 03: Filtering and safe CRUD

> Printable version: [README.pdf](README.pdf)

**Learning outcomes:** CLO3, CLO6

## Lesson

- `WHERE` filters rows. Combine with `AND` / `OR`; use brackets.
- `IN (...)` list, `BETWEEN a AND b` range (inclusive), `LIKE 'K%'` starts with K.
- NULL = missing. Use `IS NULL`, never `= NULL`.
- `INSERT` adds, `UPDATE` changes, `DELETE` removes. Run a SELECT with the same WHERE first.
- Practise inside `START TRANSACTION` … `ROLLBACK`. `CREATE TABLE` commits automatically, so create tables first.

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

**Your table:** `example.sql` creates `student_work.w03_province`, a copy of `cambodia.province`.

More: [data guide](../../data/README.md).

<!-- tables:end -->

## Lab tasks

1. List provinces whose names start with K, sorted by code.
2. Get the MIN and AVG province area, then use those values in BETWEEN to list provinces in that range. (Week 6 does this in one query.)
3. Count NULLs in each name and area column.
4. In a transaction, delete the first province from your copy (e.g. `w03_province`) and check the count.
5. Roll back and check the row is back. Then delete and re-insert it from `cambodia.province` in a new transaction, and roll back.

## Homework

1. Write six filters that use AND/OR, IN, BETWEEN, LIKE and IS NULL.
2. List the distinct `province_pcode` values in `cambodia.district`. Separately, show each district's code and `area_km2 * 100 AS area_ha` (AS renames a column). Compare `COUNT(*)` with `COUNT(DISTINCT province_pcode)`.
3. Why is UPDATE without WHERE dangerous? Update one row of your copy to its current name in a transaction, then roll back.

## Capstone sprint

**C3 / Checkpoint 1:** Submit the proposal: problem, eight questions, data source, scope, schema v0 and an import script. No personal data.

## Submit

Answers in `work.sql`, reflection in `reflection.md`, output in `results/`. Commit and push. See [SUBMISSIONS.md](../../SUBMISSIONS.md).
