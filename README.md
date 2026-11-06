# FESE304 Database Management System

Course materials for FESE304 at CamTech University. Each week has a short lesson, a worked example, lab tasks, homework and a capstone sprint. You practise with MySQL, MongoDB and Redis on your own computer, using real data about Cambodia's provinces, districts and communes.

Start with the [course guide](COURSE.md). Your instructor will confirm dates, deadlines and how to submit.

## Get your own copy

Keep your work in your own **private** repository, and do not push to this one.

```bash
git clone https://github.com/sereyvathanatum/dbms-course-materials.git fese304
cd fese304
git remote rename origin upstream
```

Create an empty private repository on GitHub, then connect it and push:

```bash
git remote add origin https://github.com/<your-username>/<your-repo>.git
git push -u origin main
```

When new material is released, commit your own work first, then run:

```bash
git pull --no-rebase upstream main
git push
```

Your files are `work.*`, `reflection.md` and `results/` in each week, Week 7's `schema.dbml`, Week 11's `app/` folder and `capstone/`. Leave the other files as they are, so updates merge without conflicts. If Git reports a conflict, open the file, keep the lines you want, delete the `<<<<<<<`, `=======` and `>>>>>>>` lines, then `git add` the file and `git commit`.

## Getting started

1. Install the tools and start the databases: [setup/README.md](setup/README.md).
2. Read about the data: [data/README.md](data/README.md).
3. Open [Week 1](weeks/week-01/README.md).

Run all commands from the top folder of the repository (the one that contains `compose.yaml`).

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

Each week folder contains:

| File | Purpose |
|---|---|
| `README.md` / `README.pdf` | The weekly guide (the PDF is for offline reading or printing) |
| `example.sql` or `example.js` | The worked example |
| `work.sql`, `work.js` or `work.md` | Your answers |
| `reflection.md` | Your short reflection |
| `results/` | Your saved query output |

Other folders: `setup/` (databases), `data/` (the dataset), `apps/` (Python and Node.js examples) and `capstone/` (team project templates). See also [SUBMISSIONS.md](SUBMISSIONS.md) and [REFERENCES.md](REFERENCES.md).

## Data

The data is the Cambodia administrative boundaries dataset from OCHA's Humanitarian Data Exchange, produced by the Department of Geography of Cambodia, under the CC BY-IGO licence. See [data/README.md](data/README.md) for details and attribution.
