# Week 02: Tables, keys and constraints

> Printable version: [README.pdf](README.pdf)

**Learning outcomes:** CLO1, CLO2, CLO3

## Lesson

- **Schema:** the table structure (columns, types, keys). **Instance:** the rows stored right now.
- Every column has a **data type**. P-codes are text (`CHAR`); areas are `DECIMAL(12,1)` (exact, unlike `FLOAT`).
- **Candidate key:** a minimal set of columns that identifies each row. The one you choose is the **primary key** (unique, not NULL).
- **Foreign key:** value must exist in the parent table. **NOT NULL:** value required. **CHECK:** value must pass a test, e.g. `area_km2 > 0`.
- `cambodia` is read-only for you. Create your tables in `student_work`.
- To see a constraint work, insert a row that already exists and save the error.

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

**Your tables:** `example.sql` creates `student_work.w02_province`. You create the district and commune tables in the lab.

More: [data guide](../../data/README.md).

<!-- tables:end -->

## Lab tasks

1. Explain the data type of each column in the three tables.
2. Create `student_work.lab02_province` with a PK, NOT NULL columns and `CHECK (area_km2 > 0)`.
3. Copy the first two provinces by code into it with `INSERT ... SELECT`.
4. Insert one of them again and save the duplicate-key error.
5. Create `student_work.lab02_district` with an FK to `lab02_province` and load only matching districts. Why load parents first?

## Homework

1. Create `student_work.lab02_commune` with an FK to `lab02_district` and load only matching communes.
2. Run `SHOW CREATE TABLE` and say what each constraint blocks.
3. Add a nullable column to `lab02_province` with ALTER TABLE. Then delete a province that still has districts in `lab02_district` and save the FK error. Explain ON DELETE RESTRICT vs CASCADE.

## Capstone sprint

**C2:** Draft schema v0 (tables, columns, types, keys) and a data dictionary.

## Submit

Answers in `work.sql`, reflection in `reflection.md`, output in `results/`. Commit and push. See [SUBMISSIONS.md](../../SUBMISSIONS.md).
