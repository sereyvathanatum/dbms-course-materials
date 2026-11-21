# Week 04 Practice Pack · Cambodia Food Price Monitoring

> Printable version: [README.pdf](README.pdf)

- **Course:** FESE304 — Database Management Systems
- **Topic:** Functions, Aggregation & Grouping (`COUNT`, `SUM`, `AVG`, `MIN`, `MAX`, `GROUP BY`, `HAVING`, `DATE_FORMAT`, `CONCAT`, `CASE`)
- **Level:** Beginner to Medium (designed for self-study at home)
- **Target Engine & Database:** MySQL 8.4 (`w04_food_prices`)
- **Dataset Source & License:** [World Food Programme (WFP) Cambodia Food Prices via HDX (2020–2021 slice, CC BY-IGO)](https://data.humdata.org/dataset/wfp-food-prices-for-cambodia)

## How to Use This Pack at Home

1. Run `weeks/week-04/dataset.sql` in DBeaver ([import guide](../../setup/DBEAVER-IMPORT-GUIDE.md)) (`Alt+X`) to create `w04_food_prices`, then refresh (`F5`).
2. Note on real data: prices are recorded for different commodities and units (`KG`, `5 L`, etc.), so only average prices within the same commodity, unit, and `price_type`!
3. Run the **Worked Example**, complete **Core Practice (Tasks 1–12)**, and try **Optional Stretch (Tasks 13–15)** if you finish early.

---

## Tables & Real Sample Rows

| Table | Rows | Columns |
| --- | ---: | --- |
| `market` | 87 | `market_id` (PK), `market_name`, `province_name`, `district_name`, `latitude`, `longitude` |
| `commodity` | 19 | `commodity_id` (PK), `commodity_name`, `category_name`, `default_unit` |
| `food_price` | 19,953 | `price_id` (PK), `price_date`, `market_id` (FK), `commodity_id` (FK), `unit`, `price_flag`, `price_type`, `currency`, `price_khr`, `price_usd` |

**Sample rows from `commodity`:**

| `commodity_id` | `commodity_name` | `category_name` | `default_unit` |
| ---: | --- | --- | --- |
| 96 | Oil (vegetable) | oil and fats | L |
| 165 | Rice (mixed, low quality) | cereals and tubers | KG |

**Sample rows from `food_price`:**

| `price_id` | `price_date` | `market_id` | `commodity_id` | `unit` | `price_type` | `price_khr` |
| ---: | --- | ---: | ---: | --- | --- | ---: |
| 1 | 2020-01-15 | 640 | 165 | KG | Wholesale | 1800.00 |
| 2 | 2020-01-15 | 640 | 248 | KG | Wholesale | 2000.00 |

---

## Worked Example (Try This First!)

Count how many price observations exist for each `price_type`:

```sql
SELECT price_type, COUNT(*) AS obs_count
FROM food_price
GROUP BY price_type
ORDER BY price_type;
```

> **Verification:** Expected `2` rows | First row: `(Retail, 9905)`

---

## Part 1: Basics (Tasks 1–5) — Core Practice

### Task 1 · Date range and total rows
From `food_price`, return one row with the earliest `price_date`, latest `price_date`, and total number of rows (`COUNT(*)`).

> **Verification:** Expected `1` row | First row: `(2020-01-15, 2021-12-15, 19953)`

### Task 2 · Count observations by year
Group `food_price` by `YEAR(price_date)` and return the year and observation count, earliest year first.

> **Verification:** Expected `2` rows | First row: `(2020, 10305)`

### Task 3 · Format dates as `YYYY-MM`
Show `price_id` and `DATE_FORMAT(price_date, '%Y-%m')` as `obs_month` for the first 6 rows in `food_price`, ordered by `price_id`.

> **Verification:** Expected `6` rows | First row: `(1, 2020-01)`

### Task 4 · Combine province and market name
From `market`, show `market_id` and `CONCAT(province_name, ' - ', market_name)` as `market_label` for the first 8 markets, ordered by `market_id`.

> **Verification:** Expected `8` rows | First row: `(632, Kampong Chhnang - Kampong Chhnang)`

### Task 5 · Count commodities per category
From `commodity`, return `category_name` and `COUNT(*)` as `commodity_count`. Sort by `commodity_count` descending, then `category_name` ascending.

> **Verification:** Expected `7` rows | First row: `(meat, fish and eggs, 8)`

---

## Part 2: Everyday Practice (Tasks 6–10) — Core Practice

### Task 6 · Monthly record volume in 2021
For observations in `2021` (`YEAR(price_date) = 2021`), count rows per month (`MONTH(price_date)`). Return month number and count, ordered by month `1` to `12`.

<details>
<summary>Hint</summary>
Filter with `WHERE YEAR(price_date) = 2021`, then `GROUP BY MONTH(price_date)`.
</details>

> **Verification:** Expected `12` rows | First row: `(1, 872)`

### Task 7 · Retail rice summary per market
Filter `food_price` for `commodity_id = 165` (Rice), `unit = 'KG'`, and `price_type = 'Retail'`. Group by `market_id` and return `market_id`, observation count, `MIN(price_khr)`, `MAX(price_khr)`, and `ROUND(AVG(price_khr), 2)`. Sort by `market_id`.

<details>
<summary>Hint</summary>
Put all three filters in `WHERE`, then `GROUP BY market_id`.
</details>

> **Verification:** Expected `42` rows | First row: `(636, 14, 2000.00, 2600.00, 2356.90)`

### Task 8 · Provinces with at least 5 markets (`HAVING`)
From `market`, list `province_name` and `COUNT(*)` as `market_count` for provinces having at least `5` markets. Sort by `market_count` descending, then `province_name` ascending.

<details>
<summary>Hint</summary>
Filter grouped counts using `HAVING COUNT(*) >= 5`.
</details>

> **Verification:** Expected `6` rows | First row: `(Pursat, 7)`

### Task 9 · Two-column grouping (year and price type)
Group `food_price` by `YEAR(price_date)` and `price_type`. Return year, `price_type`, and row count, ordered by year, then `price_type`.

<details>
<summary>Hint</summary>
List both `YEAR(price_date)` and `price_type` in `SELECT`, `GROUP BY`, and `ORDER BY`.
</details>

> **Verification:** Expected `4` rows | First row: `(2020, Retail, 5129)`

### Task 10 · Classify 2021 retail rice prices into bands (`CASE`)
For `commodity_id = 165`, `unit = 'KG'`, `price_type = 'Retail'`, and `YEAR(price_date) = 2021`, classify each row into a `price_band`:
- `'Low (< 2200)'` when `price_khr < 2200`
- `'Medium (2200-2500)'` when `price_khr <= 2500`
- `'High (> 2500)'` otherwise

Count observations in each band and sort by count descending, then `price_band`.

<details>
<summary>Hint</summary>
Use `CASE WHEN price_khr < 2200 THEN 'Low (< 2200)' WHEN price_khr <= 2500 THEN 'Medium (2200-2500)' ELSE 'High (> 2500)' END AS price_band` and `GROUP BY price_band`.
</details>

> **Verification:** Expected `3` rows | First row: `(Low (< 2200), 231)`

---

## Part 3: Fix the Bug (Tasks 11–12) — Core Practice

### Task 11 · Using `COUNT(*)` inside `WHERE`
The query below fails with `Invalid use of group function` because `WHERE` filters rows *before* grouping. Fix it to list `market_id` and observation count for markets with at least 500 records, ordered by `market_id`.

```sql
SELECT market_id, COUNT(*) AS obs_count
FROM food_price
WHERE COUNT(*) >= 500
GROUP BY market_id
ORDER BY market_id;
```

<details>
<summary>Hint</summary>
Move `COUNT(*) >= 500` after `GROUP BY market_id` using `HAVING`.
</details>

> **Verification:** Expected `19` rows | First row: `(1527, 696)`

### Task 12 · Mixing different commodities and units in one average
The query below mixes rice per KG with oil per 5 L into one meaningless average! Fix it so each `(commodity_id, unit)` pair gets its own `ROUND(AVG(price_khr), 2)` for `price_type = 'Retail'`. Sort by `commodity_id`, then `unit`.

```sql
SELECT ROUND(AVG(price_khr), 2) AS average_khr
FROM food_price
WHERE price_type = 'Retail';
```

<details>
<summary>Hint</summary>
Add `commodity_id, unit` to `SELECT`, `GROUP BY commodity_id, unit`, and `ORDER BY commodity_id, unit`.
</details>

> **Verification:** Expected `18` rows | First row: `(96, 5 L, 23205.11)`

---

## Part 4: Optional Stretch (Tasks 13–15) — Try If You Finish Early

### Task 13 · Well-observed rice markets in 2021
For `commodity_id = 165`, `unit = 'KG'`, `price_type = 'Retail'`, and `YEAR(price_date) = 2021`, keep only markets with at least `6` observations. Show `market_id`, count, and `ROUND(AVG(price_khr), 2)` as `avg_khr`. Sort by `avg_khr` descending, then `market_id`.

<details>
<summary>Hint</summary>
Combine `WHERE` (row filters) + `GROUP BY market_id` + `HAVING COUNT(*) >= 6`.
</details>

> **Verification:** Expected `32` rows | First row: `(636, 7, 2600.00)`

### Task 14 · Distinct commodities and markets per price type
Group `food_price` by `price_type` and return `price_type`, `COUNT(DISTINCT commodity_id)`, and `COUNT(DISTINCT market_id)`, ordered by `price_type`.

<details>
<summary>Hint</summary>
Use `COUNT(DISTINCT ...)` inside `SELECT` with `GROUP BY price_type`.
</details>

> **Verification:** Expected `2` rows | First row: `(Retail, 17, 62)`

### Task 15 · Count `'actual'` vs `'aggregate'` flags per price type
Group `food_price` by `price_type` and return `price_type`, total count, count where `price_flag = 'actual'`, and count where `price_flag = 'aggregate'`. Sort by `price_type`.

<details>
<summary>Hint</summary>
Use conditional sums: `SUM(CASE WHEN price_flag = 'actual' THEN 1 ELSE 0 END)`.
</details>

> **Verification:** Expected `2` rows | First row: `(Retail, 9905, 79, 9822)`

---

## Capstone sprint

**C4:** Write five report queries for your capstone questions and save their output.

## Submit

Answers in `work.sql`, reflection in `reflection.md`, output in `results/`. Commit and push. See [SUBMISSIONS.md](../../SUBMISSIONS.md).
