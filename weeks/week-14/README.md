# Week 14 Practice Pack · Redis Caching, Data Types & Leaderboards

> Printable version: [README.pdf](README.pdf)

- **Course:** FESE304 — Database Management Systems
- **Topic:** Redis Strings & TTL, Sorted Sets (Leaderboards), Hashes, Sets, Lists & Cache-Aside Fixes
- **Level:** Beginner to Medium (designed for self-study at home)
- **Target Engine & Namespace:** Redis 7.4 (`fese304:w14:*`)
- **Dataset Sources & Licenses:**
  - F1DB Open Source Formula 1 Database (`v2026.20.0`, Grand Prix-only points — Sprint points excluded, [CC BY 4.0](https://github.com/f1db/f1db))
  - Olist Brazilian E-Commerce Public Dataset ([CC BY-NC-SA 4.0](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce))

## How to Use This Pack at Home

1. Load the seed keys into your local Redis container:
   ```bash
   docker compose exec -T redis redis-cli < weeks/week-14/dataset.redis
   ```
2. Open an interactive `redis-cli` session (or connect **Redis Insight** to `localhost:6389`):
   ```bash
   docker compose exec redis redis-cli
   ```
3. Run the **Worked Example**, complete **Core Practice (Tasks 1–12)**, and try **Optional Stretch (Tasks 13–15)** if you finish early.
4. *(Whenever you want to reset all keys and TTLs back to their starting values, just re-run step 1!)*

---

## Key Namespace Reference (`fese304:w14:*`)

| Key | Redis Type | Contents |
| --- | --- | --- |
| `fese304:w14:cache:driver_standings:2024` | `STRING` (EX 1800) | Cached JSON summary of 2024 F1 GP standings |
| `fese304:w14:cache:category:health_beauty` | `STRING` (EX 3600) | Cached JSON summary of Olist `health_beauty` GMV |
| `fese304:w14:cache:stale_demo` | `STRING` (`TTL = -1`) | Stale Round 23 snapshot without TTL (for Task 11) |
| `fese304:w14:lb:f1_2024` | `ZSET` (24 members) | 2024 F1 drivers ranked by GP points (`max-verstappen`: `399`) |
| `fese304:w14:lb:f1_2025` | `ZSET` (21 members) | 2025 F1 drivers ranked by GP points (`lando-norris`: `394`) |
| `fese304:w14:lb:f1_constructors_2024` | `ZSET` (10 members) | 2024 F1 constructors ranked by GP points |
| `fese304:w14:lb:olist_categories` | `ZSET` (20 members) | Top 20 Olist categories ranked by GMV (BRL) |
| `fese304:w14:driver:<driver_id>` | `HASH` (10 keys) | Driver profile fields (`name`, `code`, `nationality`, `points_2024`, `career_wins`, ...) |
| `fese304:w14:podium_drivers:2024` / `:2025` | `SET` (10 / 9 members) | Drivers who stood on a GP podium in 2024 / 2025 |

---

## Worked Example (Try This First!)

Check the type and member count of the 2024 F1 leaderboard:

```redis
TYPE fese304:w14:lb:f1_2024
ZCARD fese304:w14:lb:f1_2024
```

> **Verification:** `TYPE` returns `zset` | `ZCARD` returns `24`

---

## Part 1: Basics — Reading Strings, Sorted Sets, Hashes & Sets (Tasks 1–5) — Core Practice

### Task 1 · Read a cached JSON string and check its `TTL`
Retrieve the value and remaining expiration time (in seconds) of `fese304:w14:cache:driver_standings:2024`.

<details>
<summary>Hint</summary>
Use `GET` and `TTL`.
</details>

> **Verification:** `GET` returns `{"season":2024,"leader":"max-verstappen","points":399,"runner_up":"lando-norris"}` | `TTL` returns a positive integer `<= 1800`

### Task 2 · Top 5 F1 2024 drivers with scores (`ZREVRANGE`)
Retrieve the top 5 members (indices `0` to `4`) and their scores from `fese304:w14:lb:f1_2024` in descending order.

<details>
<summary>Hint</summary>
`ZREVRANGE fese304:w14:lb:f1_2024 0 4 WITHSCORES`
</details>

> **Verification:** `5` pairs starting with `max-verstappen` (`399`), `lando-norris` (`344`), `charles-leclerc` (`327`), `oscar-piastri` (`265`), `carlos-sainz-jr` (`262`)

### Task 3 · Read an entire driver profile hash (`HGETALL`)
Return all field-value pairs in `fese304:w14:driver:max-verstappen`.

> **Verification:** `8` field-value pairs including `name = "Max Verstappen"`, `code = "VER"`, `points_2024 = "399"`, `career_wins = "74"`

### Task 4 · Fetch specific hash fields (`HMGET`)
Fetch only `name`, `nationality`, and `career_wins` from `fese304:w14:driver:lewis-hamilton`.

<details>
<summary>Hint</summary>
`HMGET fese304:w14:driver:lewis-hamilton name nationality career_wins`
</details>

> **Verification:** Returns `"Lewis Hamilton"`, `"United Kingdom"`, `"106"`

### Task 5 · Set size and membership (`SCARD`, `SISMEMBER`)
On `fese304:w14:podium_drivers:2024`, count how many drivers are in the set, then check whether `max-verstappen` and `fernando-alonso` are members.

<details>
<summary>Hint</summary>
Use `SCARD` for the count and `SISMEMBER key member` (`1` = yes, `0` = no).
</details>

> **Verification:** `SCARD` returns `10` | `SISMEMBER` returns `1` for `max-verstappen` and `0` for `fernando-alonso`

---

## Part 2: Everyday Practice — Ranks, Carts, Set Algebra & Feeds (Tasks 6–10) — Core Practice

### Task 6 · Find a category’s rank and score (`ZREVRANK`, `ZSCORE`)
On `fese304:w14:lb:olist_categories`, find the 0-based descending rank and exact GMV score of `computers_accessories`.

<details>
<summary>Hint</summary>
Run `ZREVRANK` and `ZSCORE` on `fese304:w14:lb:olist_categories computers_accessories`.
</details>

> **Verification:** `ZREVRANK` returns `4` (5th place) | `ZSCORE` returns `"911954.32"`

### Task 7 · Score-range counts and bottom-ranked teams (`ZCOUNT`, `ZRANGE`)
1. Count how many drivers scored at least `100` points (`100` to `+inf`) in `fese304:w14:lb:f1_2024`.
2. Show the bottom 3 constructors (ascending order) with scores from `fese304:w14:lb:f1_constructors_2024`.

<details>
<summary>Hint</summary>
`ZCOUNT fese304:w14:lb:f1_2024 100 +inf` and `ZRANGE fese304:w14:lb:f1_constructors_2024 0 2 WITHSCORES`.
</details>

> **Verification:** `ZCOUNT` returns `8` | `ZRANGE` returns `kick-sauber` (`4`), `williams` (`17`), `rb` (`40`)

### Task 8 · Shopping cart hash (`HSET`, `HINCRBY`, `HGETALL`, `DEL`)
Build a practice shopping cart in `fese304:w14:cart:cust_101`:
1. Start clean with `DEL fese304:w14:cart:cust_101`.
2. Add `prod_watch` = `1` and `prod_perfume` = `2` using `HSET`.
3. Increase `prod_watch` by `2` using `HINCRBY`.
4. Read the cart with `HGETALL`, then delete the scratch key with `DEL`.

<details>
<summary>Hint</summary>
`HSET fese304:w14:cart:cust_101 prod_watch 1 prod_perfume 2` followed by `HINCRBY fese304:w14:cart:cust_101 prod_watch 2`.
</details>

> **Verification:** `HINCRBY` returns `3` | `HGETALL` returns `prod_watch = "3"`, `prod_perfume = "2"`

### Task 9 · Compare 2024 and 2025 podium sets (`SINTER`, `SDIFF`)
1. Find drivers who got a podium in **both** 2024 and 2025 (`SINTER`).
2. Find drivers who got a podium in **2025 but not 2024** (`SDIFF`).

<details>
<summary>Hint</summary>
Put the 2025 set first in `SDIFF fese304:w14:podium_drivers:2025 fese304:w14:podium_drivers:2024`.
</details>

> **Verification:** `SINTER` returns `6` drivers (`carlos-sainz-jr`, `charles-leclerc`, `george-russell`, `lando-norris`, `max-verstappen`, `oscar-piastri`) | `SDIFF` returns `3` drivers (`isack-hadjar`, `kimi-antonelli`, `nico-hulkenberg`)

### Task 10 · Recent-activity feed list (`LPUSH`, `LTRIM`, `LRANGE`)
Create a 3-item recent-events feed in `fese304:w14:feed:race_control` (illustrative log entries):
1. `DEL fese304:w14:feed:race_control`
2. Push 4 events with `LPUSH`: `"LAP 1: GREEN FLAG"`, `"LAP 18: PIT STOP VER"`, `"LAP 42: SAFETY CAR"`, `"LAP 57: CHEQUERED FLAG"`.
3. Keep only the 3 newest items with `LTRIM ... 0 2`.
4. Read all remaining items with `LRANGE ... 0 -1`, then clean up with `DEL`.

<details>
<summary>Hint</summary>
Because `LPUSH` inserts at the left (head), the last pushed item (`"LAP 57: CHEQUERED FLAG"`) ends up at index `0`.
</details>

> **Verification:** `LRANGE` returns 3 items: `"LAP 57: CHEQUERED FLAG"`, `"LAP 42: SAFETY CAR"`, `"LAP 18: PIT STOP VER"`

---

## Part 3: Fix the Bug (Tasks 11–12) — Core Practice

### Task 11 · Stale cache key missing a `TTL` (`TTL = -1`)
`fese304:w14:cache:stale_demo` was saved with a bare `SET` and no `EX`, so `TTL` returns `-1` (never expires!) and serves outdated Round 23 points (`319` instead of `344`).
1. Copy it to a scratch key: `COPY fese304:w14:cache:stale_demo fese304:w14:scratch:stale_demo REPLACE`.
2. Run `GET` and `TTL` on the scratch copy to see `319` and `-1`.
3. Fix it by overwriting with `344` and `EX 300`:
   ```redis
   SET fese304:w14:scratch:stale_demo '{"driver_id":"lando-norris","points_2024":344,"note":"refreshed from lb:f1_2024 with 300s TTL"}' EX 300
   ```
4. Check `GET` and `TTL` again, then `DEL` the scratch key.

<details>
<summary>Hint</summary>
In Redis, `TTL = -1` means "exists with no expiration", while `TTL = -2` means "key does not exist".
</details>

> **Verification:** Before fix: `TTL = -1` | After fix: `points_2024 = 344` and `TTL` in `1..300`

### Task 12 · Bare `SET` wipes out an existing `TTL`
If you overwrite an expiring key with a plain `SET`, Redis **removes its expiration** (`TTL` resets to `-1`)!
1. Run `SET fese304:w14:cache:ttl_trap '{"status":"v1"}' EX 600`.
2. Overwrite it with a bare `SET fese304:w14:cache:ttl_trap '{"status":"v2_stripped"}'` and run `TTL` → observe `-1`!
3. Restore `EX 600` (`'{"status":"v2_restored"}'`), then safely update with `KEEPTTL`:
   ```redis
   SET fese304:w14:cache:ttl_trap '{"status":"v3_kept"}' KEEPTTL
   ```
4. Check `GET` and `TTL`, then `DEL fese304:w14:cache:ttl_trap`.

<details>
<summary>Hint</summary>
Always pass either `KEEPTTL` or a fresh `EX <seconds>` when updating a cached key.
</details>

> **Verification:** After bare `SET`: `TTL = -1` | After `KEEPTTL`: `GET` returns `{"status":"v3_kept"}` and `TTL` in `1..600`

---

## Part 4: Optional Stretch (Tasks 13–15) — Try If You Finish Early

### Task 13 · Live leaderboard score update (`COPY`, `ZINCRBY`, `ZREVRANK`)
Copy `fese304:w14:lb:f1_2025` to `fese304:w14:scratch:lb_f1_2025`, add `25.0` points to `lando-norris` with `ZINCRBY`, check his new descending rank with `ZREVRANK`, and delete the scratch key.

<details>
<summary>Hint</summary>
`ZINCRBY fese304:w14:scratch:lb_f1_2025 25.0 lando-norris`
</details>

> **Verification:** `ZINCRBY` returns `"419"` | `ZREVRANK` returns `0` (1st place)

### Task 14 · Cache-aside invalidation and repopulation
On a scratch copy `fese304:w14:scratch:cache_health_beauty` copied from `fese304:w14:cache:category:health_beauty`:
1. Invalidate it with `DEL`, confirm cache miss with `EXISTS` (`0`).
2. Repopulate it with `SET ... '{"category":"health_beauty","gmv":1258681.34,"distinct_orders":8836,"source":"olist_mysql"}' EX 3600`.
3. Verify with `GET` and `TTL`, then clean up with `DEL`.

<details>
<summary>Hint</summary>
This is the exact pattern web backends use when database data changes: delete old cache → next request writes fresh cache with a TTL.
</details>

> **Verification:** `EXISTS` returns `0` after delete | Repopulated `TTL` is in `1..3600`

### Task 15 · Combine two seasons into one leaderboard (`ZUNIONSTORE`)
Combine `fese304:w14:lb:f1_2024` and `fese304:w14:lb:f1_2025` into `fese304:w14:lb:f1_combined_24_25` using `ZUNIONSTORE`, list the top 5 cumulative scorers with `ZREVRANGE ... 0 4 WITHSCORES`, and clean up with `DEL`.

<details>
<summary>Hint</summary>
`ZUNIONSTORE fese304:w14:lb:f1_combined_24_25 2 fese304:w14:lb:f1_2024 fese304:w14:lb:f1_2025`
</details>

> **Verification:** `ZUNIONSTORE` returns `27` | Top 5: `max-verstappen` (`788`), `lando-norris` (`738`), `oscar-piastri` (`646`), `charles-leclerc` (`552`), `george-russell` (`515`)

---

## Capstone sprint

**C14 / Checkpoint 4:** Redis feature, NoSQL model and a demo rehearsal.

## Submit

Answers in `work.md`, reflection in `reflection.md`, output in `results/`. Commit and push. See [SUBMISSIONS.md](../../SUBMISSIONS.md).
