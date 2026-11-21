# Week 06 Practice Pack · Olist Brazilian E-Commerce

> Printable version: [README.pdf](README.pdf)

- **Course:** FESE304 — Database Management Systems
- **Topic:** Subqueries & Common Table Expressions (`WITH` CTEs, scalar subqueries, `IN`, `EXISTS` / `NOT EXISTS`)
- **Level:** Low-to-Medium (designed for self-study at home)
- **Target Engine & Database:** MySQL 8.4 (`w06_olist`)
- **Dataset Source & License:** [Olist Brazilian E-Commerce Public Dataset (1–20 May 2018 slice, CC BY-NC-SA 4.0)](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

## How to Use This Pack at Home

1. Run `weeks/week-06/dataset.sql` in DBeaver ([import guide](../../setup/DBEAVER-IMPORT-GUIDE.md)) (`Alt+X`) to create `w06_olist`, then refresh (`F5`).
2. IDs in Olist (like `order_id` and `product_id`) are 32-character codes — you never need to type them by hand; your queries will match them automatically!
3. Run the **Worked Example**, complete **Core Practice (Tasks 1–12)**, and try **Optional Stretch (Tasks 13–15)** if you finish early.

---

## Key Tables & Real Sample Rows

| Table | Rows | Key Columns |
| --- | ---: | --- |
| `orders` | 5,354 | `order_id` (PK), `customer_id` (FK), `order_status`, `order_purchase_timestamp`, `order_delivered_customer_date` |
| `customers` | 5,354 | `customer_id` (PK), `customer_unique_id`, `customer_city`, `customer_state` |
| `order_items` | 6,174 | `(order_id, order_item_id)` (PK), `product_id` (FK), `seller_id` (FK), `price`, `freight_value` |
| `order_payments` | 5,553 | `(order_id, payment_sequential)` (PK), `payment_type`, `payment_installments`, `payment_value` |
| `order_reviews` | 5,337 | `(review_id, order_id)` (PK), `review_score` |
| `products` / `sellers` | 3,259 / 1,012 | `product_id` (PK), `product_category_name` / `seller_id` (PK), `seller_city`, `seller_state` |
| `category_translation` | 71 | `product_category_name` (PK), `product_category_name_english` |

**Sample rows from `order_items`:**

| `order_id` | `order_item_id` | `price` | `freight_value` |
| --- | ---: | ---: | ---: |
| `000aed2e25dbad2f9ddb70584c5a2ded` | 1 | 144.00 | 8.77 |
| `001e7cf2ad6bef3ade12ebc56ceaf0f3` | 1 | 35.90 | 15.20 |

---

## Worked Example (Try This First!)

Count how many order items cost more than the overall average item price:

```sql
SELECT COUNT(*) AS above_avg_items
FROM order_items
WHERE price > (SELECT AVG(price) FROM order_items);
```

> **Verification:** Expected `1` row | First row: `(1753)`

---

## Part 1: Basics — Scalar, `IN`, and Simple `NOT EXISTS` Subqueries (Tasks 1–5) — Core Practice

### Task 1 · Top 5 above-average priced items
Show `order_id`, `order_item_id`, and `price` for the 5 most expensive items whose `price` is greater than `(SELECT AVG(price) FROM order_items)`. Sort by `price` descending, then `order_id`, then `order_item_id`.

> **Verification:** Expected `5` rows | First row: `(41b7766bb1df487d17fb9725b78ff509, 1, 3930.00)`

### Task 2 · Highest freight charge
Use a scalar subquery (`= (SELECT MAX(freight_value) ...)`) to show `order_id`, `order_item_id`, and `freight_value` for the item(s) with the highest freight charge.

> **Verification:** Expected `1` row | First row: `(0b6230647ed16f4b3e70282dc4b5b87f, 1, 321.88)`

### Task 3 · Book products (`IN` subquery)
Use an `IN` subquery on `category_translation` to find the first 10 products (`product_id`, `product_category_name`) whose English category is `'books_general'` or `'books_technical'`. Sort by `product_id`.

<details>
<summary>Hint</summary>
`WHERE product_category_name IN (SELECT product_category_name FROM category_translation WHERE product_category_name_english IN ('books_general', 'books_technical'))`
</details>

> **Verification:** Expected `10` rows | First row: `(05b4834511e1cdb34899d52589ac9271, livros_tecnicos)`

### Task 4 · SP cities that have both customers and sellers
Use an `IN` subquery to list each distinct `customer_city` in `'SP'` (`customer_state = 'SP'`) that also appears in `sellers` for `seller_state = 'SP'`. Sort alphabetically.

> **Verification:** Expected `111` rows | First row: `(americana)`

### Task 5 · Canceled orders with no line items (`NOT EXISTS`)
Use `NOT EXISTS` to list `order_id` for orders where `order_status = 'canceled'` and no matching row exists in `order_items`. Sort by `order_id`.

<details>
<summary>Hint</summary>
`WHERE o.order_status = 'canceled' AND NOT EXISTS (SELECT 1 FROM order_items AS i WHERE i.order_id = o.order_id)`
</details>

> **Verification:** Expected `4` rows | First row: `(2b68bb35779189904b0cd730eaba3d1d)`

---

## Part 2: Everyday Practice — `EXISTS` & Single-Step `WITH` CTEs (Tasks 6–10) — Core Practice

### Task 6 · Count delivered orders with no review
Use `NOT EXISTS` to count how many `'delivered'` orders in `orders` have no matching row in `order_reviews`.

<details>
<summary>Hint</summary>
Start from `SELECT COUNT(*) FROM orders AS o WHERE o.order_status = 'delivered' AND NOT EXISTS (...)`.
</details>

> **Verification:** Expected `1` row | First row: `(19)`

### Task 7 · Count delivered orders with a 1-star review
Use `EXISTS` to count how many `'delivered'` orders have at least one review in `order_reviews` with `review_score = 1`.

<details>
<summary>Hint</summary>
Inside `EXISTS`, check `WHERE r.order_id = o.order_id AND r.review_score = 1`.
</details>

> **Verification:** Expected `1` row | First row: `(457)`

### Task 8 · Top 5 orders by total payment (`WITH` CTE)
Write a `WITH` CTE that sums `payment_value` per `order_id` from `order_payments`. Then query the CTE to show the top 5 orders (`order_id`, `total_paid`), highest first, then `order_id`.

<details>
<summary>Hint</summary>
`WITH order_totals AS (SELECT order_id, SUM(payment_value) AS total_paid FROM order_payments GROUP BY order_id) SELECT ...`
</details>

> **Verification:** Expected `5` rows | First row: `(41b7766bb1df487d17fb9725b78ff509, 3979.55)`

### Task 9 · Above-average sellers (`WITH` CTE + scalar subquery)
Write a CTE `seller_counts` that counts items per `seller_id` in `order_items`. Then return `seller_id` and `item_count` for sellers whose count is above `(SELECT AVG(item_count) FROM seller_counts)`. Sort by `item_count` descending, then `seller_id`.

<details>
<summary>Hint</summary>
You can reference a CTE more than once in the main query: once in `FROM seller_counts` and once in `WHERE item_count > (SELECT AVG(item_count) FROM seller_counts)`.
</details>

> **Verification:** Expected `215` rows | First row: `(7d13fca15225358621be4086e1eb0964, 209)`

### Task 10 · Orders using multiple payment types (`WITH` CTE)
Write a CTE that counts `COUNT(DISTINCT payment_type)` per `order_id` in `order_payments`. Then select `order_id` and `method_count` for orders with `method_count > 1`, sorted by `method_count` descending, then `order_id`, limited to 10 rows.

<details>
<summary>Hint</summary>
Group `order_payments` by `order_id` in the CTE, then filter `WHERE method_count > 1` in the outer query.
</details>

> **Verification:** Expected `10` rows | First row: `(077a77e315e3b317121a0af9962e122b, 2)`

---

## Part 3: Fix the Bug (Tasks 11–12) — Core Practice

### Task 11 · Uncorrelated `EXISTS` counts every order
The query below returns `5354` (every order!) because the subquery never checks `p.order_id = o.order_id`. Fix it to count only orders that have at least one `'voucher'` payment.

```sql
SELECT COUNT(*) AS voucher_orders
FROM orders AS o
WHERE EXISTS (
    SELECT 1 FROM order_payments AS p WHERE p.payment_type = 'voucher'
);
```

<details>
<summary>Hint</summary>
Add `p.order_id = o.order_id AND` inside the subquery’s `WHERE` clause.
</details>

> **Verification:** Expected `1` row | First row: `(150)`

### Task 12 · The `NOT IN (NULL)` trap
The query below returns `0` rows even though 8 categories in `category_translation` are unused in `products`, because some products have `product_category_name = NULL`! Replace `NOT IN` with `NOT EXISTS` to list the unused `product_category_name` values alphabetically.

```sql
SELECT product_category_name
FROM category_translation
WHERE product_category_name NOT IN (SELECT product_category_name FROM products)
ORDER BY product_category_name;
```

<details>
<summary>Hint</summary>
`WHERE NOT EXISTS (SELECT 1 FROM products AS p WHERE p.product_category_name = t.product_category_name)`
</details>

> **Verification:** Expected `8` rows | First row: `(casa_conforto_2)`

---

## Part 4: Optional Stretch (Tasks 13–15) — Try If You Finish Early

### Task 13 · Products missing an English category translation
Use `NOT EXISTS` to find products with a non-NULL `product_category_name` that does not exist in `category_translation`. Return `product_id` and `product_category_name`, ordered by `product_id`.

<details>
<summary>Hint</summary>
Check `p.product_category_name IS NOT NULL AND NOT EXISTS (...)`.
</details>

> **Verification:** Expected `1` row | First row: `(c7a3f1a7f9eef146cc499368b578b884, portateis_cozinha_e_preparadores_de_alimentos)`

### Task 14 · Average delivery time by state (CTE + `GROUP BY`)
Use a CTE to compute `DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)` as `delivery_days` for every delivered order (joined with `customers`). Then group by `customer_state`, keeping states with at least `30` deliveries, and return `customer_state`, `delivery_count`, and `ROUND(AVG(delivery_days), 2)` as `avg_days`. Sort by `avg_days` descending, then `customer_state`.

<details>
<summary>Hint</summary>
Filter `WHERE o.order_delivered_customer_date IS NOT NULL` inside the CTE.
</details>

> **Verification:** Expected `15` rows | First row: `(PA, 32, 26.34)`

### Task 15 · Compare payment total vs item+freight total (two CTEs)
Create two CTEs:
1. `paid`: `SUM(payment_value)` per `order_id` from `order_payments`
2. `items`: `SUM(price + freight_value)` per `order_id` from `order_items`

Join them on `order_id` and find orders where `ABS(total_paid - total_items) > 1.00`. Return `order_id`, `total_paid`, `total_items`, and `total_paid - total_items` as `difference`. Sort by `ABS(total_paid - total_items)` descending, then `order_id`.

<details>
<summary>Hint</summary>
Separate two CTEs with a comma: `WITH paid AS (...), items AS (...) SELECT ... FROM paid p JOIN items i ON i.order_id = p.order_id`.
</details>

> **Verification:** Expected `4` rows | First row: `(a69aaa894f707814637e9794aa556f0f, 211.87, 179.35, 32.52)`

---

## Capstone sprint

**C6:** Add two multi-step queries. Record schema feedback and what you changed.

## Submit

Answers in `work.sql`, reflection in `reflection.md`, output in `results/`. Commit and push. See [SUBMISSIONS.md](../../SUBMISSIONS.md).
