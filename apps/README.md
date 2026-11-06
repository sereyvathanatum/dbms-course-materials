# Example apps

Python and Node.js versions. Pick one.

- `report`: districts of one province, with a parameterized query (Week 11).
- `cache`: the same through Redis, 60-second TTL (Week 14).

Start the databases first. Run from the repository's top folder. `KH01` = Banteay Meanchey.

## Python

```bash
python3 -m venv .venv
.venv/bin/python -m pip install -r apps/python/requirements.txt
.venv/bin/python apps/python/report.py KH01
.venv/bin/python apps/python/cache.py KH01
```

Windows: `.venv\Scripts\python.exe` instead of `.venv/bin/python`.

## Node.js

```bash
npm --prefix apps/node ci
node apps/node/report.mjs KH01
node apps/node/cache.mjs KH01
```

Run `cache` twice: first `"cache": "miss"`, then `"cache": "hit"`.

## Redis

```bash
docker compose exec redis redis-cli GET fese304:districts:KH01
docker compose exec redis redis-cli TTL fese304:districts:KH01
docker compose exec redis redis-cli DEL fese304:districts:KH01
```

Redis down: the app reads MySQL and prints `"cache": "unavailable"`. MySQL down: the app stops with an error.

## Settings

Environment variables (local defaults if unset): `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASSWORD`, `REDIS_HOST`, `REDIS_PORT`. Don't put real passwords in code.
