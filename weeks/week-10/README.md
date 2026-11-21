# Week 10 Practice Pack · Sakila DVD Rental Store

> Printable version: [README.pdf](README.pdf)

- **Course:** FESE304 — Database Management Systems
- **Topic:** Views, Indexes & `EXPLAIN`, Stored Procedures, Triggers, Transactions & Permissions
- **Level:** Low-to-Medium (designed for self-study at home)
- **Target Engine & Database:** MySQL 8.4 (`w10_sakila`, with your own views, procedures, indexes, and scratch tables in `student_work`)
- **Dataset Source & License:** [Oracle / MySQL Official Sakila Sample Database 1.5 (New BSD License)](https://dev.mysql.com/doc/sakila/en/sakila-license.html)

## How to Use This Pack at Home

1. Run `weeks/week-10/dataset.sql` in DBeaver ([import guide](../../setup/DBEAVER-IMPORT-GUIDE.md)) (`Alt+X`) to create `w10_sakila` (16 tables, 7 built-in views, 16,044 rentals & payments), then refresh (`F5`).
2. Create all your own views, procedures, triggers, and scratch tables inside `student_work`.
3. For `EXPLAIN` tasks, just run `EXPLAIN SELECT ...` in DBeaver and read the **`type`**, **`key`**, and **`rows`** columns in the result grid — no JSON parsing needed!
4. Complete **Core Practice (Tasks 1–12)** first; try **Optional Stretch (Tasks 13–15)** if you finish early.

---

## Key Tables & Built-In Views

| Object | Rows | Type & Key Columns |
| --- | ---: | --- |
| `actor` | 200 | Table: `actor_id` (PK), `first_name`, `last_name` (indexed by `idx_actor_last_name`) |
| `film` | 1,000 | Table: `film_id` (PK), `title`, `rating`, `rental_rate`, `length` |
| `inventory` | 4,581 | Table: `inventory_id` (PK), `film_id` (FK), `store_id` (FK) |
| `customer` | 599 | Table: `customer_id` (PK), `store_id` (FK), `first_name`, `last_name`, `email` |
| `rental` | 16,044 | Table: `rental_id` (PK), `rental_date` (indexed by `rental_date`), `inventory_id` (FK), `customer_id` (FK) |
| `payment` | 16,044 | Table: `payment_id` (PK), `customer_id` (FK, indexed by `idx_fk_customer_id`), `amount`, `payment_date` |
| `sales_by_store` | 2 | Built-in View: `store`, `manager`, `total_sales` |
| `sales_by_film_category` | 16 | Built-in View: `category`, `total_sales` |

**Sample rows from `payment`:**

| `payment_id` | `customer_id` | `rental_id` | `amount` | `payment_date` |
| ---: | ---: | ---: | ---: | --- |
| 1 | 1 | 76 | 2.99 | `2005-05-25 11:30:37` |
| 2 | 1 | 573 | 0.99 | `2005-05-28 10:35:23` |

---

## Worked Example (Try This First!)

List all 7 built-in views in `w10_sakila`:

```sql
SHOW FULL TABLES WHERE Table_type = 'VIEW';
```

> **Verification:** Expected `7` rows | First row: `(actor_info, VIEW)`

---

## Part 1: Basics — Built-In Views, Indexes & `EXPLAIN` (Tasks 1–5) — Core Practice

### Task 1 · Query a built-in reporting view (`sales_by_store`)
Select `store`, `manager`, and `total_sales` from `sales_by_store`, ordered by `total_sales` descending, then `store`. Notice how a view hides a complex multi-table join behind a simple `SELECT`!

> **Verification:** Expected `2` rows | First row: `(Woodridge,Australia, Jon Stephens, 33726.77)`

### Task 2 · Top 5 film categories from `sales_by_film_category`
Select `category` and `total_sales` from `sales_by_film_category`, sorted by `total_sales` descending, then `category`, limited to 5 rows.

> **Verification:** Expected `5` rows | First row: `(Sports, 5314.21)`

### Task 3 · Inspect indexes on `rental`
Run `SHOW INDEX FROM rental;` to see the primary key, the 3-column `rental_date` index, and the foreign-key indexes.

> **Verification:** Expected `7` rows | First row key: `PRIMARY` on `rental_id` (and `rental_date` covers `rental_date`, `inventory_id`, `customer_id`)

### Task 4 · Read an `EXPLAIN` plan for a date range
Run `EXPLAIN` on this query and check the `type`, `key`, and `rows` columns:

```sql
EXPLAIN SELECT rental_id
FROM rental
WHERE rental_date >= '2006-02-01' AND rental_date < '2006-03-01';
```

> **Verification:** Expected `1` row | `type = range`, `key = rental_date`, `rows = 182`

### Task 5 · Read an `EXPLAIN` plan for a foreign-key lookup
Run `EXPLAIN` on:

```sql
EXPLAIN SELECT payment_id, amount
FROM payment
WHERE customer_id = 1;
```

> **Verification:** Expected `1` row | `type = ref`, `key = idx_fk_customer_id`, `rows = 32`

---

## Part 2: Everyday Practice — Create Views, Procedures, Indexes & Transactions (Tasks 6–10) — Core Practice

### Task 6 · Create a store inventory view
Create (or replace) a view `student_work.w10_store_inventory` that groups `w10_sakila.inventory` by `store_id` and returns `store_id` and `COUNT(*)` as `copies`. Then query your view ordered by `store_id`.

<details>
<summary>Hint</summary>
```sql
CREATE OR REPLACE VIEW student_work.w10_store_inventory AS
SELECT store_id, COUNT(*) AS copies
FROM w10_sakila.inventory
GROUP BY store_id;
```
</details>

> **Verification:** Expected `2` rows | First row: `(1, 2270)`

### Task 7 · Create a top-customers view
Create (or replace) `student_work.w10_customer_totals` joining `w10_sakila.customer` and `w10_sakila.payment` on `customer_id` to expose `customer_id`, `CONCAT(first_name, ' ', last_name)` as `customer_name`, `COUNT(payment_id)` as `payment_count`, and `SUM(amount)` as `total_paid`. Query the top 5 rows by `total_paid` descending, then `customer_id`.

<details>
<summary>Hint</summary>
Remember to include `c.customer_id, c.first_name, c.last_name` in `GROUP BY`.
</details>

> **Verification:** Expected `5` rows | First row: `(526, KARL SEAL, 45, 221.55)`

### Task 8 · Create and `CALL` a stored procedure
Create a stored procedure `student_work.w10_customer_payments(IN p_customer_id INT)` that returns `p_customer_id AS customer_id`, `COUNT(*) AS payment_count`, and `COALESCE(SUM(amount), 0.00) AS total_paid` from `w10_sakila.payment` for that customer. Then run `CALL student_work.w10_customer_payments(1);`.

<details>
<summary>Hint</summary>
In DBeaver, select the whole block (including `DELIMITER`) and run as a script (`Alt+X`):
```sql
DROP PROCEDURE IF EXISTS student_work.w10_customer_payments;
DELIMITER $$
CREATE PROCEDURE student_work.w10_customer_payments(IN p_customer_id INT)
BEGIN
    SELECT p_customer_id AS customer_id,
           COUNT(*) AS payment_count,
           COALESCE(SUM(amount), 0.00) AS total_paid
    FROM w10_sakila.payment
    WHERE customer_id = p_customer_id;
END$$
DELIMITER ;
```
</details>

> **Verification:** Expected `1` row | First row: `(1, 32, 118.68)`

### Task 9 · Watch an index turn a full scan (`ALL`) into a fast lookup (`ref`)
1. Copy `film` without indexes:
   ```sql
   DROP TABLE IF EXISTS student_work.w10_film_copy;
   CREATE TABLE student_work.w10_film_copy AS
   SELECT film_id, title, rating, rental_rate FROM w10_sakila.film;
   ```
2. Run `EXPLAIN SELECT film_id, title FROM student_work.w10_film_copy WHERE rating = 'PG-13';` → notice **`type = ALL`** (scans all 1,000 rows!).
3. Add an index: `CREATE INDEX idx_w10_rating ON student_work.w10_film_copy (rating);`
4. Run the same `EXPLAIN` again → notice **`type = ref`** and **`key = idx_w10_rating`**!

<details>
<summary>Hint</summary>
`CREATE TABLE ... AS SELECT` copies data but does *not* copy indexes — that makes it a great way to test adding an index yourself!
</details>

> **Verification:** Before index: `type = ALL`, `rows = 1000` | After index: `type = ref`, `key = idx_w10_rating`, `rows = 223`

### Task 10 · Practice an atomic transaction (`START TRANSACTION` + `ROLLBACK`)
Create `student_work.w10_review (rental_id INT PRIMARY KEY, review_status VARCHAR(20) NOT NULL) ENGINE=InnoDB`.
1. Run `START TRANSACTION;`
2. Insert `(1, 'reviewed')` into `student_work.w10_review`.
3. Run `SELECT COUNT(*) FROM student_work.w10_review;` (sees `1`).
4. Run `ROLLBACK;`
5. Run `SELECT COUNT(*) FROM student_work.w10_review;` again (back to `0`!).

<details>
<summary>Hint</summary>
Run all 5 steps in the same SQL editor tab so they stay on the same database connection.
</details>

> **Verification:** Before rollback: `1` | After rollback: `0`

---

## Part 3: Fix the Bug (Tasks 11–12) — Core Practice

### Task 11 · Wrapping an indexed column in a function defeats the index
The query below checks `YEAR(rental_date) = 2006 AND MONTH(rental_date) = 2`. Run `EXPLAIN` on it — MySQL has to scan the entire index (`type = index`, `rows` ≈ 16,000) because the column is wrapped in functions! Rewrite the `WHERE` clause as a date range (`>=` and `<`) and verify with `EXPLAIN` (`type = range`) and `COUNT(*)`.

```sql
SELECT rental_id
FROM rental
WHERE YEAR(rental_date) = 2006 AND MONTH(rental_date) = 2;
```

<details>
<summary>Hint</summary>
Use `WHERE rental_date >= '2006-02-01' AND rental_date < '2006-03-01'`.
</details>

> **Verification:** `EXPLAIN` shows `type = range`, `key = rental_date` | Row count: `182`

### Task 12 · Leading wildcard (`'%SON%'`) vs prefix (`'G%'`) on an indexed column
A B-Tree index (`idx_actor_last_name`) is sorted alphabetically from the *start* of each string, like a phone book:
- `WHERE last_name LIKE '%SON%'` cannot jump to the start → `EXPLAIN` shows `type = index` (scans all 200 names).
- `WHERE last_name LIKE 'G%'` jumps straight to `'G'` → `EXPLAIN` shows `type = range`.

Run `EXPLAIN` on both queries, and count how many actors match each pattern (`contains_son`, `starts_with_g`). *(Note: don’t change `'%SON%'` to `'SON%'` if you really need substring search — they answer different questions!)*

<details>
<summary>Hint</summary>
Run `EXPLAIN SELECT actor_id FROM actor WHERE last_name LIKE 'G%';` and compare `type` and `rows` against `LIKE '%SON%'`.
</details>

> **Verification:** `'G%'` plan: `type = range`, `key = idx_actor_last_name`, `rows = 12` | Counts: `contains_son = 9`, `starts_with_g = 12`

---

## Part 4: Optional Stretch (Tasks 13–15) — Try If You Finish Early

### Task 13 · `AFTER INSERT` audit trigger inside a transaction
Create `student_work.w10_review_audit (rental_id INT PRIMARY KEY, event_name VARCHAR(20) NOT NULL, review_status VARCHAR(20) NOT NULL) ENGINE=InnoDB` and an `AFTER INSERT` trigger on `student_work.w10_review` that inserts `(NEW.rental_id, 'INSERT', NEW.review_status)` into `w10_review_audit`. Inside a transaction, insert `(1, 'reviewed')`, check the audit table (`1` row), then `ROLLBACK` and verify the audit table is also rolled back to `0` rows!

<details>
<summary>Hint</summary>
```sql
CREATE TRIGGER student_work.w10_review_after_insert
AFTER INSERT ON student_work.w10_review
FOR EACH ROW
INSERT INTO student_work.w10_review_audit (rental_id, event_name, review_status)
VALUES (NEW.rental_id, 'INSERT', NEW.review_status);
```
</details>

> **Verification:** Before rollback: `(1, INSERT, reviewed)` | After rollback: `0` audit rows

### Task 14 · Partial rollback with `SAVEPOINT`
Inside a transaction on `student_work.w10_review`:
1. Insert `(1, 'reviewed')`.
2. Create `SAVEPOINT sp_after_one;`.
3. Insert `(2, 'reviewed')` and `(3, 'reviewed')`.
4. Run `ROLLBACK TO SAVEPOINT sp_after_one;` and check `COUNT(*)` (should be `1`!).
5. Run `ROLLBACK;` to clean up.

<details>
<summary>Hint</summary>
`ROLLBACK TO SAVEPOINT sp_after_one;` undoes rows 2 and 3 while keeping row 1 active in the transaction.
</details>

> **Verification:** Expected `1` row after `ROLLBACK TO SAVEPOINT sp_after_one`

### Task 15 · Check permissions & least-privilege design
Run `SHOW GRANTS;` to inspect your current user’s permissions. Then write (as SQL comments, no need to execute) the `CREATE USER` and `GRANT` statements you would give a read-only reporting app that should only read `w10_sakila`.

<details>
<summary>Hint</summary>
Least privilege means granting only `GRANT SELECT ON w10_sakila.* TO 'report_app'@'%';` — never `ALL PRIVILEGES`!
</details>

> **Verification:** `SHOW GRANTS;` displays your active user’s privilege grants.

---

## Capstone sprint

**C10:** Add the views, indexes, procedures or triggers your project needs; describe your app account's permissions.

## Submit

Answers in `work.sql`, reflection in `reflection.md`, output in `results/`. Commit and push. See [SUBMISSIONS.md](../../SUBMISSIONS.md).
