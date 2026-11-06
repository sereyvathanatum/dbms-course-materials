# Week 09: Midterm preparation

> Printable version: [README.pdf](README.pdf)

**Learning outcomes:** CLO1, CLO2, CLO3

## Lesson

This week is the midterm, which covers Weeks 1–8. Your instructor will give you the time, the rules and the allowed materials. The tasks below are practice only; they are not the exam.

Try each task on your own first, then check your notes. For every query, be ready to explain what one row means, which keys you joined on, how you filtered and how you sorted. For design questions, write the dependencies and explain which rules the schema enforces.

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

**Metadata used by `example.sql`:** `information_schema.COLUMNS` lists every column of every table. The example keeps only `TABLE_SCHEMA = 'cambodia'` and shows `TABLE_NAME`, `COLUMN_NAME`, `COLUMN_TYPE`, `IS_NULLABLE` and `COLUMN_KEY`.

Run `DESCRIBE cambodia.province;` to see a table definition in MySQL. The [data guide](../../data/README.md) explains where the data comes from.

<!-- tables:end -->

## Lab tasks

1. Without looking at earlier answers, list province names and areas, sorted by area and then by code.
2. Count the districts in each province, keeping provinces that have no districts.
3. Find the districts larger than the average district in their own province.
4. Draw the ERD of the three tables and explain the primary and foreign keys.
5. Explain how to normalize the Week 8 report. Then delete one row from your own copy of a table inside a transaction and roll it back.

## Homework

1. After you get feedback, write your mistakes and the corrected queries in `reflection.md`.
2. Make a one-page study sheet based on the exam rules your instructor gives you.

## Capstone sprint

No new sprint this week. Keep your Checkpoint 2 version committed and list your next project tasks in priority order.

## Submit

Write your answers in `work.sql` and label each one, for example `-- Lab 3`. Answer the questions in `reflection.md` and save your query output in `results/`. Then commit and push to your repository. See [SUBMISSIONS.md](../../SUBMISSIONS.md) for details.
