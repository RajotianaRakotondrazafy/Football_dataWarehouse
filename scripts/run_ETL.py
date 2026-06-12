import duckdb
from pathlib import Path
import sys
from config import SOURCE_DB, DATA_WAREHOUSE, MODELS, ALL_TABLES
sys.path.insert(0, str(Path(__file__).parent))

def setup():
    DATA_WAREHOUSE.mkdir(parents=True, exist_ok=True)
    conn = duckdb.connect()
    conn.execute("SET sqlite_all_varchar = true")
    conn.execute(f"ATTACH '{SOURCE_DB}' AS source (TYPE SQLITE)")
    return conn

def run_model(conn, model_name):
    sql_path = MODELS / f"{model_name}.sql"
    
    if not sql_path.exists():
        print(f"Fichier introuvable : {sql_path}")
        return 0
    
    with open(sql_path, 'r', encoding='utf-8') as f:
        sql = f.read()
    
    conn.execute(sql)
    row_count = conn.execute(f"SELECT COUNT(*) FROM {model_name}").fetchone()[0]
    print(f"   {model_name} : {row_count} lignes")
    return row_count

def export_table(con, table_name):
    output_path = DATA_WAREHOUSE / f"{table_name}.parquet"
    con.execute(f"COPY {table_name} TO '{output_path}' (FORMAT PARQUET, COMPRESSION 'zstd')")
    size_mb = output_path.stat().st_size / (1024 * 1024)

def run():
    print("=" * 60)
    print("   FOOTBALL DATA WAREHOUSE - PIPELINE ETL")
    print("=" * 60)
    
    print("\n PHASE 1 : INITIALISATION")
    print("-" * 40)
    
    try:
        con = setup()
        print(f"    Connexion DuckDB établie")
        print(f"    Source attachée : {SOURCE_DB}")
    except Exception as e:
        print(f"    Erreur d'initialisation : {e}")
        sys.exit(1)
    
    # ------------------------------------------------
    # PHASE 2 : TRANSFORMATION
    # ------------------------------------------------
    print("\nPHASE 2 : TRANSFORMATION")
    print("-" * 40)
    
    execution_order = [
        ("dim_temps",                   "Dimension TEMPS"),
        ("dim_equipe",                  "Dimension EQUIPE"),
        ("dim_joueur",                  "Dimension JOUEUR"),
        ("dim_match",                   "Dimension MATCH"),
        ("fait_match",                  "Fait MATCH"),
        ("fait_stats_joueur_saison",    "Fait STATS JOUEUR/SAISON"),
    ]
    
    total_rows = 0
    
    for model_name, description in execution_order:
        print(f"  {description}...", end=" ")
        
        try:
            rows = run_model(con, model_name)
            print(f"{rows:,} lignes")
            total_rows += rows
        except Exception as e:
            print(f"Erreur : {e}")
            con.close()
            sys.exit(1)

    print("\nPHASE 3 : EXPORT")
    print("-" * 40)
    
    for table_name in ALL_TABLES:
        try:
            output_path = DATA_WAREHOUSE / f"{table_name}.parquet"
            con.execute(f"COPY {table_name} TO '{output_path}' (FORMAT PARQUET, COMPRESSION 'zstd')")
            size_mb = output_path.stat().st_size / (1024 * 1024)
            print(f"  {table_name}.parquet ({size_mb:.1f} Mo)")
        except Exception as e:
            print(f"    Erreur export {table_name} : {e}")
    
    print("\n" + "=" * 60)
    print("PIPELINE TERMINÉ AVEC SUCCÈS")
    print("=" * 60)
    print(f"   {total_rows:,} lignes créées au total")
    print(f"   Data Warehouse : {DATA_WAREHOUSE}/")
    print(f"   {len(ALL_TABLES)} tables exportées en Parquet")
    
    con.close()


if __name__ == "__main__":
    run()