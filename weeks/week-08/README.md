# Week 08 Practice Pack · Schema Normalization (1NF, 2NF, 3NF)

> Printable version: [README.pdf](README.pdf)

- **Course:** FESE304 — Database Management Systems
- **Topic:** Spotting Data Anomalies & Normalizing Messy Tables Step-by-Step (1NF → 2NF → 3NF)
- **Level:** Low-to-Medium (designed for self-study at home)
- **Target Engine & Database:** MySQL 8.4 (`w08_normalization`, with your normalized tables created in `student_work`)
- **Dataset Sources & Licenses:**
  - GroupLens MovieLens (`ml-latest-small`, 1,000 movies) — [GroupLens Educational License](https://files.grouplens.org/datasets/movielens/ml-latest-small-README.html)
  - Olist Brazilian E-Commerce (1,200 flat order-item rows) — [CC BY-NC-SA 4.0](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

## How to Use This Pack at Home

1. Run `weeks/week-08/dataset.sql` in DBeaver ([import guide](../../setup/DBEAVER-IMPORT-GUIDE.md)) (`Alt+X`) to create `w08_normalization`, then refresh (`F5`).
2. Create all your normalized tables as regular tables in `student_work` (not temporary tables!) so your work stays saved even if you close DBeaver and come back later.
3. Run the **Worked Example**, complete **Core Practice (Tasks 1–12)**, and try **Optional Stretch (Tasks 13–15)** if you finish early.

---

## Unnormalized Source Tables & Real Sample Rows

| Table | Rows | Primary Key & Columns | Why It Needs Normalization |
| --- | ---: | --- | --- |
| `raw_movies` | 1,000 | `movie_id` (PK), `title`, `release_year`, `genres` | **Breaks 1NF:** `genres` packs multiple values into one cell (`Adventure\|Animation\|Children\|Comedy\|Fantasy`) |
| `raw_order_lines` | 1,200 | `(order_id, order_item_id)` (PK), `order_status`, `order_purchase_timestamp`, `customer_id`, `customer_city`, `customer_state`, `product_id`, `product_category_pt`, `product_category_en`, `seller_id`, `seller_city`, `seller_state`, `price`, `freight_value` | **Breaks 2NF & 3NF:** order details depend only on `order_id` (partial dependency); customer, seller, product, and category details repeat on every row (transitive dependencies) |

**Sample rows from `raw_movies`:**

| `movie_id` | `title` | `release_year` | `genres` |
| ---: | --- | ---: | --- |
| 1 | Toy Story (1995) | 1995 | `Adventure\|Animation\|Children\|Comedy\|Fantasy` |
| 2 | Jumanji (1995) | 1995 | `Adventure\|Children\|Fantasy` |

---

## Worked Example (Try This First!)

Count how many movies pack multiple genres into the `genres` column using `|`:

```sql
SELECT COUNT(*) AS multi_genre_movies
FROM raw_movies
WHERE genres LIKE '%|%';
```

> **Verification:** Expected `1` row | First row: `(707)`

---

## Part 1: Basics — Spotting 1NF, 2NF, and 3NF Problems (Tasks 1–5) — Core Practice

### Task 1 · Spot the 1NF problem in `raw_movies`
Show `movie_id`, `title`, and `genres` for the first 5 movies where `genres` contains `'|'`, sorted by `movie_id`.

> **Verification:** Expected `5` rows | First row: `(1, Toy Story (1995), Adventure|Animation|Children|Comedy|Fantasy)`

### Task 2 · Why `order_id` alone cannot be the primary key
From `raw_order_lines`, return one row with `COUNT(*)` as `total_rows` and `COUNT(DISTINCT order_id)` as `distinct_orders`. Because `1200 > 856`, one order can have multiple rows, so the key is `(order_id, order_item_id)`.

> **Verification:** Expected `1` row | First row: `(1200, 856)`

### Task 3 · Find multi-item orders (where order & customer info repeats)
Group `raw_order_lines` by `order_id` and keep orders with `HAVING COUNT(*) > 1`. Return `order_id`, `COUNT(*)` as `item_count`, and `SUM(price)` as `items_subtotal`. Sort by `item_count` descending, then `order_id`, limited to 5 rows.

> **Verification:** Expected `5` rows | First row: `(03caa2c082116e1d31e67e9ae3700499, 8, 13440.00)`

### Task 4 · Spot seller update anomalies (3NF)
In `raw_order_lines`, if a seller moves city, you would have to update dozens of rows! Group by `seller_id`, `seller_city`, and `seller_state` to find the top 5 most-repeated sellers. Return `seller_id`, `seller_city`, `seller_state`, and `COUNT(*)` as `row_repeats`, sorted by `row_repeats` descending, then `seller_id`.

> **Verification:** Expected `5` rows | First row: `(1025f0e2d44d7041d6cf58b6550e0bfa, sao paulo, SP, 38)`

### Task 5 · Spot category translation redundancy (3NF)
Group `raw_order_lines` by `product_category_pt` and `product_category_en`. Return `product_category_pt`, `product_category_en`, `COUNT(*)` as `row_repeats`, and `COUNT(DISTINCT product_id)` as `distinct_products`. Sort by `row_repeats` descending, then `product_category_pt`, limited to 5 rows.

> **Verification:** Expected `5` rows | First row: `(cama_mesa_banho, bed_bath_table, 166, 108)`

---

## Part 2: Everyday Practice — Normalize Step-by-Step in `student_work` (Tasks 6–10) — Core Practice

### Task 6 · 1NF hands-on: one genre per row
Create `student_work.w08_movie_genre (movie_id INT NOT NULL, genre_name VARCHAR(64) NOT NULL, PRIMARY KEY (movie_id, genre_name))`. Insert the real genres for the first two movies from `raw_movies`:
- Movie `1` (`Toy Story`): `'Adventure'`, `'Animation'`, `'Children'`, `'Comedy'`, `'Fantasy'`
- Movie `2` (`Jumanji`): `'Adventure'`, `'Children'`, `'Fantasy'`

Then group by `movie_id` to show `movie_id` and `COUNT(*)` as `genre_count`, ordered by `movie_id`. Notice how easy counting and filtering genres becomes in 1NF!

<details>
<summary>Hint</summary>
Use a normal multi-row `INSERT INTO student_work.w08_movie_genre (movie_id, genre_name) VALUES (1, 'Adventure'), ...;`
</details>

> **Verification:** Expected `2` rows | First row: `(1, 5)`

### Task 7 · 2NF: split `raw_order_lines` into order headers and order items
Remove the partial dependency on `order_id` by creating two tables in `student_work`:
1. `student_work.w08_header_2nf` (`PRIMARY KEY (order_id)`) using `SELECT DISTINCT order_id, order_status, order_purchase_timestamp, customer_id, customer_city, customer_state FROM raw_order_lines`
2. `student_work.w08_item_2nf` (`PRIMARY KEY (order_id, order_item_id)`) using `SELECT order_id, order_item_id, product_id, product_category_pt, product_category_en, seller_id, seller_city, seller_state, price, freight_value FROM raw_order_lines`

Verify the row counts of both tables (one row: `header_rows`, `item_rows`).

<details>
<summary>Hint</summary>
MySQL lets you define the key right in `CREATE TABLE ... SELECT`:
```sql
CREATE TABLE student_work.w08_header_2nf (PRIMARY KEY (order_id))
SELECT DISTINCT order_id, order_status, order_purchase_timestamp,
                customer_id, customer_city, customer_state
FROM raw_order_lines;
```
</details>

> **Verification:** Expected `1` row | First row: `(856, 1200)`

### Task 8 · 3NF (Part A): separate customers from orders
Remove the transitive dependency `order_id → customer_id → (customer_city, customer_state)` from `student_work.w08_header_2nf`:
1. `student_work.w08_customer` (`PRIMARY KEY (customer_id)`) with `DISTINCT customer_id, customer_city, customer_state`
2. `student_work.w08_order` (`PRIMARY KEY (order_id)`) with `order_id, order_status, order_purchase_timestamp, customer_id`

Check the row counts of both tables (`customer_rows`, `order_rows`).

<details>
<summary>Hint</summary>
Use the same `CREATE TABLE ... (PRIMARY KEY (...)) SELECT ... FROM student_work.w08_header_2nf;` pattern as Task 7.
</details>

> **Verification:** Expected `1` row | First row: `(856, 856)`

### Task 9 · 3NF (Part B): separate sellers, products, categories, and lines
Split `student_work.w08_item_2nf` into four clean 3NF tables:
1. `student_work.w08_seller` (`PRIMARY KEY (seller_id)`): `DISTINCT seller_id, seller_city, seller_state`
2. `student_work.w08_product` (`PRIMARY KEY (product_id)`): `DISTINCT product_id, product_category_pt`
3. `student_work.w08_category` (`PRIMARY KEY (product_category_pt)`): `DISTINCT product_category_pt, product_category_en`
4. `student_work.w08_line` (`PRIMARY KEY (order_id, order_item_id)`): `order_id, order_item_id, product_id, seller_id, price, freight_value`

Verify the four row counts in one row: `line_rows`, `seller_rows`, `product_rows`, `category_rows`.

<details>
<summary>Hint</summary>
Notice how `w08_category` shrinks 1,200 repeated category translations down to just 52 clean rows!
</details>

> **Verification:** Expected `1` row | First row: `(1200, 449, 858, 52)`

### Task 10 · Lossless-join check (rejoin your 6 normalized tables)
Join all 6 of your 3NF tables (`w08_line` → `w08_order` → `w08_customer`, `w08_seller`, `w08_product` → `w08_category`) on their keys and run `SELECT COUNT(*) AS rebuilt_rows`. If your decomposition is lossless, you get back **exactly `1200` rows**!

<details>
<summary>Hint</summary>
Start `FROM student_work.w08_line AS l` and `JOIN` the other 5 tables on their matching IDs (`order_id`, `customer_id`, `seller_id`, `product_id`, `product_category_pt`).
</details>

> **Verification:** Expected `1` row | First row: `(1200)`

---

## Part 3: Fix the Bug (Tasks 11–12) — Core Practice

### Task 11 · Lossy join on a non-key column (`customer_city`)
The query below joins on `customer_city` instead of `customer_id`, causing a massive fan-out (`40,495` fake rows instead of `1,200`!) because many customers live in the same city. Fix the `JOIN` condition so it returns the exact `1,200` rows.

```sql
SELECT COUNT(*) AS broken_join_rows
FROM raw_order_lines AS r
JOIN student_work.w08_customer AS c ON c.customer_city = r.customer_city;
```

<details>
<summary>Hint</summary>
Change `ON c.customer_city = r.customer_city` to `ON c.customer_id = r.customer_id`.
</details>

> **Verification:** Expected `1` row | First row: `(1200)`

### Task 12 · Silent row loss when forgetting `order_item_id`
If a customer buys 2 identical items in one order, the two rows differ *only* by `order_item_id` (`1` vs `2`). Running `SELECT DISTINCT order_id, product_id, seller_id, price, freight_value` silently deletes 259 real items (`941` rows instead of `1,200`)! Write a query on `raw_order_lines` showing `COUNT(*)`, `COUNT(DISTINCT order_id, product_id, seller_id, price, freight_value)`, and `COUNT(DISTINCT order_id, order_item_id)` side by side.

<details>
<summary>Hint</summary>
In MySQL, `COUNT(DISTINCT col1, col2)` counts distinct combinations of columns.
</details>

> **Verification:** Expected `1` row | First row: `(1200, 941, 1200)`

---

## Part 4: Optional Stretch (Tasks 13–15) — Try If You Finish Early

### Task 13 · Test a functional dependency (`order_id → customer_id`)
Verify that no `order_id` in `raw_order_lines` ever has more than one `customer_id`: group by `order_id` and filter `HAVING COUNT(DISTINCT customer_id) > 1`. Returning `0` rows confirms the dependency holds!

<details>
<summary>Hint</summary>
`SELECT order_id, COUNT(DISTINCT customer_id) FROM raw_order_lines GROUP BY order_id HAVING COUNT(DISTINCT customer_id) > 1;`
</details>

> **Verification:** Expected `0` rows (no conflicts found)

### Task 14 · Test a transitive dependency (`product_category_pt → product_category_en`)
Using the same `GROUP BY ... HAVING COUNT(DISTINCT ...) > 1` check, verify that no Portuguese category name maps to more than one English name in `raw_order_lines`.

<details>
<summary>Hint</summary>
Group by `product_category_pt` and check `HAVING COUNT(DISTINCT product_category_en) > 1`.
</details>

> **Verification:** Expected `0` rows (no conflicts found)

### Task 15 · Run a clean business report on your 3NF tables
Join `student_work.w08_order` and `student_work.w08_line` on `order_id` and group by `order_status`. Return `order_status`, `COUNT(DISTINCT o.order_id)` as `order_count`, `COUNT(*)` as `line_count`, and `SUM(l.price)` as `total_price`. Sort by `line_count` descending, then `order_status`.

<details>
<summary>Hint</summary>
Use `COUNT(DISTINCT o.order_id)` for order count and `COUNT(*)` for line-item count.
</details>

> **Verification:** Expected `5` rows | First row: `(delivered, 840, 1173, 134009.28)`

---

## Capstone sprint

**C8 / Checkpoint 2:** Submit schema v1: ERD, dependencies, migration SQL, import script. Justify any denormalization.

## Submit

Answers in `work.sql`, reflection in `reflection.md`, output in `results/`. Commit and push. See [SUBMISSIONS.md](../../SUBMISSIONS.md).
