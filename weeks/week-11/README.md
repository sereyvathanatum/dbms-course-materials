# Week 11 Practice Pack · MovieLens Application Queries & Window Functions

> Printable version: [README.pdf](README.pdf)

- **Course:** FESE304 — Database Management Systems
- **Topic:** Application Backend Queries, Parameterized Queries (SQL Injection Defense), Pagination & Introductory Window Functions (`ROW_NUMBER`, `RANK`, `DENSE_RANK`, `AVG() OVER`)
- **Level:** Low-to-Medium (designed for self-study at home)
- **Target Engine & Database:** MySQL 8.4 (`w11_movielens`)
- **Dataset Source & License:** [GroupLens Research MovieLens (`ml-latest-small` normalized subset, Educational Non-Commercial License)](https://files.grouplens.org/datasets/movielens/ml-latest-small-README.html)

## How to Use This Pack at Home

1. Run `weeks/week-11/dataset.sql` in DBeaver ([import guide](../../setup/DBEAVER-IMPORT-GUIDE.md)) (`Alt+X`) to create `w11_movielens`, then refresh (`F5`).
2. In Python/Node.js apps, you pass user values into `?` or `%s` placeholders. In MySQL SQL editors, you can practice the exact same idea with `PREPARE ... EXECUTE ... USING` (we keep it to just 2 focused tasks so it stays clean!).
3. Run the **Worked Example**, complete **Core Practice (Tasks 1–12)**, and try **Optional Stretch (Tasks 13–15)** if you finish early.

---

## Tables & Real Sample Rows

| Table | Rows | Columns |
| --- | ---: | --- |
| `movie` | 1,393 | `movie_id` (PK), `title`, `release_year` |
| `genre` | 19 | `genre_id` (PK), `genre_name` |
| `movie_genre` | 3,757 | `(movie_id, genre_id)` (PK, FKs → `movie`, `genre`) |
| `rating` | 18,000 | `(user_id, movie_id)` (PK, FK → `movie`), `rating` (`0.5`–`5.0`), `rated_at` |
| `movie_tag` | 2,138 | `tag_id` (PK), `user_id`, `movie_id` (FK → `movie`), `tag`, `tagged_at` |

**Sample rows from `movie` and `rating`:**

| `movie_id` | `title` | `release_year` | | `user_id` | `movie_id` | `rating` | `rated_at` |
| ---: | --- | ---: | --- | ---: | ---: | ---: | --- |
| 1 | Toy Story (1995) | 1995 | | 1 | 1 | 4.0 | `2000-07-30 18:45:03` |
| 2 | Jumanji (1995) | 1995 | | 1 | 3 | 4.0 | `2000-07-30 18:20:47` |

---

## Worked Example (Try This First!)

Run a parameterized lookup in MySQL using `?` (the same safe pattern used by app drivers in Python and Node.js):

```sql
PREPARE w11_demo FROM 'SELECT movie_id, title, release_year FROM movie WHERE movie_id = ?';
SET @id = 2;
EXECUTE w11_demo USING @id;
DEALLOCATE PREPARE w11_demo;
```

> **Verification:** Expected `1` row | First row: `(2, Jumanji (1995), 1995)`

---

## Part 1: Basics — Everyday App Backend Queries (Tasks 1–5) — Core Practice

### Task 1 · Parameterized movie detail page query
Using the Worked Example pattern (`PREPARE`, `SET`, `EXECUTE`, `DEALLOCATE`), look up `movie_id`, `title`, and `release_year` where `movie_id = ?` with `@movie_id = 1`.

> **Verification:** Expected `1` row | First row: `(1, Toy Story (1995), 1995)`

### Task 2 · Genres for a movie detail page
Join `movie_genre` and `genre` to list `genre_name` for `movie_id = 1`, sorted alphabetically.

> **Verification:** Expected `5` rows | First row: `(Adventure)`

### Task 3 · Search bar prefix lookup
Show `movie_id` and `title` for movies whose `title` starts with `'Toy'` (`LIKE 'Toy%'`), sorted by `movie_id`, limited to 5 rows.

> **Verification:** Expected `3` rows | First row: `(1, Toy Story (1995))`

### Task 4 · Offset pagination (Page 2 of 1995 movies)
Show `movie_id`, `title`, and `release_year` for `release_year = 1995`, sorted by `movie_id`, returning page 2 (`LIMIT 5 OFFSET 5`).

> **Verification:** Expected `5` rows | First row: `(6, Heat (1995), 1995)`

### Task 5 · Keyset (“Load More”) pagination
Instead of `OFFSET 5` (which gets slow on deep pages), filter directly past the last ID seen on Page 1 (`movie_id = 5`): show `movie_id`, `title`, and `release_year` where `release_year = 1995 AND movie_id > 5`, sorted by `movie_id`, `LIMIT 5`. Notice it returns the exact same Page 2!

<details>
<summary>Hint</summary>
`WHERE release_year = 1995 AND movie_id > 5 ORDER BY movie_id LIMIT 5;`
</details>

> **Verification:** Expected `5` rows | First row: `(6, Heat (1995), 1995)`

---

## Part 2: Everyday Practice — Reporting & Intro Window Functions (Tasks 6–10) — Core Practice

### Task 6 · Movie counts per year (1995–1999)
Group `movie` by `release_year` for years `BETWEEN 1995 AND 1999`. Return `release_year` and `COUNT(*)` as `movie_count`, ordered by `release_year`.

<details>
<summary>Hint</summary>
Filter with `WHERE release_year BETWEEN 1995 AND 1999`, then `GROUP BY release_year`.
</details>

> **Verification:** Expected `5` rows | First row: `(1995, 190)`

### Task 7 · Top 5 most-active tagging users
Group `movie_tag` by `user_id` to return `user_id`, `COUNT(*)` as `tag_count`, and `COUNT(DISTINCT movie_id)` as `tagged_movies`. Sort by `tag_count` descending, then `user_id`, limited to 5 rows.

<details>
<summary>Hint</summary>
Use `COUNT(*)` for total tags and `COUNT(DISTINCT movie_id)` for unique movies tagged.
</details>

> **Verification:** Expected `5` rows | First row: `(474, 647, 517)`

### Task 8 · Number a user’s recent ratings (`ROW_NUMBER()`)
For `user_id = 1` in `rating`, assign a sequential number `row_num` from newest to oldest using `ROW_NUMBER() OVER (ORDER BY rated_at DESC, movie_id)`. Return `row_num`, `movie_id`, `rating`, and `rated_at` for the first 5 rows.

<details>
<summary>Hint</summary>
`SELECT ROW_NUMBER() OVER (ORDER BY rated_at DESC, movie_id) AS row_num, movie_id, rating, rated_at FROM rating WHERE user_id = 1 ORDER BY row_num LIMIT 5;`
</details>

> **Verification:** Expected `5` rows | First row: `(1, 2012, 4.0, 2000-07-30 19:09:36)`

### Task 9 · Rank a user’s top ratings with ties (`RANK()`)
For `user_id = 1`, compute `RANK() OVER (ORDER BY rating DESC) AS rating_rank`. Return `rating_rank`, `movie_id`, and `rating`, ordered by `rating_rank`, then `movie_id`, limited to 5 rows. Notice all `5.0` ratings share rank `1`!

<details>
<summary>Hint</summary>
Keep `movie_id` in the outer `ORDER BY`, NOT inside `OVER (ORDER BY rating DESC)`, so tied `5.0` ratings receive the same rank.
</details>

> **Verification:** Expected `5` rows | First row: `(1, 47, 5.0)`

### Task 10 · Show each rating beside the user’s personal average (`AVG() OVER ()`)
Unlike `GROUP BY` (which collapses rows), a window function keeps every row! For `user_id = 1`, return `movie_id`, `rating`, and `ROUND(AVG(rating) OVER (), 2)` as `user_avg`. Sort by `rated_at`, then `movie_id`, limited to 5 rows.

<details>
<summary>Hint</summary>
`OVER ()` with empty parentheses computes the average across all filtered rows (`WHERE user_id = 1`).
</details>

> **Verification:** Expected `5` rows | First row: `(1210, 5.0, 4.43)`

---

## Part 3: Fix the Bug (Tasks 11–12) — Core Practice

### Task 11 · String concatenation breaks on apostrophes and allows SQL injection
An app builds a query by gluing user input directly into SQL:

```python
sql = f"SELECT movie_id, title FROM movie WHERE title = '{title}'"
```

When a user searches `"Mr. Holland's Opus (1995)"`, the apostrophe crashes the query; when an attacker types `' OR '1'='1`, it leaks all 1,393 movies! Fix it with a parameterized `PREPARE` statement (`WHERE title = ?`), bind `@title = 'Mr. Holland''s Opus (1995)'` (escaped quote in MySQL SQL), execute, and deallocate.

<details>
<summary>Hint</summary>
```sql
PREPARE w11_title_search FROM 'SELECT movie_id, title FROM movie WHERE title = ? ORDER BY movie_id';
SET @title = 'Mr. Holland''s Opus (1995)';
EXECUTE w11_title_search USING @title;
DEALLOCATE PREPARE w11_title_search;
```
</details>

> **Verification:** Expected `1` row | First row: `(62, Mr. Holland's Opus (1995))`

### Task 12 · Filtering a window function directly inside `WHERE`
The query below fails with `ERROR 3593: You cannot use the window function 'row_number' in this context`, because `WHERE` runs *before* window functions! Fix it by putting `ROW_NUMBER()` inside a `WITH` CTE and filtering `WHERE rn = 1` in the outer query to get `user_id = 2`’s latest tag for each movie.

```sql
SELECT movie_id, tag, tagged_at
FROM movie_tag
WHERE user_id = 2
  AND ROW_NUMBER() OVER (PARTITION BY movie_id ORDER BY tagged_at DESC, tag_id DESC) = 1
ORDER BY movie_id;
```

<details>
<summary>Hint</summary>
Wrap the `SELECT ..., ROW_NUMBER() OVER (...) AS rn FROM movie_tag WHERE user_id = 2` inside `WITH numbered_tags AS (...)`, then `SELECT movie_id, tag, tagged_at FROM numbered_tags WHERE rn = 1 ORDER BY movie_id;`.
</details>

> **Verification:** Expected `2` rows | First row: `(60756, Highly quotable, 2015-10-24 19:29:56)`

---

## Part 4: Optional Stretch (Tasks 13–15) — Try If You Finish Early

### Task 13 · See the difference between `RANK()` and `DENSE_RANK()`
For `user_id = 1`, compute both `RANK() OVER (ORDER BY rating DESC)` and `DENSE_RANK() OVER (ORDER BY rating DESC)` inside a CTE. Then group by `rating` to show `rating`, `MIN(rnk)`, `MIN(dense_rnk)`, and `COUNT(*)`, sorted by `rating` descending. Notice `RANK` jumps from `1` to `104`, while `DENSE_RANK` goes `1, 2, 3, 4, 5`!

<details>
<summary>Hint</summary>
Put both window functions in `WITH ranked AS (...)`, then `GROUP BY rating` in the outer query.
</details>

> **Verification:** Expected `5` rows | First row: `(5.0, 1, 1, 103)`

### Task 14 · Top 3 highest-rated Action and Comedy movies (`PARTITION BY`)
1. In a CTE `movie_scores`, group `rating` by `movie_id` (`HAVING COUNT(*) >= 10`) to compute `rating_count` and `AVG(rating)` as `avg_rating`.
2. Join with `movie_genre` and `genre` for `genre_name IN ('Action', 'Comedy')`, and compute `RANK() OVER (PARTITION BY g.genre_name ORDER BY ms.avg_rating DESC) AS genre_rank`.
3. Filter `WHERE genre_rank <= 3` and return `genre_name`, `genre_rank`, `movie_id`, `rating_count`, and `ROUND(avg_rating, 2)`. Sort by `genre_name`, `genre_rank`, `movie_id`.

<details>
<summary>Hint</summary>
Use two CTEs (`movie_scores` and `ranked`), then filter `WHERE genre_rank <= 3` in the final `SELECT`.
</details>

> **Verification:** Expected `7` rows | First row: `(Action, 1, 3275, 13, 4.38)`

### Task 15 · Compare each rating with the previous rating (`LAG()`)
For `user_id = 1`, show `movie_id`, `rating`, and `LAG(rating) OVER (ORDER BY rated_at, movie_id)` as `prev_rating` for the first 5 ratings in chronological order (`ORDER BY rated_at, movie_id LIMIT 5`).

<details>
<summary>Hint</summary>
The very first row has no previous rating, so `prev_rating` is naturally `NULL`.
</details>

> **Verification:** Expected `5` rows | First row: `(1210, 5.0, NULL)`

---

## Capstone sprint

**C11 / Checkpoint 3:** A working app with schema, import, objects and queries that a classmate can run from a fresh clone.

## Submit

Answers in `work.sql`, reflection in `reflection.md`, output in `results/`. Commit and push. See [SUBMISSIONS.md](../../SUBMISSIONS.md).
