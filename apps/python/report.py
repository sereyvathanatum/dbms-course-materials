"""List the districts of one province. The province code is passed as a query parameter."""
import json, os, sys
import mysql.connector

def connect():
    return mysql.connector.connect(host=os.getenv('DB_HOST','127.0.0.1'),
        port=int(os.getenv('DB_PORT','3306')), user=os.getenv('DB_USER','practice'),
        password=os.getenv('DB_PASSWORD','practice-local-only'), database='cambodia')

def districts(code):
    connection = connect()
    try:
        cursor = connection.cursor(dictionary=True)
        try:
            cursor.execute('SELECT district_pcode,district_name FROM district WHERE province_pcode=%s ORDER BY district_pcode',(code,))
            return cursor.fetchall()
        finally:
            cursor.close()
    finally:
        connection.close()

if __name__ == '__main__':
    if len(sys.argv) != 2:
        raise SystemExit('Usage: python report.py PROVINCE_PCODE (for example KH01)')
    print(json.dumps(districts(sys.argv[1]),ensure_ascii=False,indent=2))
