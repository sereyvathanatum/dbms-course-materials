# Week 13 Practice Pack · Formula 1 MongoDB Aggregation Pipelines

> Printable version: [README.pdf](README.pdf)

- **Course:** FESE304 — Database Management Systems
- **Topic:** MongoDB Aggregation Pipelines (`$match`, `$project`, `$group`, `$sort`, `$limit`, `$unwind`, `$lookup`)
- **Level:** Low-to-Medium (designed for self-study at home)
- **Target Engine & Namespace:** MongoDB 8.0 (`w13_f1`: collections `races`, `drivers`, `constructors`)
- **Dataset Source & License:** [F1DB Open Source Formula 1 Database (`v2026.20.0`, 2023–2025 seasons, CC BY 4.0)](https://github.com/f1db/f1db)

## How to Use This Pack at Home

1. Load the dataset into your local MongoDB container:
   ```bash
   docker compose exec -T mongo mongosh --quiet < weeks/week-13/dataset.js
   ```
2. Open `mongosh` (`docker compose exec mongo mongosh`) and run `use w13_f1;` — or use **MongoDB Compass**’s Aggregations tab to build pipelines one stage at a time!
3. Think of an aggregation pipeline like SQL clauses in order: `$match` = `WHERE`, `$unwind` = flatten an array, `$group` = `GROUP BY`, `$project` = `SELECT`, `$sort` = `ORDER BY`, `$limit` = `LIMIT`, `$lookup` = `LEFT JOIN`.
4. Note: `races.results.points` stores **Grand Prix-only** points (Sprint points are excluded).
5. Complete **Core Practice (Tasks 1–12)** first; try **Optional Stretch (Tasks 13–15)** if you finish early.

---

## Collections & Real Sample Document

| Collection | Docs | Key Fields |
| --- | ---: | --- |
| `races` | 70 | `_id`, `season` (2023–2025), `round`, `date`, `official_name`, `laps`, `distance_km`, embedded `circuit: { circuit_id, name, type, country_name, continent, turns }`, and embedded `results: [{ position_order, position_number, position_text, driver_id, driver_name, constructor_id, constructor_name, grid_position, laps, points, pit_stops, reason_retired }]` |
| `drivers` | 28 | `_id` (e.g. `"max-verstappen"`), `name`, `nationality`, `career_championships`, `career_race_wins` |
| `constructors` | 13 | `_id` (e.g. `"mclaren"`), `name`, `full_name`, `country_name`, `career_championships` |

**Shortened real document from `races` (`_id: 1102`):**

```json
{
  "_id": 1102,
  "season": 2024,
  "round": 1,
  "official_name": "Formula 1 Gulf Air Bahrain Grand Prix 2024",
  "laps": 57,
  "circuit": { "circuit_id": "bahrain", "name": "Bahrain", "type": "RACE", "country_name": "Bahrain", "continent": "asia", "turns": 15 },
  "results": [
    { "position_number": 1, "driver_id": "max-verstappen", "driver_name": "Max Verstappen", "constructor_id": "red-bull", "constructor_name": "Red Bull", "grid_position": 1, "laps": 57, "points": 26, "pit_stops": 2 }
  ]
}
```

---

## Worked Example (Try This First!)

Count how many races took place in the `2024` season:

```javascript
db.races.aggregate([
  { $match: { season: 2024 } },
  { $count: "races_2024" }
]);
```

> **Verification:** Expected `1` document | First: `{"races_2024":24}`

---

## Part 1: Basics — Core Pipeline Stages (Tasks 1–5) — Core Practice

### Task 1 · 2024 street-circuit races (`$match`, `$project`, `$sort`)
Filter `db.races` for `season: 2024` and `"circuit.type": "STREET"`. Project `{ _id: 1, round: 1, official_name: 1, circuit_name: "$circuit.name", country: "$circuit.country_name" }` and sort by `{ round: 1 }`.

> **Verification:** Expected `8` documents | First: `{"_id":1103,"round":2,"official_name":"Formula 1 stc Saudi Arabian Grand Prix 2024","circuit_name":"Jeddah","country":"Saudi Arabia"}`

### Task 2 · Races and total laps per season (`$group`, `$sort`)
Group `db.races` by `_id: "$season"` to compute `race_count: { $sum: 1 }` and `total_laps: { $sum: "$laps" }`. Sort by `{ _id: 1 }`.

> **Verification:** Expected `3` documents | First: `{"_id":2023,"race_count":22,"total_laps":1325}`

### Task 3 · Count races per continent (`$group`, `$sort`)
Group `db.races` by `_id: "$circuit.continent"` to compute `race_count: { $sum: 1 }`. Sort by `{ race_count: -1, _id: 1 }`.

> **Verification:** Expected `5` documents | First: `{"_id":"europe","race_count":26}`

### Task 4 · All 2024 Grand Prix winners (`$match`, `$unwind`, `$match`)
1. `$match` `season: 2024`.
2. `$unwind: "$results"` (turns each race’s 20 results into 20 separate documents).
3. `$match` `"results.position_number": 1`.
4. `$project` `{ _id: 0, round: 1, winner: "$results.driver_name", constructor: "$results.constructor_name", points: "$results.points" }` and `$sort` by `{ round: 1 }`.

<details>
<summary>Hint</summary>
Notice we put `{ $match: { season: 2024 } }` *before* `$unwind` so MongoDB only unwinds 24 races instead of all 70!
</details>

> **Verification:** Expected `24` documents | First: `{"round":1,"winner":"Max Verstappen","constructor":"Red Bull","points":26}`

### Task 5 · Top 5 drivers by 2024 Grand Prix points (`$unwind` + `$group`)
Filter `season: 2024`, `$unwind: "$results"`, and `$group` by `_id: "$results.driver_id"` with `driver_name: { $first: "$results.driver_name" }` and `total_points: { $sum: "$results.points" }`. Sort by `{ total_points: -1, _id: 1 }` and `$limit: 5`.

> **Verification:** Expected `5` documents | First: `{"_id":"max-verstappen","driver_name":"Max Verstappen","total_points":399}`

---

## Part 2: Everyday Practice — Grouping, Math & `$lookup` Joins (Tasks 6–10) — Core Practice

### Task 6 · Top 5 circuits by number of turns
Group `db.races` by `_id: "$circuit.circuit_id"` keeping `$first` of `circuit_name: "$circuit.name"`, `country: "$circuit.country_name"`, and `turns: "$circuit.turns"`. Sort by `{ turns: -1, _id: 1 }` and limit to `5`.

<details>
<summary>Hint</summary>
Because a circuit appears once per season, grouping by `"$circuit.circuit_id"` deduplicates circuits cleanly.
</details>

> **Verification:** Expected `5` documents | First: `{"_id":"jeddah","circuit_name":"Jeddah","country":"Saudi Arabia","turns":27}`

### Task 7 · Top 5 DNF retirement reasons (2023–2025)
Unwind `"$results"`, match `"results.position_text": "DNF"`, group by `_id: "$results.reason_retired"` with `dnf_count: { $sum: 1 }`, sort by `{ dnf_count: -1, _id: 1 }`, and limit to `5`.

<details>
<summary>Hint</summary>
Stages: `$unwind` → `$match` → `$group` → `$sort` → `$limit`.
</details>

> **Verification:** Expected `5` documents | First: `{"_id":"Collision","dnf_count":29}`

### Task 8 · Constructor total points and average pit stops (2023–2025)
Unwind `"$results"`, group by `_id: "$results.constructor_id"` computing `constructor_name: { $first: "$results.constructor_name" }`, `total_points: { $sum: "$results.points" }`, and `avg_pit_stops: { $avg: "$results.pit_stops" }`. Project `avg_pit_stops` rounded to 2 decimals (`{ $round: ["$avg_pit_stops", 2] }`) and sort by `{ total_points: -1, _id: 1 }`.

<details>
<summary>Hint</summary>
In `$project`, include `constructor_name: 1, total_points: 1, avg_pit_stops: { $round: ["$avg_pit_stops", 2] }`.
</details>

> **Verification:** Expected `13` documents | First: `{"_id":"red-bull","constructor_name":"Red Bull","total_points":1737,"avg_pit_stops":1.89}`

### Task 9 · Join 2024 constructor standings with `constructors` (`$lookup`)
1. Match `season: 2024`, unwind `"$results"`, and group by `_id: "$results.constructor_id"` with `points_2024: { $sum: "$results.points" }`.
2. Add `$lookup` from `"constructors"` (`localField: "_id"`, `foreignField: "_id"`, `as: "team"`) and `$unwind: "$team"`.
3. Project `{ full_name: "$team.full_name", country_name: "$team.country_name", points_2024: 1 }` and sort by `{ points_2024: -1, _id: 1 }`.

<details>
<summary>Hint</summary>
```javascript
{ $lookup: { from: "constructors", localField: "_id", foreignField: "_id", as: "team" } },
{ $unwind: "$team" }
```
</details>

> **Verification:** Expected `10` documents | First: `{"_id":"mclaren","points_2024":609,"full_name":"McLaren Racing","country_name":"United Kingdom"}`

### Task 10 · Join 2025 top 5 drivers with `drivers` (`$lookup`)
Match `season: 2025`, unwind `"$results"`, and group by `_id: "$results.driver_id"` with `points_2025: { $sum: "$results.points" }`. Use `$lookup` into `"drivers"` (`as: "profile"`), unwind `"$profile"`, project `{ name: "$profile.name", nationality: "$profile.nationality", points_2025: 1 }`, sort by `{ points_2025: -1, _id: 1 }`, and limit to `5`.

<details>
<summary>Hint</summary>
Follow the exact same `$lookup` + `$unwind` pattern as Task 9, pointing `from: "drivers"`.
</details>

> **Verification:** Expected `5` documents | First: `{"_id":"lando-norris","points_2025":394,"name":"Lando Norris","nationality":"United Kingdom"}`

---

## Part 3: Fix the Bug (Tasks 11–12) — Core Practice

### Task 11 · Summing a parent field after `$unwind` multiplies it by 20!
The pipeline below tries to sum 2024 scheduled race laps (`$laps`) and driver laps completed (`$results.laps`), but `$unwind` duplicates each race 20 times — inflating `scheduled_race_laps` from `1,444` to `28,822`! Fix it by removing `$unwind` and using `$project` with `driver_laps: { $sum: "$results.laps" }` before `$group`.

```javascript
db.races.aggregate([
  { $match: { season: 2024 } },
  { $unwind: "$results" },
  {
    $group: {
      _id: "$season",
      scheduled_race_laps: { $sum: "$laps" },
      total_driver_laps_completed: { $sum: "$results.laps" }
    }
  }
]);
```

<details>
<summary>Hint</summary>
Inside `$project`, `{ $sum: "$results.laps" }` sums all `laps` values inside a race’s `results` array without unwinding the document!
</details>

> **Verification:** Expected `1` document | First: `{"_id":2024,"scheduled_race_laps":1444,"total_driver_laps_completed":26544}`

### Task 12 · Forgetting `$unwind` before grouping on an array field
The pipeline below tries to count how many 2024 races each driver entered, but without `$unwind: "$results"`, `_id` becomes an *entire 20-element array* of driver IDs! Add `{ $unwind: "$results" }` right after `$match` so you get one clean row per driver (`24` drivers), sorted by `{ races_entered: -1, _id: 1 }`.

```javascript
db.races.aggregate([
  { $match: { season: 2024 } },
  { $group: { _id: "$results.driver_id", races_entered: { $sum: 1 } } },
  { $sort: { races_entered: -1, _id: 1 } }
]);
```

<details>
<summary>Hint</summary>
Insert `{ $unwind: "$results" },` between `$match` and `$group`.
</details>

> **Verification:** Expected `24` documents | First: `{"_id":"alexander-albon","races_entered":24}`

---

## Part 4: Optional Stretch (Tasks 13–15) — Try If You Finish Early

### Task 13 · Top 5 biggest grid-to-finish gains (`$subtract`)
Unwind `"$results"`, match rows where both `"results.position_number"` and `"results.grid_position"` are `{ $ne: null }`, and project `season`, `round`, `driver_name`, `grid`, `finish`, and `positions_gained: { $subtract: ["$results.grid_position", "$results.position_number"] }` (`_id: 0`). Sort by `{ positions_gained: -1, season: 1, round: 1, driver_name: 1 }` and limit to `5`.

<details>
<summary>Hint</summary>
Starting P17 and finishing P1 gives `17 - 1 = +16` positions gained.
</details>

> **Verification:** Expected `5` documents | First: `{"season":2024,"round":21,"driver_name":"Max Verstappen","grid":17,"finish":1,"positions_gained":16}`

### Task 14 · Top 5 driver nationalities by total 2023–2025 points
Unwind `"$results"`, group by `_id: "$results.driver_id"` with `total_points: { $sum: "$results.points" }`, `$lookup` `"drivers"` (`as: "driver"`), `$unwind: "$driver"`, then add a second `$group` by `_id: "$driver.nationality"` computing `driver_count: { $sum: 1 }` and `nationality_points: { $sum: "$total_points" }`. Sort by `{ nationality_points: -1, _id: 1 }` and limit to `5`.

<details>
<summary>Hint</summary>
You can chain two `$group` stages in one pipeline: first per driver, then per nationality after `$lookup`.
</details>

> **Verification:** Expected `5` documents | First: `{"_id":"United Kingdom","driver_count":4,"nationality_points":2199}`

### Task 15 · Drivers who raced for multiple constructors (2023–2025)
Unwind `"$results"`, group by `_id: "$results.driver_id"` with `driver_name: { $first: "$results.driver_name" }` and `constructors: { $addToSet: "$results.constructor_name" }`. Project `driver_name` and `constructor_count: { $size: "$constructors" }`, match `{ constructor_count: { $gt: 1 } }`, and sort by `{ constructor_count: -1, _id: 1 }`.

<details>
<summary>Hint</summary>
`$addToSet` collects unique constructor names per driver, and `$size` counts how many there are.
</details>

> **Verification:** Expected `11` documents | First: `{"_id":"liam-lawson","driver_name":"Liam Lawson","constructor_count":4}`

---

## Capstone sprint

**C13:** Three pipelines with output, and your document-model choice.

## Submit

Answers in `work.js`, reflection in `reflection.md`, output in `results/`. Commit and push. See [SUBMISSIONS.md](../../SUBMISSIONS.md).
