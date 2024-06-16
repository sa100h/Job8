import psycopg2

HOST = '176.109.105.12'
PORT = 5432
USER = 'postgres'
PWD = 'p0S$gez!1'
DATEBASE = 'Dep_Trans_02'
# DATEBASE = 'Dep_trans_01'

conn = psycopg2.connect(database=DATEBASE,
                        host=HOST,
                        user=USER,
                        password=PWD,
                        port=PORT)

cur = conn.cursor()

if __name__ == '__main__':
    pass