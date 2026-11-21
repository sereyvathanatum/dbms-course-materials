# Week 03 Practice Pack · Global & ASEAN Aviation Network

> Printable version: [README.pdf](README.pdf)

- **Course:** FESE304 — Database Management Systems
- **Topic:** Filtering Rows (`WHERE`, `IN`, `BETWEEN`, `LIKE`, `IS NULL`) & Safe `INSERT` / `UPDATE` / `DELETE`
- **Level:** Beginner (designed for self-study at home)
- **Target Engine & Database:** MySQL 8.4 (`w03_aviation`, with scratch write tables in `student_work`)
- **Dataset Source & License:** [OurAirports (Public Domain)](https://ourairports.com/data/) · [OpenFlights (ODbL 1.0)](https://openflights.org/data.php)

## How to Use This Pack at Home

1. Run `weeks/week-03/dataset.sql` in DBeaver ([import guide](../../setup/DBEAVER-IMPORT-GUIDE.md)) (`Alt+X`) to create `w03_aviation`, then refresh (`F5`).
2. Never run `UPDATE` or `DELETE` directly on `w03_aviation`. Copy rows into `student_work` first, and always test your `WHERE` clause with `SELECT` before modifying data!
3. Complete **Core Practice (Tasks 1–12)** first; try **Optional Stretch (Tasks 13–15)** if you have extra time.

---

## Tables & Real Sample Rows

| Table | Rows | Columns |
| --- | ---: | --- |
| `country` | 249 | `country_code` (PK), `country_name`, `continent` |
| `airport` | 3,216 | `airport_id` (PK), `ident`, `airport_type`, `airport_name`, `latitude`, `longitude`, `elevation_ft`, `country_code` (FK), `municipality`, `scheduled_service`, `icao_code`, `iata_code` |
| `airline` | 454 | `airline_id` (PK), `airline_name`, `iata_code`, `icao_code`, `callsign`, `country_name`, `active` |
| `route` | 51,373 | `route_id` (PK), `airline_id` (FK), `source_airport_id` (FK), `destination_airport_id` (FK), `source_code`, `destination_code`, `codeshare`, `stops`, `equipment` |

**Sample rows from `country`:**

| `country_code` | `country_name` | `continent` |
| --- | --- | --- |
| `AD` | Andorra | `EU` |
| `AE` | United Arab Emirates | `AS` |

**Sample rows from `route`:**

| `route_id` | `airline_id` | `source_code` | `destination_code` | `stops` | `equipment` |
| ---: | ---: | --- | --- | ---: | --- |
| 1 | 410 | `AER` | `KZN` | 0 | `CR2` |
| 2 | 410 | `ASF` | `KZN` | 0 | `CR2` |

---

## Worked Example (Try This First!)

List large airports in Cambodia (`country_code = 'KH'`):

```sql
SELECT ident, airport_name, scheduled_service
FROM airport
WHERE country_code = 'KH' AND airport_type = 'large_airport'
ORDER BY ident;
```

> **Verification:** Expected `5` rows | First row: `(KH-0001, Dara Sakor International Airport, yes)`

---

## Part 1: Basics (Tasks 1–5) — Core Practice

### Task 1 · All Cambodian airports
List `ident`, `airport_name`, and `airport_type` for `country_code = 'KH'`, sorted by `ident`, then `airport_id`.

> **Verification:** Expected `21` rows | First row: `(KH-0001, Dara Sakor International Airport, large_airport)`

### Task 2 · First 10 Thai airports with no IATA code
List `ident` and `airport_name` for the first 10 rows where `country_code = 'TH'` and `iata_code IS NULL`. Sort by `ident`, then `airport_id`.

> **Verification:** Expected `10` rows | First row: `(TH-0001, Eastern Flying Club Airport)`

### Task 3 · Five highest airports
Show `ident`, `airport_name`, and `elevation_ft` for the 5 highest airports where `elevation_ft IS NOT NULL`. Sort by `elevation_ft` descending, then `airport_id`.

> **Verification:** Expected `5` rows | First row: `(SLLP, El Alto International Airport, 13355)`

### Task 4 · Vietnamese airports in an elevation range
Show `airport_id`, `ident`, and `elevation_ft` for `country_code = 'VN'` with `elevation_ft` between `2000` and `4000` inclusive. Sort by `elevation_ft` ascending, then `airport_id`.

> **Verification:** Expected `4` rows | First row: `(32382, VVNS, 2133)`

### Task 5 · Countries in Asia or Oceania
Show `country_code` and `country_name` from `country` where `continent` is `'AS'` or `'OC'`. Sort by `country_code`.

> **Verification:** Expected `82` rows | First row: `(AE, United Arab Emirates)`

---

## Part 2: Everyday Practice (Tasks 6–10) — Core Practice

### Task 6 · Cambodian international airports (`LIKE`)
Show `airport_id` and `airport_name` for Cambodian airports (`country_code = 'KH'`) whose `airport_name` ends with `'International Airport'`, sorted by `airport_id`.

<details>
<summary>Hint</summary>
Use `airport_name LIKE '%International Airport'`.
</details>

> **Verification:** Expected `6` rows | First row: `(26475, Phnom Penh International Airport)`

### Task 7 · Scheduled large or medium airports in Cambodia and Laos
Show `country_code`, `ident`, and `airport_name` for airports where `country_code` is `'KH'` or `'LA'`, `airport_type` is `'large_airport'` or `'medium_airport'`, and `scheduled_service = 'yes'`. Sort by `country_code`, `ident`, and `airport_id`.

<details>
<summary>Hint</summary>
Use two `IN (...)` conditions combined with `AND scheduled_service = 'yes'`.
</details>

> **Verification:** Expected `9` rows | First row: `(KH, KH-0001, Dara Sakor International Airport)`

### Task 8 · Routes with missing equipment
Show `route_id`, `source_code`, and `destination_code` from `route` where `equipment IS NULL`, sorted by `route_id`.

<details>
<summary>Hint</summary>
Always use `IS NULL`, never `= NULL`.
</details>

> **Verification:** Expected `12` rows | First row: `(3572, ATL, MSP)`

### Task 9 · Safe `UPDATE` practice in `student_work`
1. Create a copy of Cambodia’s 21 airports in `student_work`:
   ```sql
   DROP TABLE IF EXISTS student_work.w03_kh_airports;
   CREATE TABLE student_work.w03_kh_airports LIKE airport;
   INSERT INTO student_work.w03_kh_airports
   SELECT * FROM airport WHERE country_code = 'KH';
   ```
2. Update all rows in `student_work.w03_kh_airports` where `scheduled_service = 'yes'` so `scheduled_service` becomes `'no'`.
3. Count rows by `scheduled_service` to verify all 21 rows now have `'no'`.

<details>
<summary>Hint</summary>
`UPDATE student_work.w03_kh_airports SET scheduled_service = 'no' WHERE scheduled_service = 'yes';`
</details>

> **Verification:** Expected `1` row | First row: `(no, 21)`

### Task 10 · Safe `DELETE` practice in `student_work`
On `student_work.w03_kh_airports` (from Task 9), delete every row where `iata_code IS NULL`. Then select `airport_id`, `ident`, `iata_code`, and `airport_name` ordered by `airport_id` to see the remaining airports.

<details>
<summary>Hint</summary>
`DELETE FROM student_work.w03_kh_airports WHERE iata_code IS NULL;`
</details>

> **Verification:** Expected `11` rows | First row: `(26473, VDBG, BBM, Battambang Airport)`

---

## Part 3: Fix the Bug (Tasks 11–12) — Core Practice

### Task 11 · Missing parentheses (`AND` runs before `OR`)
The query below accidentally returns *every* Cambodian airport (even unscheduled ones) because `AND` binds tighter than `OR`. Fix it so `scheduled_service = 'yes'` applies to both `'KH'` and `'VN'`. Return `airport_id` and `ident`, ordered by `airport_id`.

```sql
SELECT airport_id, ident
FROM airport
WHERE country_code = 'KH' OR country_code = 'VN' AND scheduled_service = 'yes'
ORDER BY airport_id;
```

<details>
<summary>Hint</summary>
Use `WHERE country_code IN ('KH', 'VN') AND scheduled_service = 'yes'` (or put parentheses around the `OR`).
</details>

> **Verification:** Expected `27` rows | First row: `(26473, VDBG)`

### Task 12 · Inclusive vs exclusive range bounds
The query below misses airports at exactly `-25` or `0` feet. Fix it to include `-25` through `0` inclusive, returning `airport_id`, `ident`, and `elevation_ft`, sorted by `elevation_ft`, then `airport_id`.

```sql
SELECT airport_id, ident, elevation_ft
FROM airport
WHERE elevation_ft > -25 AND elevation_ft < 0
ORDER BY elevation_ft, airport_id;
```

<details>
<summary>Hint</summary>
Use `BETWEEN -25 AND 0` (or `>= -25 AND <= 0`).
</details>

> **Verification:** Expected `3` rows | First row: `(2524, EHRD, -15)`

---

## Part 4: Optional Stretch (Tasks 13–15) — Try If You Finish Early

### Task 13 · Thai airports with ICAO but no IATA code
Show `airport_id`, `ident`, `icao_code`, and `iata_code` for `country_code = 'TH'` where `icao_code IS NOT NULL` and `iata_code IS NULL`. Sort by `icao_code`, then `airport_id`.

<details>
<summary>Hint</summary>
Combine `country_code = 'TH' AND icao_code IS NOT NULL AND iata_code IS NULL`.
</details>

> **Verification:** Expected `18` rows | First row: `(339379, TH-0007, VTBC, NULL)`

### Task 14 · Non-stop routes between BKK and SIN in either direction
Show `route_id`, `source_code`, `destination_code`, and `airline_id` for non-stop routes (`stops = 0`) going from `'BKK'` to `'SIN'` OR from `'SIN'` to `'BKK'`. Sort by `source_code`, then `route_id`.

<details>
<summary>Hint</summary>
Put parentheses around the two directions: `((source_code = 'BKK' AND destination_code = 'SIN') OR (source_code = 'SIN' AND destination_code = 'BKK')) AND stops = 0`.
</details>

> **Verification:** Expected `19` rows | First row: `(382, BKK, SIN, 3021)`

### Task 15 · Safe `INSERT` into an empty scratch table
Create an empty copy `student_work.w03_sin_routes LIKE route`. Insert the 5 lowest-`route_id` non-stop (`stops = 0`) routes departing `'SIN'`. Select `route_id`, `source_code`, `destination_code`, and `equipment` ordered by `route_id`.

<details>
<summary>Hint</summary>
`INSERT INTO student_work.w03_sin_routes SELECT * FROM route WHERE source_code = 'SIN' AND stops = 0 ORDER BY route_id LIMIT 5;`
</details>

> **Verification:** Expected `5` rows | First row: `(399, SIN, BKK, 320)`

---

## Capstone sprint

**C3 / Checkpoint 1:** Submit the proposal: problem, eight questions, data source, scope, schema v0 and an import script. No personal data.

## Submit

Answers in `work.sql`, reflection in `reflection.md`, output in `results/`. Commit and push. See [SUBMISSIONS.md](../../SUBMISSIONS.md).
