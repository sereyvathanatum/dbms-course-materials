# Setup

You need:

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (or Docker Engine with Compose v2 on Linux)
- [Git](https://git-scm.com/)
- [DBeaver Community](https://dbeaver.io/) for SQL (optional but recommended), [MongoDB Compass](https://www.mongodb.com/products/tools/compass) and [Redis Insight](https://redis.io/insight/) (optional)
- Python 3.10+ or Node.js 20+ for Weeks 11 and 14

Run every command from the top folder of the repository (the one that contains `compose.yaml`).

## Start the databases

```bash
docker compose up -d --wait
docker compose ps
```

The first start downloads the images and loads the data, which can take a few minutes. All three services should show as `healthy`.

| Service | Host | Port | Login |
|---|---|---|---|
| MySQL | 127.0.0.1 | 3309 | user `practice`, password `practice-local-only` |
| MongoDB | 127.0.0.1 | 27019 | no login |
| Redis | 127.0.0.1 | 6389 | no login |

In MySQL, `cambodia` holds the course data and is read-only for the `practice` user, and `student_work` is where you create and change your own tables. MongoDB has no login in this local setup: leave `cambodia` unchanged and write to `student_work`, which MongoDB creates when you first insert a document. These passwords are only for this local setup; never use them anywhere else.

To check the data, open a SQL console and count the rows. You should get 25 provinces, 197 districts and 1633 communes:

```sql
SELECT COUNT(*) FROM cambodia.province;
SELECT COUNT(*) FROM cambodia.district;
SELECT COUNT(*) FROM cambodia.commune;
```

## Open a console

```bash
docker compose exec mysql mysql -upractice -ppractice-local-only cambodia
docker compose exec mongo mongosh cambodia
docker compose exec redis redis-cli
```

MySQL warns that using a password on the command line can be insecure. You can ignore this for the local practice database.

## Run a SQL file

macOS, Linux or Git Bash on Windows:

```bash
docker compose exec -T mysql mysql -upractice -ppractice-local-only < weeks/week-01/example.sql
```

Windows PowerShell:

```powershell
Get-Content weeks/week-01/example.sql | docker compose exec -T mysql mysql -upractice -ppractice-local-only
```

You can also open the file in DBeaver and run it there.

## Run a MongoDB file

```bash
docker compose exec -T mongo mongosh --quiet < weeks/week-12/example.js
```

In PowerShell: `Get-Content weeks/week-12/example.js | docker compose exec -T mongo mongosh --quiet`

## Connect with DBeaver

Create a new MySQL connection with host `127.0.0.1`, port `3309`, user `practice` and password `practice-local-only`. If DBeaver shows "Public Key Retrieval is not allowed", open **Driver properties** and set `allowPublicKeyRetrieval` to `true`.

## Stop and restart

```bash
docker compose down        # stop; your MySQL and MongoDB work is kept
docker compose up -d --wait
```

Do not run `docker compose down -v` unless you want to delete all your database work and start again from the original data. Redis data is not kept between restarts.

## Problems

- **Port already in use:** another program is using 3309, 27019 or 6389. In `compose.yaml`, change the host port (for example `127.0.0.1:3309:3306` to `127.0.0.1:3310:3306`) and use the new port when you connect.
- **A service is not healthy:** run `docker compose logs mysql` (or `mongo`, `redis`) and read the last lines.
- **On Windows,** type `python` or `py` where the guides say `python3`.
