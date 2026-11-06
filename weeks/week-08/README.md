# Week 08: Normalization

> Printable version: [README.pdf](README.pdf)

**Learning outcomes:** CLO2, CLO3

## Lesson

- **Functional dependency** X → Y: one X gives one Y. Here `province_pcode → province_name, area_km2`.
- The example's flat report repeats province data on every commune row. As the only copy it would cause anomalies:
  - **update:** change a name in many rows;
  - **insert:** can't add a province with no communes;
  - **delete:** deleting the last commune loses the province.
- **1NF:** one value per cell.
- **2NF:** 1NF + non-key columns depend on the whole key. E.g. key (`student_id`, `course_code`) with `course_name` breaks 2NF. Our tables have one-column keys.
- **3NF:** 2NF + no non-key → non-key dependency. `commune_pcode → district_pcode → province_name` is transitive, so split the report.
- **BCNF:** for every X → Y (Y not in X), X is a superkey.
- A flat (denormalized) report is fine for reading if you can rebuild it.

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

**Report columns:** `commune_pcode`, `commune_name`, `commune_area_km2`, `district_pcode`, `district_name`, `district_area_km2`, `province_pcode`, `province_name`, `province_area_km2`. One row per commune; a query result, not a table.

More: [data guide](../../data/README.md).

<!-- tables:end -->

## Lab tasks

1. Run the report in `example.sql`; save its columns and output.
2. Write the functional dependencies and a candidate key.
3. Use repeated province values to explain update, insert and delete anomalies. Don't change the source.
4. Split the report into province, district and commune tables with keys.
5. Join them back and compare with the report: same row count, same values.

## Homework

1. Explain 1NF, 2NF, 3NF and BCNF with this data.
2. When is a flat report useful? How would you refresh it?

## Capstone sprint

**C8 / Checkpoint 2:** Submit schema v1: ERD, dependencies, migration SQL, import script. Justify any denormalization.

## Submit

Answers in `work.sql`, reflection in `reflection.md`, output in `results/`. Commit and push. See [SUBMISSIONS.md](../../SUBMISSIONS.md).
