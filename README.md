# FESE304 Database Management System

Weekly lessons, labs and homework for FESE304 at CamTech University, using MySQL, MongoDB and Redis with real Cambodian administrative data.

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

1. [Set up the databases](setup/README.md)
2. [Read about the data](data/README.md)
3. [Start Week 1](weeks/week-01/README.md)

Run commands from the repository's top folder.

## Weeks

| Week | Topic | Guide |
|---|---|---|
| 1 | Welcome and first queries | [README](weeks/week-01/README.md) · [PDF](weeks/week-01/README.pdf) |
| 2 | Tables, keys and constraints | [README](weeks/week-02/README.md) · [PDF](weeks/week-02/README.pdf) |
| 3 | Filtering and safe CRUD | [README](weeks/week-03/README.md) · [PDF](weeks/week-03/README.pdf) |
| 4 | Functions and grouped reports | [README](weeks/week-04/README.md) · [PDF](weeks/week-04/README.pdf) |
| 5 | Joining related tables | [README](weeks/week-05/README.md) · [PDF](weeks/week-05/README.pdf) |
| 6 | Subqueries and CTEs | [README](weeks/week-06/README.md) · [PDF](weeks/week-06/README.pdf) |
| 7 | ER modelling and relational mapping | [README](weeks/week-07/README.md) · [PDF](weeks/week-07/README.pdf) |
| 8 | Normalization | [README](weeks/week-08/README.md) · [PDF](weeks/week-08/README.pdf) |
| 9 | Midterm preparation | [README](weeks/week-09/README.md) · [PDF](weeks/week-09/README.pdf) |
| 10 | Objects, transactions and security | [README](weeks/week-10/README.md) · [PDF](weeks/week-10/README.pdf) |
| 11 | Connecting an application | [README](weeks/week-11/README.md) · [PDF](weeks/week-11/README.pdf) |
| 12 | NoSQL and MongoDB CRUD | [README](weeks/week-12/README.md) · [PDF](weeks/week-12/README.pdf) |
| 13 | MongoDB aggregation and data modelling | [README](weeks/week-13/README.md) · [PDF](weeks/week-13/README.pdf) |
| 14 | Redis caching and choosing a database | [README](weeks/week-14/README.md) · [PDF](weeks/week-14/README.pdf) |
| 15 | Capstone presentation and handover | [README](weeks/week-15/README.md) · [PDF](weeks/week-15/README.pdf) |

Each week: `README.md` (guide), `README.pdf` (print), `work.*` (your answers), `reflection.md`, `results/` (your output). Weeks 1–13 also have `example.*` (worked example).

Also: [course guide](COURSE.md) · [submitting](SUBMISSIONS.md) · [apps](apps/README.md) · [capstone](capstone/README.md) · [references](REFERENCES.md)

Data: [OCHA HDX, Cambodia administrative boundaries](https://data.humdata.org/dataset/cod-ab-khm), CC BY-IGO.
