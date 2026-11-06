import {createClient} from 'redis';
import {districts} from './report.mjs';
if (process.argv.length !== 3) throw new Error('Usage: node cache.mjs PROVINCE_PCODE');
const code=process.argv[2];
const client=createClient({socket:{host:process.env.REDIS_HOST ?? '127.0.0.1',
  port:Number(process.env.REDIS_PORT ?? 6389),connectTimeout:2000,reconnectStrategy:false}});
client.on('error',()=>{}); // a Redis failure is reported as cache: 'unavailable' below
let result;
try {
  await client.connect();
  const key='fese304:districts:'+code;
  const saved=await client.get(key);
  if (saved !== null) result={cache:'hit',rows:JSON.parse(saved)};
  else {
    const rows=await districts(code);
    try { await client.set(key,JSON.stringify(rows),{EX:60}); result={cache:'miss',rows}; }
    catch { result={cache:'write unavailable',rows}; }
  }
} catch { result={cache:'unavailable',rows:await districts(code)}; }
finally { if (client.isOpen) client.destroy(); }
console.log(JSON.stringify(result,null,2));
