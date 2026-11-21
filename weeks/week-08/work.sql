-- WEEK-08 Practice Work (w08_normalization)
-- Import weeks/week-08/dataset.sql first, then write your queries below.
-- Core Practice: Tasks 1-12 | Optional Stretch: Tasks 13-15

USE w08_normalization;

-- ===== Part 1: Basics (Tasks 1-5) — Core Practice =====
-- Task 1 · Spot the 1NF problem in `raw_movies`
-- TODO

-- Task 2 · Why `order_id` alone cannot be the primary key
-- TODO

-- Task 3 · Find multi-item orders (where order & customer info repeats)
-- TODO

-- Task 4 · Spot seller update anomalies (3NF)
-- TODO

-- Task 5 · Spot category translation redundancy (3NF)
-- TODO

-- ===== Part 2: Everyday Practice (Tasks 6-10) — Core Practice =====
-- Task 6 · 1NF hands-on: one genre per row
-- TODO

-- Task 7 · 2NF: split `raw_order_lines` into order headers and order items
-- TODO

-- Task 8 · 3NF (Part A): separate customers from orders
-- TODO

-- Task 9 · 3NF (Part B): separate sellers, products, categories, and lines
-- TODO

-- Task 10 · Lossless-join check (rejoin your 6 normalized tables)
-- TODO

-- ===== Part 3: Fix the Bug (Tasks 11-12) — Core Practice =====
-- Task 11 · Lossy join on a non-key column (`customer_city`)
-- TODO

-- Task 12 · Silent row loss when forgetting `order_item_id`
-- TODO

-- ===== Part 4: Optional Stretch (Tasks 13-15) =====
-- Task 13 · Test a functional dependency (`order_id → customer_id`)
-- TODO

-- Task 14 · Test a transitive dependency (`product_category_pt → product_category_en`)
-- TODO

-- Task 15 · Run a clean business report on your 3NF tables
-- TODO
