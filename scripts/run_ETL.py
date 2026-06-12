import duckdb
from config import SOURCE_DB, DATA_WAREHOUSE, MODELS, ALL_TABLES

def setup():
    DATA_WAREHOUSE.mkdir(parents=True, exist_ok=True)
    conn = duckdb.connect()
    conn.execute(f"ATTACH '{SOURCE_DB}' AS source")
    return conn
