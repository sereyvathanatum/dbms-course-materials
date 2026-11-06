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
| MySQL | 3309 | `practice` / `practice-local-only` |
| MongoDB | 27019 | none |
| Redis | 6389 | none |

Host: `127.0.0.1`. Read `cambodia`; write `student_work`. In MySQL, `practice` cannot change `cambodia`. MongoDB has no login, so leave `cambodia` alone yourself. These passwords are for this local setup only.

Check: `SELECT COUNT(*) FROM cambodia.province;` returns 25 (district 197, commune 1633).

## Consoles

```bash
docker compose exec mysql mysql -upractice -ppractice-local-only cambodia
docker compose exec mongo mongosh cambodia
docker compose exec redis redis-cli
```

Ignore MySQL's "password on the command line" warning.

## Run a SQL file

```bash
docker compose exec -T mysql mysql -upractice -ppractice-local-only < weeks/week-01/example.sql
```

PowerShell: `Get-Content weeks/week-01/example.sql | docker compose exec -T mysql mysql -upractice -ppractice-local-only`

Or open the file in DBeaver.

## Run a MongoDB file

```bash
docker compose exec -T mongo mongosh --quiet < weeks/week-12/example.js
```

PowerShell: `Get-Content weeks/week-12/example.js | docker compose exec -T mongo mongosh --quiet`

## DBeaver

New MySQL connection: `127.0.0.1`, port `3309`, `practice` / `practice-local-only`. If you see "Public Key Retrieval is not allowed", set driver property `allowPublicKeyRetrieval=true`.

## Stop

`docker compose down` keeps your work. `docker compose down -v` deletes it and resets the data. Redis data is not kept.

## Problems

- **Port in use:** change the host port in `compose.yaml` (e.g. `127.0.0.1:3310:3306`) and connect to the new port.
- **Not healthy:** `docker compose logs mysql` (or `mongo`, `redis`).
- **Windows:** use `python` or `py` instead of `python3`.
