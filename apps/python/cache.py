"""Cache-aside: read districts from Redis, or from MySQL on a cache miss."""
import json, os, sys
import redis
from report import districts

def cached_districts(code):
    client = redis.Redis(host=os.getenv('REDIS_HOST','127.0.0.1'),
                         port=int(os.getenv('REDIS_PORT','6389')),decode_responses=True,
                         socket_connect_timeout=2,socket_timeout=2)
    key = 'fese304:districts:' + code
    try:
        try:
            saved = client.get(key)
            if saved is not None:
                return {'cache':'hit','rows':json.loads(saved)}
        except redis.RedisError:
            return {'cache':'unavailable','rows':districts(code)}
        rows = districts(code)
        try:
            client.set(key,json.dumps(rows,ensure_ascii=False),ex=60)
        except redis.RedisError:
            return {'cache':'write unavailable','rows':rows}
        return {'cache':'miss','rows':rows}
    finally:
        client.close()

if __name__ == '__main__':
    if len(sys.argv) != 2:
        raise SystemExit('Usage: python cache.py PROVINCE_PCODE')
    print(json.dumps(cached_districts(sys.argv[1]),ensure_ascii=False,indent=2))
