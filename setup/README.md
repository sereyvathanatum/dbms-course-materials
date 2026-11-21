# Setup

## Install

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (Linux: Docker Engine + Compose v2)
- [Git](https://git-scm.com/)
- [DBeaver Community](https://dbeaver.io/) (SQL); optional: [MongoDB Compass](https://www.mongodb.com/products/tools/compass), [Redis Insight](https://redis.io/insight/)
- Python 3.10+ or Node.js 20+ (Weeks 11 and 14)

## Start

From the repository's top folder:

```bash
docker compose up -d --wait
```

First start takes a few minutes. Check with `docker compose ps` (all `healthy`).

| Service | Port | Login |
|---|---|---|
| MySQL 8.4 | 3306 | `practice` / `practice-local-only` |
| MongoDB 8.0 *(uncomment in Week 12)* | 27019 | none |
| Redis 7.4 *(uncomment in Week 14)* | 6389 | none |

Host: `127.0.0.1`. Each week has its own real-world `dataset.sql`, `dataset.js`, or `dataset.redis` inside `weeks/week-XX/`. Keep each week's dataset clean and create your own scratch tables in `student_work`.

## Import a Week’s Dataset

- **MySQL (Weeks 1–8, 10–11):** Follow the [DBeaver Import Guide](DBEAVER-IMPORT-GUIDE.md) (`Alt+X` on `weeks/week-XX/dataset.sql`), or run from the terminal:
  ```bash
  docker compose exec -T mysql mysql -upractice -ppractice-local-only < weeks/week-01/dataset.sql
  ```
  PowerShell: `Get-Content weeks/week-01/dataset.sql | docker compose exec -T mysql mysql -upractice -ppractice-local-only`
- **MongoDB (Weeks 12–13):**
  ```bash
  docker compose exec -T mongo mongosh --quiet < weeks/week-12/dataset.js
  ```
- **Redis (Week 14):**
  ```bash
  docker compose exec -T redis redis-cli < weeks/week-14/dataset.redis
  ```

## Consoles

```bash
docker compose exec mysql mysql -upractice -ppractice-local-only
docker compose exec mongo mongosh
docker compose exec redis redis-cli
```

Ignore MySQL's "password on the command line" warning.

## Run a SQL or MongoDB file

```bash
docker compose exec -T mysql mysql -upractice -ppractice-local-only < weeks/week-01/example.sql
docker compose exec -T mongo mongosh --quiet < weeks/week-12/example.js
```

## Stop & Reset

`docker compose down` keeps your databases. `docker compose down -v` wipes volumes and starts completely fresh. Redis data is in-memory and resets on container restart.

## Problems

- **Port in use:** change the host port in `compose.yaml` (e.g. `127.0.0.1:3307:3306`; a MySQL already installed on your computer usually holds 3306) and connect to the new port.
- **Not healthy:** `docker compose logs mysql` (or `mongo`, `redis`).
- **Windows:** use `python` or `py` instead of `python3`.
