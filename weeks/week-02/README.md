# Week 02: Tables, keys and constraints

> Printable version: [README.pdf](README.pdf)

**Learning outcomes:** CLO1, CLO2, CLO3

## Lesson

Every column has a **data type**. P-codes such as `KH0102` are identifiers, not numbers, so we store them as text (`CHAR`). Areas use `DECIMAL(12,1)`, which stores one decimal place exactly, unlike `FLOAT`.

**Constraints** are rules that MySQL checks on every insert and update:

- `PRIMARY KEY`: unique and never NULL. A table can have several **candidate keys** (minimal sets of columns that identify each row); the one you choose becomes the primary key.
- `FOREIGN KEY`: the value must exist in the parent table, so every district must point to an existing province.
- `NOT NULL`: a value is required.
- `CHECK`: the value must pass a condition, such as `area_km2 > 0`.

You can read the `cambodia` tables but not change them. Create your own tables in the `student_work` database. To see a constraint at work, insert a row that is already in your table: MySQL rejects the duplicate key. Save the error message with your results.

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

**Your tables:** `example.sql` creates `student_work.w02_province` with the province columns. You create the district and commune tables yourself in the lab. Keep the parent-code columns and add the foreign keys.

Run `DESCRIBE cambodia.province;` to see a table definition in MySQL. The [data guide](../../data/README.md) explains where the data comes from.

<!-- tables:end -->

## Lab tasks

1. Describe each column of the three tables and explain why its data type fits.
2. In `student_work`, create your own province table with a primary key, NOT NULL columns and a CHECK that the area is positive.
3. Copy the first two provinces (by code) into your table with `INSERT ... SELECT`.
4. Insert one of those two rows again and save the duplicate-key error.
5. Create a district table with a foreign key to your province table. Insert only the districts that belong to your two provinces. Explain why the parent rows must be loaded first.

## Homework

1. Create a commune table with a foreign key to your district table, and insert only the communes that belong to your districts.
2. Run `SHOW CREATE TABLE` on your tables. For each constraint, describe what kind of change it would block.
3. Use ALTER TABLE to add one nullable column to your province table, then DESCRIBE it. Next, try to delete a province that still has districts in your district table, and save the foreign-key error. Explain the difference between ON DELETE RESTRICT and ON DELETE CASCADE.

## Capstone sprint

**C2:** Draft schema v0 for your project: tables, columns, types and keys, with a short data dictionary that explains each column.

## Submit

Write your answers in `work.sql` and label each one, for example `-- Lab 3`. Answer the questions in `reflection.md` and save your query output in `results/`. Then commit and push to your repository. See [SUBMISSIONS.md](../../SUBMISSIONS.md) for details.
