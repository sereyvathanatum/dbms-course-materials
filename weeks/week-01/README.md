# Week 01 Practice Pack · Cambodia’s Administrative Boundaries

> Printable version: [README.pdf](README.pdf)

- **Course:** FESE304 — Database Management Systems
- **Topic:** First SQL Queries (`SELECT`, `WHERE`, `ORDER BY`, `LIMIT`, aliases, basic math)
- **Level:** Beginner (designed for self-study at home)
- **Target Engine & Database:** MySQL 8.4 (`w01_cambodia`)
- **Dataset Source & License:** Department of Geography of Cambodia via [OCHA HDX COD-AB (2018 snapshot, CC BY-IGO)](https://data.humdata.org/dataset/cod-ab-khm)

## How to Use This Pack at Home

1. Open `weeks/week-01/dataset.sql` in **DBeaver** ([import guide](../../setup/DBEAVER-IMPORT-GUIDE.md)) and click **Execute SQL Script (`Alt+X`)** to create `w01_cambodia`. Refresh **Databases (`F5`)**.
2. Open a new SQL Editor attached to `w01_cambodia` (`USE w01_cambodia;`).
3. Run the **Worked Example** first to confirm your connection works.
4. Aim to finish **Core Practice (Tasks 1–12)**. **Optional Stretch (Tasks 13–15)** is extra practice if you finish early.
5. Stuck on a task? Click **Hint** or ask in class.

---

## Tables & Real Sample Rows

| Table | Rows | Columns |
| --- | ---: | --- |
| `province` | 25 | `province_pcode` (PK), `province_name`, `area_km2` |
| `district` | 197 | `district_pcode` (PK), `district_name`, `area_km2`, `province_pcode` (FK → `province`) |
| `commune` | 1,633 | `commune_pcode` (PK), `commune_name`, `area_km2`, `district_pcode` (FK → `district`) |

**Sample rows from `province`:**

| `province_pcode` | `province_name` | `area_km2` |
| --- | --- | ---: |
| `KH01` | Banteay Meanchey | 6145.9 |
| `KH02` | Battambang | 11869.0 |

**Sample rows from `district`:**

| `district_pcode` | `district_name` | `area_km2` | `province_pcode` |
| --- | --- | ---: | --- |
| `KH0102` | Mongkol Borei | 807.2 | `KH01` |
| `KH0103` | Phnum Srok | 761.7 | `KH01` |

---

## Worked Example (Try This First!)

Show the first 3 provinces sorted by `province_pcode`:

```sql
SELECT province_pcode, province_name, area_km2
FROM province
ORDER BY province_pcode
LIMIT 3;
```

> **Verification:** Expected `3` rows | First row: `(KH01, Banteay Meanchey, 6145.9)`

---

## Part 1: Basics (Tasks 1–5) — Core Practice

### Task 1 · List all provinces
Show `province_pcode` and `province_name` for every province, sorted by `province_pcode` ascending.

> **Verification:** Expected `25` rows | First row: `(KH01, Banteay Meanchey)`

### Task 2 · Five largest provinces
Show `province_name` and `area_km2` for the 5 largest provinces (`area_km2` descending, then `province_pcode` ascending to break ties).

> **Verification:** Expected `5` rows | First row: `(Preah Vihear, 14042.6)`

### Task 3 · Find Phnom Penh
Show `province_pcode`, `province_name`, and `area_km2` for the row where `province_name` is `'Phnom Penh'`.

> **Verification:** Expected `1` row | First row: `(KH12, Phnom Penh, 684.8)`

### Task 4 · First 8 districts alphabetically
Show `district_pcode`, `district_name`, and `province_pcode` for the first 8 districts sorted by `district_name` A→Z, then `district_pcode`.

> **Verification:** Expected `8` rows | First row: `(KH0205, Aek Phnum, KH02)`

### Task 5 · Five smallest communes
Show `commune_pcode`, `commune_name`, and `area_km2` for the 5 smallest communes (`area_km2` ascending, then `commune_pcode`).

> **Verification:** Expected `5` rows | First row: `(KH120303, Ou Ruessei Ti Bei, 0.0)`

---

## Part 2: Everyday Practice (Tasks 6–10) — Core Practice

### Task 6 · Convert area to hectares
One square kilometre equals `100` hectares. Show `province_pcode`, `province_name`, and `area_km2 * 100` aliased as `area_ha`, sorted by `province_pcode`.

<details>
<summary>Hint</summary>
Write `area_km2 * 100 AS area_ha` in the `SELECT` list.
</details>

> **Verification:** Expected `25` rows | First row: `(KH01, Banteay Meanchey, 614590.0)`

### Task 7 · Districts in Phnom Penh
List `district_pcode` and `district_name` for all districts with `province_pcode = 'KH12'`, sorted by `district_pcode`.

<details>
<summary>Hint</summary>
Filter the `district` table with `WHERE province_pcode = 'KH12'`.
</details>

> **Verification:** Expected `12` rows | First row: `(KH1201, Chamkar Mon)`

### Task 8 · Small provinces under 1,000 km²
Show `province_pcode`, `province_name`, and `area_km2` for provinces with `area_km2 < 1000`, smallest first, then by `province_pcode`.

<details>
<summary>Hint</summary>
Combine `WHERE area_km2 < 1000` with `ORDER BY area_km2 ASC, province_pcode`.
</details>

> **Verification:** Expected `2` rows | First row: `(KH23, Kep, 151.6)`

### Task 9 · Provinces starting with “Kampong”
Show `province_pcode` and `province_name` for provinces whose name starts with `'Kampong'`, sorted by `province_name`, then `province_pcode`.

<details>
<summary>Hint</summary>
Use `WHERE province_name LIKE 'Kampong%'`.
</details>

> **Verification:** Expected `4` rows | First row: `(KH03, Kampong Cham)`

### Task 10 · Page 2 of the district list
Show `district_pcode` and `district_name` for rows 11 through 20 when sorted by `district_pcode`.

<details>
<summary>Hint</summary>
Skip the first 10 rows and return 10 rows using `LIMIT 10 OFFSET 10`.
</details>

> **Verification:** Expected `10` rows | First row: `(KH0202, Thma Koul)`

---

## Part 3: Fix the Bug (Tasks 11–12) — Core Practice

### Task 11 · Wildcard with `=` instead of `LIKE`
The query below returns `0` rows because `=` looks for a literal `%` character. Fix it to list `district_pcode` and `district_name` for all districts in province `KH01`, sorted by `district_pcode`.

```sql
SELECT district_pcode, district_name
FROM district
WHERE district_pcode = 'KH01%'
ORDER BY district_pcode;
```

<details>
<summary>Hint</summary>
Change `=` to `LIKE`.
</details>

> **Verification:** Expected `9` rows | First row: `(KH0102, Mongkol Borei)`

### Task 12 · Off-by-one `OFFSET`
The query below is supposed to return the 5th through 8th largest provinces, but it skips rank 5. Fix the `OFFSET` and return `province_pcode`, `province_name`, and `area_km2`.

```sql
SELECT province_pcode, province_name, area_km2
FROM province
ORDER BY area_km2 DESC, province_pcode
LIMIT 4 OFFSET 5;
```

<details>
<summary>Hint</summary>
To start at the 5th row, skip only the first 4 rows (`OFFSET 4`).
</details>

> **Verification:** Expected `4` rows | First row: `(KH10, Kratie, 11984.8)`

---

## Part 4: Optional Stretch (Tasks 13–15) — Try If You Finish Early

### Task 13 · Districts in two provinces within an area range
Show `province_pcode`, `district_pcode`, `district_name`, and `area_km2` for districts in `'KH01'` or `'KH02'` whose area is between `500` and `1000` km² inclusive. Sort by `province_pcode`, then `district_pcode`.

<details>
<summary>Hint</summary>
Use `province_pcode IN ('KH01', 'KH02') AND area_km2 BETWEEN 500 AND 1000`.
</details>

> **Verification:** Expected `11` rows | First row: `(KH01, KH0102, Mongkol Borei, 807.2)`

### Task 14 · Communes in Mongkol Borei (`KH0102`)
Show `commune_pcode`, `commune_name`, and `area_km2` for communes in district `'KH0102'`, largest first, then by `commune_pcode`.

<details>
<summary>Hint</summary>
Filter `commune` by `WHERE district_pcode = 'KH0102'` and sort `ORDER BY area_km2 DESC, commune_pcode`.
</details>

> **Verification:** Expected `13` rows | First row: `(KH010211, Soea, 188.8)`

### Task 15 · Compare every province to Phnom Penh
Using Phnom Penh’s area (`684.8` km² from Task 3), show `province_pcode`, `province_name`, and `area_km2 - 684.8` aliased as `diff_from_pp`. Sort by `diff_from_pp` descending, then `province_pcode`.

<details>
<summary>Hint</summary>
Compute `area_km2 - 684.8 AS diff_from_pp` directly in `SELECT`.
</details>

> **Verification:** Expected `25` rows | First row: `(KH13, Preah Vihear, 13357.8)`

---

## Capstone sprint

**C1:** Form a team of 3–4, pick a problem, write eight questions and name your data source (publisher, link, licence).

## Submit

Answers in `work.sql`, reflection in `reflection.md`, output in `results/`. Commit and push. See [SUBMISSIONS.md](../../SUBMISSIONS.md).
