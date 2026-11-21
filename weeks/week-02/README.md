# Week 02 Practice Pack · NASA Meteorite Landings

> Printable version: [README.pdf](README.pdf)

- **Course:** FESE304 — Database Management Systems
- **Topic:** Tables, Data Types, Keys & Constraints (`CREATE TABLE`, `ALTER TABLE`, `PRIMARY KEY`, `FOREIGN KEY`, `NOT NULL`, `UNIQUE`, `CHECK`)
- **Level:** Beginner (designed for self-study at home)
- **Target Engine & Database:** MySQL 8.4 (`w02_meteorites`, with your own practice tables in `student_work`)
- **Dataset Source & License:** Meteoritical Society via [NASA Open Data](https://data.nasa.gov/dataset/meteorite-landings) · [TidyTuesday mirror](https://github.com/rfordatascience/tidytuesday/tree/main/data/2019/2019-06-11) (publicly accessible teaching subset of 3,007 landings)

## How to Use This Pack at Home

1. Run `weeks/week-02/dataset.sql` in DBeaver ([import guide](../../setup/DBEAVER-IMPORT-GUIDE.md)) (`Alt+X`) to create `w02_meteorites`, then refresh (`F5`).
2. Keep `w02_meteorites` read-only. Create all your practice tables inside `student_work` (run `CREATE DATABASE IF NOT EXISTS student_work;` once if needed).
3. Start with the **Worked Example**, complete **Core Practice (Tasks 1–12)**, and try **Optional Stretch (Tasks 13–15)** if you finish early.

---

## Tables & Real Sample Rows

| Table | Rows | Columns |
| --- | ---: | --- |
| `meteorite_class` | 176 | `class_code` (PK), `specimen_count` |
| `meteorite_landing` | 3,007 | `meteorite_id` (PK), `name`, `name_type`, `class_code` (FK → `meteorite_class`), `mass_g`, `fall_status`, `landing_year`, `latitude`, `longitude` |

**Sample rows from `meteorite_landing`:**

| `meteorite_id` | `name` | `class_code` | `mass_g` | `fall_status` | `landing_year` |
| ---: | --- | --- | ---: | --- | ---: |
| 1 | Aachen | L5 | 21.00 | Fell | 1880 |
| 2 | Aarhus | H6 | 720.00 | Fell | 1951 |

---

## Worked Example (Try This First!)

Create a small practice table in `student_work`, copy 2 real meteorites into it, check the rows, and clean up:

```sql
CREATE DATABASE IF NOT EXISTS student_work;
DROP TABLE IF EXISTS student_work.w02_demo;

CREATE TABLE student_work.w02_demo (
    meteorite_id INT PRIMARY KEY,
    name VARCHAR(150) NOT NULL
);

INSERT INTO student_work.w02_demo (meteorite_id, name)
SELECT meteorite_id, name
FROM meteorite_landing
ORDER BY meteorite_id
LIMIT 2;

SELECT meteorite_id, name FROM student_work.w02_demo ORDER BY meteorite_id;
DROP TABLE student_work.w02_demo;
```

> **Verification:** Expected `2` rows | First row: `(1, Aachen)`

---

## Part 1: Basics (Tasks 1–5) — Core Practice

### Task 1 · Inspect a table’s columns and keys
Run `DESCRIBE meteorite_landing;` to inspect every column’s data type, whether `NULL` is allowed, and which columns have keys (`PRI` or `MUL`).

> **Verification:** Expected `9` rows | First row: `(meteorite_id, int, NO, PRI, NULL, )`

### Task 2 · Look up one specimen by primary key
Show `meteorite_id`, `name`, `class_code`, and `mass_g` for `meteorite_id = 1`.

> **Verification:** Expected `1` row | First row: `(1, Aachen, L5, 21.00)`

### Task 3 · Find specimens missing a landing year
Show `meteorite_id`, `name`, and `landing_year` for rows where `landing_year` is missing (`NULL`), sorted by `meteorite_id`.

> **Verification:** Expected `1` row | First row: `(2344, Asarco Mexicana, NULL)`

### Task 4 · Five lightest specimens with a known mass
Show `meteorite_id`, `name`, and `mass_g` for the 5 lightest specimens that have a non-NULL `mass_g`. Sort by `mass_g` ascending, then `meteorite_id`. Notice how `DECIMAL(12,2)` keeps exact decimal values like `0.10`.

> **Verification:** Expected `5` rows | First row: `(546, Allan Hills 83026, 0.10)`

### Task 5 · Look up three meteorite classes
From `meteorite_class`, show `class_code` and `specimen_count` for classes `'H5'`, `'H6'`, and `'L5'`, sorted by `class_code`.

> **Verification:** Expected `3` rows | First row: `(H5, 790)`

---

## Part 2: Everyday Practice (Tasks 6–10) — Core Practice

### Task 6 · Create a practice table and load 5 rows
In `student_work`, create a table `student_work.w02_specimen` with:
- `meteorite_id INT PRIMARY KEY`
- `name VARCHAR(150) NOT NULL`
- `mass_g DECIMAL(12,2)`

Copy the 5 lowest-ID rows from `meteorite_landing` using `INSERT INTO ... SELECT`, then select `meteorite_id`, `name`, and `mass_g` ordered by `meteorite_id`.

<details>
<summary>Hint</summary>
Follow the Worked Example pattern. Add `DROP TABLE IF EXISTS student_work.w02_specimen;` at the top so you can re-run cleanly.
</details>

> **Verification:** Expected `5` rows | First row: `(1, Aachen, 21.00)`

### Task 7 · Add a column with a `DEFAULT` value
Use `ALTER TABLE` to add a new column `verified TINYINT NOT NULL DEFAULT 0` to `student_work.w02_specimen` (from Task 6). Then select `meteorite_id`, `name`, and `verified` ordered by `meteorite_id`.

<details>
<summary>Hint</summary>
`ALTER TABLE student_work.w02_specimen ADD COLUMN verified TINYINT NOT NULL DEFAULT 0;`
</details>

> **Verification:** Expected `5` rows | First row: `(1, Aachen, 0)`

### Task 8 · Enforce a `CHECK` constraint on mass
Create `student_work.w02_checked_mass` with `meteorite_id INT PRIMARY KEY`, `name VARCHAR(150) NOT NULL`, and `mass_g DECIMAL(12,2) NOT NULL CHECK (mass_g >= 0)`. Insert the 5 lowest-ID specimens that have a non-NULL mass, then select `meteorite_id`, `name`, and `mass_g` ordered by `meteorite_id`.

*(Try running `INSERT INTO student_work.w02_checked_mass VALUES (999999, 'Test', -5.00);` afterward to see MySQL reject the negative mass!)*

<details>
<summary>Hint</summary>
Filter your `INSERT ... SELECT` with `WHERE mass_g IS NOT NULL ORDER BY meteorite_id LIMIT 5`.
</details>

> **Verification:** Expected `5` rows | First row: `(1, Aachen, 21.00)`

### Task 9 · Enforce a `UNIQUE` constraint on name
Create `student_work.w02_unique_name` with `meteorite_id INT PRIMARY KEY` and `name VARCHAR(150) NOT NULL UNIQUE`. Insert the 5 lowest-ID specimens from `meteorite_landing`, then select `meteorite_id` and `name` ordered by `meteorite_id`.

<details>
<summary>Hint</summary>
Add `UNIQUE` directly after `VARCHAR(150) NOT NULL` on the `name` column.
</details>

> **Verification:** Expected `5` rows | First row: `(1, Aachen)`

### Task 10 · Create a parent–child `FOREIGN KEY` pair
Create two tables in `student_work`:
1. Parent `student_work.w02_class (class_code VARCHAR(100) PRIMARY KEY)`
2. Child `student_work.w02_landing (meteorite_id INT PRIMARY KEY, name VARCHAR(150) NOT NULL, class_code VARCHAR(100) NOT NULL, FOREIGN KEY (class_code) REFERENCES student_work.w02_class (class_code))`

Insert class `'L5'` from `meteorite_class` into the parent first, then insert the 3 lowest-ID `'L5'` specimens from `meteorite_landing` into the child. Select `meteorite_id`, `name`, and `class_code` from `student_work.w02_landing` ordered by `meteorite_id`.

<details>
<summary>Hint</summary>
Always insert into the parent table (`w02_class`) before the child (`w02_landing`), and drop the child table before the parent when re-running.
</details>

> **Verification:** Expected `3` rows | First row: `(1, Aachen, L5)`

---

## Part 3: Fix the Bug (Tasks 11–12) — Core Practice

### Task 11 · Comparing `NULL` with `=`
The query below returns `0` rows because in SQL nothing equals `NULL` (`mass_g = NULL` is always unknown). Fix it to list `meteorite_id` and `name` for specimens with missing mass, ordered by `meteorite_id`.

```sql
SELECT meteorite_id, name
FROM meteorite_landing
WHERE mass_g = NULL
ORDER BY meteorite_id;
```

<details>
<summary>Hint</summary>
Replace `= NULL` with `IS NULL`.
</details>

> **Verification:** Expected `33` rows | First row: `(425, Aire-sur-la-Lys)`

### Task 12 · `CHECK` alone still allows `NULL`
The table below still accepts `NULL` for `mass_g`, because a `CHECK` constraint only rejects `FALSE` (not `UNKNOWN`). Fix the definition so `mass_g` is required (`NOT NULL`) and nonnegative, insert the 3 lowest-ID specimens with `mass_g IS NOT NULL AND mass_g >= 0`, and select `meteorite_id` and `mass_g` ordered by `meteorite_id`.

```sql
CREATE TABLE student_work.w02_measured (
    meteorite_id INT PRIMARY KEY,
    mass_g DECIMAL(12,2) CHECK (mass_g >= 0)
);
```

<details>
<summary>Hint</summary>
Change `mass_g DECIMAL(12,2) CHECK (mass_g >= 0)` to `mass_g DECIMAL(12,2) NOT NULL CHECK (mass_g >= 0)`.
</details>

> **Verification:** Expected `3` rows | First row: `(1, 21.00)`

---

## Part 4: Optional Stretch (Tasks 13–15) — Try If You Finish Early

### Task 13 · Find `'Fell'` specimens missing coordinates
Show `meteorite_id`, `name`, `latitude`, and `longitude` for rows where `fall_status = 'Fell'` and either `latitude` or `longitude` is `NULL`. Sort by `meteorite_id`.

<details>
<summary>Hint</summary>
Wrap the `OR` condition in parentheses: `WHERE fall_status = 'Fell' AND (latitude IS NULL OR longitude IS NULL)`.
</details>

> **Verification:** Expected `10` rows | First row: `(5163, Bulls Run, NULL, NULL)`

### Task 14 · Check if `name` is unique across the whole table
Return one row with `COUNT(*)` as `total_rows`, `COUNT(DISTINCT name)` as `distinct_names`, and `COUNT(DISTINCT meteorite_id)` as `distinct_ids` from `meteorite_landing`.

<details>
<summary>Hint</summary>
All three counts go in one `SELECT` without `GROUP BY`.
</details>

> **Verification:** Expected `1` row | First row: `(3007, 3007, 3007)`

### Task 15 · Change a nullable column to `NOT NULL`
Create `student_work.w02_dated (meteorite_id INT PRIMARY KEY, landing_year INT)` (nullable), load the 5 lowest-ID rows from `meteorite_landing`, then use `ALTER TABLE ... MODIFY COLUMN` to make `landing_year INT NOT NULL`. Select `meteorite_id` and `landing_year` ordered by `meteorite_id`.

<details>
<summary>Hint</summary>
`ALTER TABLE student_work.w02_dated MODIFY COLUMN landing_year INT NOT NULL;`
</details>

> **Verification:** Expected `5` rows | First row: `(1, 1880)`

---

## Capstone sprint

**C2:** Draft schema v0 (tables, columns, types, keys) and a data dictionary.

## Submit

Answers in `work.sql`, reflection in `reflection.md`, output in `results/`. Commit and push. See [SUBMISSIONS.md](../../SUBMISSIONS.md).
