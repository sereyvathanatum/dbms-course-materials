import mysql from 'mysql2/promise';
import {pathToFileURL} from 'node:url';
export async function districts(code) {
  const connection = await mysql.createConnection({host:process.env.DB_HOST ?? '127.0.0.1',
    port:Number(process.env.DB_PORT ?? 3309),user:process.env.DB_USER ?? 'practice',
    password:process.env.DB_PASSWORD ?? 'practice-local-only',database:'cambodia'});
  try {
    const [rows] = await connection.execute(
      'SELECT district_pcode,district_name FROM district WHERE province_pcode=? ORDER BY district_pcode',[code]);
    return rows;
  } finally { await connection.end(); }
}
if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  if (process.argv.length !== 3) throw new Error('Usage: node report.mjs PROVINCE_PCODE');
  console.log(JSON.stringify(await districts(process.argv[2]),null,2));
}
