# FESE304 Database Management System

Weekly lessons, beginner-to-medium hands-on practice packs, and capstone sprints for FESE304 at CamTech University, using **MySQL 8.4**, **MongoDB 8.0**, and **Redis 7.4** with verified real-world datasets.

## Get your copy

Create an empty **private** repository on GitHub, then (replace the `<...>` parts):

```bash
git clone https://github.com/sereyvathanatum/dbms-course-materials.git fese304
cd fese304
git remote rename origin upstream
git remote add origin https://github.com/<your-username>/<your-private-repo>.git
git push -u origin main
```

Get new material: commit your work, then `git pull --no-rebase upstream main` and `git push`.

Only edit your files: `work.*`, `reflection.md`, `results/`, `schema.dbml` (Week 7), `app/` (Week 11) and `capstone/`.

## Start

1. [Set up Docker & databases](setup/README.md) · [DBeaver import guide](setup/DBEAVER-IMPORT-GUIDE.md)
2. [Start Week 1](weeks/week-01/README.md)

Every practice week has **15 self-study tasks** designed for low-to-medium DBMS learners:
- **Real sample rows + Worked Example** (`example.*`) so you can run one query first.
- **Core Practice (Tasks 1–12):** Basics (1–5), Everyday Practice (6–10), and Fix the Bug (11–12), with collapsible **Hints** and verified expected outputs.
- **Optional Stretch (Tasks 13–15):** Extra medium-level practice if you finish early.

Run commands from the repository's top folder.

## Weeks

| Week | Topic | Practice Dataset & Engine | Guide |
|---|---|---|---|
| 1 | Welcome and first SQL queries | Cambodia Geography (`w01_cambodia`, MySQL) | [README](weeks/week-01/README.md) · [PDF](weeks/week-01/README.pdf) |
| 2 | Tables, keys and constraints | NASA Meteorite Landings (`w02_meteorites`, MySQL) | [README](weeks/week-02/README.md) · [PDF](weeks/week-02/README.pdf) |
| 3 | Filtering and safe CRUD | Global & ASEAN Aviation (`w03_aviation`, MySQL) | [README](weeks/week-03/README.md) · [PDF](weeks/week-03/README.pdf) |
| 4 | Functions and grouped reports | WFP Cambodia Food Prices (`w04_food_prices`, MySQL) | [README](weeks/week-04/README.md) · [PDF](weeks/week-04/README.pdf) |
| 5 | Joining related tables | Chinook Digital Music Store (`w05_chinook`, MySQL) | [README](weeks/week-05/README.md) · [PDF](weeks/week-05/README.pdf) |
| 6 | Subqueries and CTEs | Olist Brazilian E-Commerce (`w06_olist`, MySQL) | [README](weeks/week-06/README.md) · [PDF](weeks/week-06/README.pdf) |
| 7 | ER modelling and relational mapping | Formula 1 Race Weekends (`w07_f1`, MySQL) | [README](weeks/week-07/README.md) · [PDF](weeks/week-07/README.pdf) |
| 8 | Normalization (1NF, 2NF, 3NF) | MovieLens + Olist Flat Tables (`w08_normalization`, MySQL) | [README](weeks/week-08/README.md) · [PDF](weeks/week-08/README.pdf) |
| 9 | Midterm preparation | Review (Weeks 1–8) | [README](weeks/week-09/README.md) · [PDF](weeks/week-09/README.pdf) |
| 10 | Objects, transactions and security | MySQL Official Sakila (`w10_sakila`, MySQL) | [README](weeks/week-10/README.md) · [PDF](weeks/week-10/README.pdf) |
| 11 | Application queries & window functions | MovieLens Normalized (`w11_movielens`, MySQL) | [README](weeks/week-11/README.md) · [PDF](weeks/week-11/README.pdf) |
| 12 | NoSQL and MongoDB CRUD | Olist Nested Orders (`w12_olist`, MongoDB) | [README](weeks/week-12/README.md) · [PDF](weeks/week-12/README.pdf) |
| 13 | MongoDB aggregation pipelines | Formula 1 Nested Races (`w13_f1`, MongoDB) | [README](weeks/week-13/README.md) · [PDF](weeks/week-13/README.pdf) |
| 14 | Redis caching and leaderboards | F1 & Olist Leaderboards (`fese304:w14:*`, Redis) | [README](weeks/week-14/README.md) · [PDF](weeks/week-14/README.pdf) |
| 15 | Capstone presentation and handover | Team Capstone | [README](weeks/week-15/README.md) · [PDF](weeks/week-15/README.pdf) |

Each practice week includes: `README.md` (guide), `README.pdf` (print), `dataset.*` (real data seed), `example.*` (worked example), `work.*` (your starter file), `reflection.md`, and `results/` (your output).

Also: [course guide](COURSE.md) · [submitting](SUBMISSIONS.md) · [apps](apps/README.md) · [capstone](capstone/README.md) · [references](REFERENCES.md)
