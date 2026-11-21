# Week 07 Practice Pack · Formula 1 Race Weekends

> Printable version: [README.pdf](README.pdf)

- **Course:** FESE304 — Database Management Systems
- **Topic:** Entity-Relationship (ER) Modelling & Relational Mapping (1:N, M:N associative tables, roles, optionality, composite keys)
- **Level:** Low-to-Medium (designed for self-study at home)
- **Target Engine & Database:** MySQL 8.4 (`w07_f1`)
- **Dataset Source & License:** [F1DB Open Source Formula 1 Database (v2026.20.0, 2021–2025 seasons, CC BY 4.0)](https://github.com/f1db/f1db/releases/tag/v2026.20.0)

## How to Use This Pack at Home

1. Run `weeks/week-07/dataset.sql` in DBeaver ([import guide](../../setup/DBEAVER-IMPORT-GUIDE.md)) (`Alt+X`) to create `w07_f1`, then refresh (`F5`).
2. This week connects **SQL queries** to **ER design**: each task asks you to write a practical query *and* notice how the tables represent a real relationship (1:N, M:N, optional attribute, or composite PK).
3. Run the **Worked Example**, complete **Core Practice (Tasks 1–12)**, and try **Optional Stretch (Tasks 13–15)** if you finish early.

---

## Tables & Real Sample Rows

| Table | Rows | Key Columns & Relationships |
| --- | ---: | --- |
| `country` | 249 | `country_id` (PK), `name`, `continent_id` |
| `circuit` | 78 | `circuit_id` (PK), `name`, `country_id` (FK → `country`), `length_km`, `turns` |
| `constructor` | 23 | `constructor_id` (PK), `name`, `full_name`, `country_id` (FK → `country`) |
| `driver` | 59 | `driver_id` (PK), `name`, `permanent_number` (nullable), `birth_country_id` (FK → `country`), `nationality_country_id` (FK → `country`) |
| `race` | 114 | `race_id` (PK), `season_year`, `round_number`, `race_date`, `circuit_id` (FK → `circuit`) |
| `race_result` | 2,279 | `(race_id, position_display_order)` (PK), `position_number` (nullable), `position_text`, `driver_id` (FK), `constructor_id` (FK), `points` |
| `qualifying_result` | 2,274 | `(race_id, position_display_order)` (PK), `driver_id` (FK), `constructor_id` (FK), `q1_millis`, `q2_millis` (nullable), `q3_millis` (nullable) |

**Sample rows from `driver`:**

| `driver_id` | `name` | `permanent_number` | `birth_country_id` | `nationality_country_id` |
| --- | --- | ---: | --- | --- |
| `alexander-albon` | Alexander Albon | 23 | `united-kingdom` | `thailand` |
| `alexander-dunne` | Alexander Dunne | `NULL` | `ireland` | `ireland` |

**Sample rows from `race_result`:**

| `race_id` | `position_display_order` | `position_number` | `driver_id` | `constructor_id` | `points` |
| ---: | ---: | ---: | --- | --- | ---: |
| 1036 | 1 | 1 | `lewis-hamilton` | `mercedes` | 25.00 |
| 1036 | 2 | 2 | `max-verstappen` | `red-bull` | 18.00 |

---

## Worked Example (Try This First!)

Inspect the columns and keys of the `race_result` associative table:

```sql
DESCRIBE race_result;
```

Notice `race_id` and `position_display_order` both have `Key = PRI` (a composite primary key), while `driver_id` and `constructor_id` are foreign keys (`MUL`).

> **Verification:** Expected `19` rows | First row: `(race_id, int, NO, PRI, NULL, )`

---

## Part 1: Basics — 1:N Relationships, Keys & Optional Attributes (Tasks 1–5) — Core Practice

### Task 1 · 1:N (`circuit` → `race`): First 5 rounds of 2021
Join `race` and `circuit` to show `round_number`, `race_date`, and circuit `name` for `season_year = 2021` (first 5 rounds, sorted by `round_number`).
*Think:* Why does `circuit_id` live on `race` instead of putting `race_id` on `circuit`?

> **Verification:** Expected `5` rows | First row: `(1, 2021-03-28, Bahrain)`

### Task 2 · 1:N (`country` → `circuit`): Host countries
Join `circuit` and `country` to show `country_id`, country `name`, `circuit_id`, and circuit `name` for the first 6 circuits sorted by `circuit_id`.

> **Verification:** Expected `6` rows | First row: `(australia, Australia, adelaide, Adelaide)`

### Task 3 · Surrogate PK vs natural alternate key
Show `race_id`, `season_year`, and `round_number` for the first 5 races sorted by `season_year`, then `round_number`.
*Think:* `race_id` is the Primary Key, while `(season_year, round_number)` is also unique (an alternate key).

> **Verification:** Expected `5` rows | First row: `(1036, 2021, 1)`

### Task 4 · Optional attribute (`NULL`)
Show `driver_id`, `name`, and `permanent_number` for drivers whose `permanent_number` is `NULL`, sorted by `driver_id`.

> **Verification:** Expected `31` rows | First row: `(alexander-dunne, Alexander Dunne, NULL)`

### Task 5 · Two foreign-key roles to the same table
A driver can be born in one country and race under another nationality! Join `driver` to `country` **twice** (using two `LEFT JOIN`s with aliases `b` and `n`) to show `driver_id`, `birth_country`, and `nationality_country` for the first 5 drivers by `driver_id`.

<details>
<summary>Hint</summary>
`LEFT JOIN country AS b ON b.country_id = d.birth_country_id LEFT JOIN country AS n ON n.country_id = d.nationality_country_id`
</details>

> **Verification:** Expected `5` rows | First row: `(alexander-albon, United Kingdom, Thailand)`

---

## Part 2: Everyday Practice — Associative (M:N) Tables & Participation (Tasks 6–10) — Core Practice

### Task 6 · Associative table in action (`race_result`)
Show the full finishing order for 2021 Round 1 (`season_year = 2021 AND round_number = 1`): return `position_display_order`, `position_text`, driver `name`, and constructor `name`, sorted by `position_display_order`.

<details>
<summary>Hint</summary>
Join `race_result` to `race`, `driver`, and `constructor`.
</details>

> **Verification:** Expected `20` rows | First row: `(1, 1, Lewis Hamilton, Mercedes)`

### Task 7 · Many-to-many over time (driver–constructor)
One driver can drive for different teams across seasons. For `driver_id = 'carlos-sainz-jr'`, group `race_result` (joined with `race`) by `constructor_id` to show `constructor_id`, `MIN(season_year)`, `MAX(season_year)`, and race entry count. Sort by `constructor_id`.

<details>
<summary>Hint</summary>
Join `race_result` to `race` on `race_id`, filter `WHERE rr.driver_id = 'carlos-sainz-jr'`, and `GROUP BY rr.constructor_id`.
</details>

> **Verification:** Expected `2` rows | First row: `(ferrari, 2021, 2024, 89)`

### Task 8 · Zero participation (`0..N` countries with no circuit)
Use `LEFT JOIN` from `country` to `circuit` to find the first 8 countries (`country_id`, `name`) that have zero circuits in the dataset, ordered by `country_id`.

<details>
<summary>Hint</summary>
`FROM country co LEFT JOIN circuit ci ON ci.country_id = co.country_id WHERE ci.circuit_id IS NULL`
</details>

> **Verification:** Expected `8` rows | First row: `(afghanistan, Afghanistan)`

### Task 9 · Why `(race_id, constructor_id)` cannot be a primary key
For 2021 Round 1, show `race_id`, `constructor_id`, and how many rows each constructor has in `race_result`, sorted by `constructor_id`. Notice every team enters `2` cars!

<details>
<summary>Hint</summary>
Join `race_result` and `race`, filter for 2021 Round 1, and `GROUP BY rr.race_id, rr.constructor_id`.
</details>

> **Verification:** Expected `10` rows | First row: `(1036, alfa-romeo, 2)`

### Task 10 · Optional knockout attributes (`q1_millis` vs `q2_millis`)
Drivers knocked out in Q1 never record a Q2 time (`q2_millis IS NULL`). Show `race_id`, `driver_id`, `q1_millis`, and `q2_millis` for the first 6 qualifying rows where `q1_millis IS NOT NULL AND q2_millis IS NULL`, sorted by `race_id`, then `position_display_order`.

<details>
<summary>Hint</summary>
Query `qualifying_result` directly with `WHERE q1_millis IS NOT NULL AND q2_millis IS NULL`.
</details>

> **Verification:** Expected `6` rows | First row: `(1036, esteban-ocon, 91724, NULL)`

---

## Part 3: Fix the Bug (Tasks 11–12) — Core Practice

### Task 11 · Putting `race_id` directly on `driver`
A beginner’s draft ERD puts a single `race_id` column inside `driver`. That would only let each driver participate in **one** race! Because driver–race is many-to-many, F1DB uses the associative table `race_result`. Prove that Lewis Hamilton has many races by listing his first 5 rows (`race_id`, `constructor_id`, `points`) from `race_result` for `driver_id = 'lewis-hamilton'`, ordered by `race_id`.

<details>
<summary>Hint</summary>
`SELECT race_id, constructor_id, points FROM race_result WHERE driver_id = 'lewis-hamilton' ORDER BY race_id LIMIT 5;`
</details>

> **Verification:** Expected `5` rows | First row: `(1036, mercedes, 25.00)`

### Task 12 · Using a nullable column (`position_number`) as a Primary Key
Another draft ERD tries to make `(race_id, position_number)` the primary key of `race_result`. Prove why that fails by counting total rows, rows with a non-NULL `position_number`, and rows where `position_number` is `NULL` (DNFs / disqualifications — a PK can never be `NULL`!).

<details>
<summary>Hint</summary>
`SELECT COUNT(*), COUNT(position_number), COUNT(*) - COUNT(position_number) FROM race_result;`
</details>

> **Verification:** Expected `1` row | First row: `(2279, 2009, 270)`

---

## Part 4: Optional Stretch (Tasks 13–15) — Try If You Finish Early

### Task 13 · Circuits reused across multiple races
Show `circuit_id`, `name`, and `COUNT(r.race_id)` as `race_count` for circuits that hosted at least `2` races in 2021–2025. Sort by `race_count` descending, then `circuit_id`.

<details>
<summary>Hint</summary>
Join `circuit` and `race`, `GROUP BY c.circuit_id, c.name`, and filter with `HAVING COUNT(r.race_id) >= 2`.
</details>

> **Verification:** Expected `25` rows | First row: `(spielberg, Red Bull Ring, 6)`

### Task 14 · Drivers with different birth and nationality countries
Show `driver_id`, `birth_country`, and `nationality_country` for drivers where `birth_country_id <> nationality_country_id`, ordered by `driver_id`.

<details>
<summary>Hint</summary>
Reuse your Task 5 query with `INNER JOIN`s and add `WHERE d.birth_country_id <> d.nationality_country_id`.
</details>

> **Verification:** Expected `4` rows | First row: `(alexander-albon, United Kingdom, Thailand)`

### Task 15 · Match qualifying and race results by `(race_id, driver_id)`
For 2021 Round 1, join `qualifying_result` to `race_result` (using `LEFT JOIN` on both `race_id` and `driver_id`) to show `driver_id`, qualifying `position_display_order`, and race `position_display_order`, sorted by qualifying position.

*(Bonus on paper: sketch `Table circuit` and `Table race` in DBML with `circuit_id [pk]`, `race_id [pk]`, and `circuit_id [not null, ref: > circuit.circuit_id]`.)*

<details>
<summary>Hint</summary>
`LEFT JOIN race_result AS rr ON rr.race_id = q.race_id AND rr.driver_id = q.driver_id`
</details>

> **Verification:** Expected `20` rows | First row: `(max-verstappen, 1, 2)`

---

## Capstone sprint

**C7:** Submit ERD v1 and a data dictionary; justify keys and relationships.

## Submit

Answers in `work.sql`, reflection in `reflection.md`, output in `results/`. Commit and push. See [SUBMISSIONS.md](../../SUBMISSIONS.md).
