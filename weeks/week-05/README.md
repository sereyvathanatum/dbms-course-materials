# Week 05 Practice Pack · Chinook Digital Music Store

> Printable version: [README.pdf](README.pdf)

- **Course:** FESE304 — Database Management Systems
- **Topic:** Joining Related Tables (`INNER JOIN`, `LEFT JOIN`, anti-joins, self-joins, multi-table joins, `UNION`)
- **Level:** Beginner to Medium (designed for self-study at home)
- **Target Engine & Database:** MySQL 8.4 (`w05_chinook`)
- **Dataset Source & License:** [Luis Rocha, Chinook Database 1.4.5 (MIT License)](https://github.com/lerocha/chinook-database)

## How to Use This Pack at Home

1. Run `weeks/week-05/dataset.sql` in DBeaver ([import guide](../../setup/DBEAVER-IMPORT-GUIDE.md)) (`Alt+X`) to create `w05_chinook`, then refresh (`F5`).
2. Keep table aliases short and clear (for example, `Album AS al`, `Artist AS ar`).
3. Run the **Worked Example**, complete **Core Practice (Tasks 1–12)**, and try **Optional Stretch (Tasks 13–15)** if you finish early.

---

## Key Tables & Real Sample Rows

| Table | Rows | Key Columns |
| --- | ---: | --- |
| `Artist` | 275 | `ArtistId` (PK), `Name` |
| `Album` | 347 | `AlbumId` (PK), `Title`, `ArtistId` (FK → `Artist`) |
| `Track` | 3,503 | `TrackId` (PK), `Name`, `AlbumId` (FK), `MediaTypeId` (FK), `GenreId` (FK), `UnitPrice` |
| `Genre` / `MediaType` | 25 / 5 | `GenreId` / `MediaTypeId` (PK), `Name` |
| `Playlist` / `PlaylistTrack` | 18 / 8,715 | `PlaylistId` (PK), `Name` / `(PlaylistId, TrackId)` (PK, FKs) |
| `Customer` / `Employee` | 59 / 8 | `CustomerId` (PK), `SupportRepId` (FK → `Employee`) / `EmployeeId` (PK), `LastName`, `ReportsTo` (FK → `Employee`) |
| `Invoice` / `InvoiceLine` | 412 / 2,240 | `InvoiceId` (PK), `CustomerId` (FK), `Total` / `InvoiceLineId` (PK), `InvoiceId` (FK), `TrackId` (FK), `UnitPrice`, `Quantity` |

**Sample rows from `Album` and `Artist`:**

| `AlbumId` | `Title` | `ArtistId` | | `ArtistId` | `Name` |
| ---: | --- | ---: | --- | ---: | --- |
| 1 | For Those About To Rock We Salute You | 1 | | 1 | AC/DC |
| 2 | Balls to the Wall | 2 | | 2 | Accept |

---

## Worked Example (Try This First!)

Join `Album` and `Artist` to show the first 3 albums with their artist’s name:

```sql
SELECT al.AlbumId, al.Title, ar.Name AS artist_name
FROM Album AS al
JOIN Artist AS ar ON ar.ArtistId = al.ArtistId
ORDER BY al.AlbumId
LIMIT 3;
```

> **Verification:** Expected `3` rows | First row: `(1, For Those About To Rock We Salute You, AC/DC)`

---

## Part 1: Basics (Tasks 1–5) — Core Practice

### Task 1 · First 10 albums with artist name
Show `AlbumId`, `Title`, and artist `Name` for the first 10 albums sorted by `AlbumId`.

> **Verification:** Expected `10` rows | First row: `(1, For Those About To Rock We Salute You, AC/DC)`

### Task 2 · First 10 tracks with media type
Join `Track` and `MediaType` to show `TrackId`, track `Name`, and media type `Name` for the first 10 tracks by `TrackId`.

> **Verification:** Expected `10` rows | First row: `(1, For Those About To Rock (We Salute You), MPEG audio file)`

### Task 3 · First 10 invoices with customer name
Join `Invoice` and `Customer` to show `InvoiceId`, `FirstName`, `LastName`, and `Total` for the first 10 invoices by `InvoiceId`.

> **Verification:** Expected `10` rows | First row: `(1, Leonie, Köhler, 1.98)`

### Task 4 · First 10 tracks with genre name
Join `Track` and `Genre` to show `TrackId`, track `Name`, and genre `Name` for the first 10 tracks by `TrackId`.

> **Verification:** Expected `10` rows | First row: `(1, For Those About To Rock (We Salute You), Rock)`

### Task 5 · First 8 tracks in Playlist 1 (3-table join)
Join `Playlist`, `PlaylistTrack`, and `Track` to show `TrackId`, track `Name`, and playlist `Name` for the first 8 tracks in `PlaylistId = 1`, ordered by `TrackId`.

<details>
<summary>Hint</summary>
`FROM Playlist p JOIN PlaylistTrack pt ON pt.PlaylistId = p.PlaylistId JOIN Track t ON t.TrackId = pt.TrackId WHERE p.PlaylistId = 1`
</details>

> **Verification:** Expected `8` rows | First row: `(1, For Those About To Rock (We Salute You), Music)`

---

## Part 2: Everyday Practice (Tasks 6–10) — Core Practice

### Task 6 · Artists with no albums (`LEFT JOIN ... IS NULL`)
Find all artists who do not have any album in `Album`. Return `ArtistId` and `Name`, ordered by `ArtistId`.

<details>
<summary>Hint</summary>
Start from `Artist LEFT JOIN Album ON ...` and filter `WHERE al.AlbumId IS NULL`.
</details>

> **Verification:** Expected `71` rows | First row: `(25, Milton Nascimento & Bebeto)`

### Task 7 · Track count for every playlist (keep empty playlists)
Show `PlaylistId`, `Name`, and track count (`COUNT(pt.TrackId)`) for all 18 playlists, including empty ones. Sort largest first, then by `PlaylistId`.

<details>
<summary>Hint</summary>
Use `LEFT JOIN PlaylistTrack` and `COUNT(pt.TrackId)` (not `COUNT(*)`) so empty playlists show `0`.
</details>

> **Verification:** Expected `18` rows | First row: `(1, Music, 3290)`

### Task 8 · Employees and their managers (self-join)
Join `Employee` to itself so each row shows `EmployeeId`, the employee’s `LastName`, and their manager’s `LastName` (keep employees with no manager as `NULL`). Sort by `EmployeeId`.

<details>
<summary>Hint</summary>
`FROM Employee AS e LEFT JOIN Employee AS m ON m.EmployeeId = e.ReportsTo`
</details>

> **Verification:** Expected `8` rows | First row: `(1, Adams, NULL)`

### Task 9 · Tracks per genre
Show each genre’s `Name` and number of tracks (`COUNT(t.TrackId)`), keeping all 25 genres. Sort by count descending, then genre `Name`, then `GenreId`.

<details>
<summary>Hint</summary>
`FROM Genre g LEFT JOIN Track t ON t.GenreId = g.GenreId GROUP BY g.GenreId, g.Name`
</details>

> **Verification:** Expected `25` rows | First row: `(Rock, 1297)`

### Task 10 · Unique country list (`UNION`)
Combine `Country` from `Customer` and `BillingCountry` from `Invoice` into one deduplicated alphabetical list using `UNION`.

<details>
<summary>Hint</summary>
`SELECT Country AS country FROM Customer UNION SELECT BillingCountry FROM Invoice ORDER BY country;`
</details>

> **Verification:** Expected `24` rows | First row: `(Argentina)`

---

## Part 3: Fix the Bug (Tasks 11–12) — Core Practice

### Task 11 · `COUNT(*)` turns empty `LEFT JOIN` rows into `1`
The query below shows `1` instead of `0` for empty playlists. Fix it so empty playlists show `0`, returning `PlaylistId` and `track_count` ordered by `PlaylistId`.

```sql
SELECT p.PlaylistId, COUNT(*) AS track_count
FROM Playlist AS p
LEFT JOIN PlaylistTrack AS pt ON pt.PlaylistId = p.PlaylistId
GROUP BY p.PlaylistId
ORDER BY p.PlaylistId;
```

<details>
<summary>Hint</summary>
Count a column from the right table: `COUNT(pt.TrackId)`.
</details>

> **Verification:** Expected `18` rows | First row: `(1, 3290)`

### Task 12 · `WHERE` filter cancels a `LEFT JOIN`
The query below drops playlists that don’t contain Track 1 because `WHERE pt.TrackId = 1` removes `NULL` rows. Fix it so all 18 playlists remain in the result (`1` if Track 1 is in the playlist, `0` if not).

```sql
SELECT p.PlaylistId, COUNT(pt.TrackId) AS has_track_1
FROM Playlist AS p
LEFT JOIN PlaylistTrack AS pt ON pt.PlaylistId = p.PlaylistId
WHERE pt.TrackId = 1
GROUP BY p.PlaylistId
ORDER BY p.PlaylistId;
```

<details>
<summary>Hint</summary>
Move `AND pt.TrackId = 1` into the `LEFT JOIN ... ON` condition and remove the `WHERE` clause.
</details>

> **Verification:** Expected `18` rows | First row: `(1, 1)`

---

## Part 4: Optional Stretch (Tasks 13–15) — Try If You Finish Early

### Task 13 · Top 5 artists by units sold (4-table join)
Join `Artist`, `Album`, `Track`, and `InvoiceLine` to find the top 5 artists by `SUM(il.Quantity)`. Return `ArtistId`, `Name`, and `units_sold`, sorted descending, then `ArtistId`.

<details>
<summary>Hint</summary>
Chain `Artist → Album → Track → InvoiceLine`, then `GROUP BY ar.ArtistId, ar.Name`.
</details>

> **Verification:** Expected `5` rows | First row: `(90, Iron Maiden, 140)`

### Task 14 · Support rep customer count and revenue
For each `Employee` who supports at least one `Customer`, show `EmployeeId`, `LastName`, `COUNT(DISTINCT c.CustomerId)` as `customer_count`, and `SUM(i.Total)` as `total_revenue`. Sort by `total_revenue` descending, then `EmployeeId`.

<details>
<summary>Hint</summary>
Join `Employee → Customer` (`SupportRepId = EmployeeId`) and `LEFT JOIN Invoice`. Use `COUNT(DISTINCT c.CustomerId)` so multiple invoices per customer don't inflate the customer count!
</details>

> **Verification:** Expected `3` rows | First row: `(3, Peacock, 21, 833.04)`

### Task 15 · First 10 tracks never sold
Use `LEFT JOIN` between `Track` and `InvoiceLine` to find the first 10 tracks (`TrackId`, `Name`) that have never appeared on any invoice line, ordered by `TrackId`.

<details>
<summary>Hint</summary>
`FROM Track t LEFT JOIN InvoiceLine il ON il.TrackId = t.TrackId WHERE il.InvoiceLineId IS NULL`
</details>

> **Verification:** Expected `10` rows | First row: `(7, Let's Get It Up)`

---

## Capstone sprint

**C5:** Add two join queries. Note repeated data or queries your design made hard.

## Submit

Answers in `work.sql`, reflection in `reflection.md`, output in `results/`. Commit and push. See [SUBMISSIONS.md](../../SUBMISSIONS.md).
