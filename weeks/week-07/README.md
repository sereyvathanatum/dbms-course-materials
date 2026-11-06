# Week 07: ER modelling and relational mapping

> Printable version: [README.pdf](README.pdf)

**Learning outcomes:** CLO1, CLO2

## Lesson

Database design has three steps: **conceptual** (which things and relationships exist), **logical** (tables, columns and keys) and **physical** (data types, indexes and storage in one DBMS).

An **entity** is a kind of thing, such as a province. An **attribute** describes it, such as its name. A **relationship** links entities: a province contains districts. **Cardinality** says how many (1:1, 1:N or M:N), and **participation** says whether the link is required (every district must belong to a province).

To turn an ERD into tables, put the foreign key on the "many" side of a 1:N relationship. An M:N relationship needs a junction table. A **weak entity** depends on its owner for its identity, and **specialization** splits an entity into subtypes. This dataset only has 1:N relationships, so explain the other cases with your own examples on paper.

You will draw the ERD in DBML, which [dbdiagram.io](https://dbdiagram.io) can display as a diagram.

## Worked example

Run `example.sql` (see [Run a SQL file](../../setup/README.md#run-a-sql-file)) and read the output. Then complete `schema.dbml` and `work.sql`.

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

Run `DESCRIBE cambodia.province;` to see a table definition in MySQL. The [data guide](../../data/README.md) explains where the data comes from.

<!-- tables:end -->

## Lab tasks

1. Complete `schema.dbml` with the three tables, their columns, primary keys and foreign keys.
2. Mark each relationship as one-to-many, and show that every child must have a parent.
3. Use SQL to check that every district and every commune has a parent.
4. Check whether every province and every district has at least one child. Explain the difference between what the data shows today and what the schema allows.
5. Write CREATE TABLE statements in `student_work` from your ERD, using the same data types as the source tables.

## Homework

1. Explain natural keys and surrogate keys, using P-codes and MongoDB's `_id` as examples.
2. Describe the conceptual, logical and physical design steps for this dataset. Then explain, with your own examples on paper, an M:N junction table, a weak entity and specialization.

## Capstone sprint

**C7:** Submit ERD v1 and a data dictionary. Explain why you chose each key and relationship.

## Submit

Write your answers in `work.sql` and label each one, for example `-- Lab 3`. Answer the questions in `reflection.md` and save your query output in `results/`. Then commit and push to your repository. See [SUBMISSIONS.md](../../SUBMISSIONS.md) for details.
