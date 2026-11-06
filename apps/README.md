# Example apps

Two small apps, written in both Python and Node.js. Choose one language.

- `report` lists the districts of one province, using a parameterized query (Week 11).
- `cache` does the same through a Redis cache with a 60-second expiry (Week 14).

Start the databases first ([setup](../setup/README.md)) and run these commands from the top folder of the repository. `KH01` is the code of Banteay Meanchey; run `SELECT province_pcode, province_name FROM cambodia.province ORDER BY province_pcode;` to see the other codes.

## Python

```bash
python3 -m venv .venv
.venv/bin/python -m pip install -r apps/python/requirements.txt
.venv/bin/python apps/python/report.py KH01
.venv/bin/python apps/python/cache.py KH01
.venv/bin/python apps/python/cache.py KH01
```

On Windows PowerShell, use `.venv\Scripts\python.exe` instead of `.venv/bin/python`.

## Node.js

```bash
npm --prefix apps/node ci
node apps/node/report.mjs KH01
node apps/node/cache.mjs KH01
node apps/node/cache.mjs KH01
```

The first `cache` run should print `"cache": "miss"` and the second `"cache": "hit"`.

## Look at the cache

```bash
docker compose exec redis redis-cli GET fese304:districts:KH01
docker compose exec redis redis-cli TTL fese304:districts:KH01
docker compose exec redis redis-cli DEL fese304:districts:KH01
```

If Redis is not running, the cache app still answers by reading from MySQL and prints `"cache": "unavailable"`. If MySQL is not running, the app stops with an error.

## Settings

The apps read these environment variables and use the local defaults if they are not set: `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASSWORD`, `REDIS_HOST` and `REDIS_PORT`. Never write real passwords in your code. A `.env` file is ignored by Git, but these apps do not load it automatically.
