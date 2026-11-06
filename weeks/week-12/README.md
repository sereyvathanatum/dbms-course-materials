# Week 12: NoSQL and MongoDB CRUD

> Printable version: [README.pdf](README.pdf)

**Learning outcomes:** CLO1, CLO5

## Lesson

- NoSQL types:
  - **document** (MongoDB): records with varying fields, e.g. product catalogues;
  - **key-value** (Redis): fast lookups, e.g. caches and sessions;
  - **wide-column** (Cassandra): huge write-heavy data, e.g. sensor logs;
  - **graph** (Neo4j): connections, e.g. friend networks.
- Choose by how the data is used.
- **CAP:** during a network partition, a distributed database must choose consistency or availability.
- MongoDB stores **documents** (BSON) in **collections**. Fields can be objects or arrays; documents can differ.
- `find(filter, projection)`. Operators: `$gt`, `$in`, … Dot notation reaches nested fields: `"districts.district_pcode"`.
- Read `cambodia`; write `student_work`. `_id` is added by MongoDB.

## Worked example

Run `example.js` ([how](../../setup/README.md#run-a-mongodb-file)), then answer in `work.js`.

<!-- tables:start -->

## Collections for this week

Same rows and field names as MySQL, one document per row, plus `_id`. Read `cambodia`, write `student_work`.

| Collection | Field | Type | Meaning |
| --- | --- | --- | --- |
| `province` | `province_pcode` | string | Province code |
| `province` | `province_name` | string | Province name (English) |
| `province` | `area_km2` | number | Area in km², one decimal place |
| `district` | `district_pcode` | string | District code |
| `district` | `district_name` | string | District name (English) |
| `district` | `area_km2` | number | Area in km², one decimal place |
| `district` | `province_pcode` | string | Province code |
| `commune` | `commune_pcode` | string | Commune code |
| `commune` | `commune_name` | string | Commune name (English) |
| `commune` | `area_km2` | number | Area in km², one decimal place |
| `commune` | `district_pcode` | string | District code |

Links: `district.province_pcode` → `province`; `commune.district_pcode` → `district`. MongoDB does not enforce them.

**Your collection:** `example.js` copies provinces to `student_work.w12_province` with a unique index on `province_pcode`.

More: [data guide](../../data/README.md).

<!-- tables:end -->

## Lab tasks

1. Run `example.js`; look at one document per collection.
2. Find provinces above an area you choose; show code, name and area only.
3. Copy provinces to `student_work.w12_province` with a unique index on `province_pcode`.
4. Delete one document, insert it again, check its fields against `cambodia.province`.
5. Update one name to its current value. `matchedCount` vs `modifiedCount`?

## Homework

1. Write four CRUD commands with output; compare each with SQL.
2. When would embedding districts in provinces help? When is SQL better?
3. In `student_work`, build one province document with an array of its districts. Query `districts.district_pcode` and use `$size` or `$elemMatch`.

## Capstone sprint

**C12:** Add a document part to your project and map your tables to documents.

## Submit

Answers in `work.js`, reflection in `reflection.md`, output in `results/`. Commit and push. See [SUBMISSIONS.md](../../SUBMISSIONS.md).
