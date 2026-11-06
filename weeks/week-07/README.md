# Week 07: ER modelling and relational mapping

> Printable version: [README.pdf](README.pdf)

**Learning outcomes:** CLO1, CLO2

## Lesson

- Design steps: **conceptual** (things and links) → **logical** (tables, keys) → **physical** (types, indexes, one DBMS).
- **Entity** = thing (province). **Attribute** = property (name). **Relationship** = link (province has districts).
- **Cardinality:** 1:1, 1:N, M:N. **Participation:** is the link required?
- 1:N → FK on the "many" side. M:N → junction table.
- **Weak entity:** identified through its owner. **Specialization:** subtypes of an entity. Our data has only 1:N, so show the others on paper.
- Draw the ERD in DBML and view it on [dbdiagram.io](https://dbdiagram.io).

## Worked example

Run `example.sql` ([how](../../setup/README.md#run-a-sql-file)), then answer in `schema.dbml` and `work.sql`.

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

1. Complete `schema.dbml`: three tables, columns, PKs and FKs.
2. Mark each relationship 1:N and show that every child needs a parent.
3. Check with SQL that every district and commune has a parent.
4. Check whether every province and district has a child. Data today vs what the schema allows?
5. Write CREATE TABLE statements in `student_work` from your ERD, with the source data types.

## Homework

1. Explain natural vs surrogate keys using P-codes and MongoDB `_id`.
2. Describe conceptual, logical and physical design for this data. Sketch an M:N junction, a weak entity and a specialization on paper.

## Capstone sprint

**C7:** Submit ERD v1 and a data dictionary; justify keys and relationships.

## Submit

Answers in `work.sql`, reflection in `reflection.md`, output in `results/`. Commit and push. See [SUBMISSIONS.md](../../SUBMISSIONS.md).
