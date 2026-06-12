from pathlib import Path

ROOT = Path(__file__).parent.parent

# Dossiers
DATA_LAKE = ROOT / "data_lake"
DATA_WAREHOUSE = ROOT / "data_warehouse"
MODELS = ROOT / "models"

# Fichier source de données
SOURCE_DB = DATA_LAKE / "database.sqlite"

# Tables à produire
FACT_TABLES = [
    "fait_match",
    "fait_stats_joueur_saison"
]

DIM_TABLES = [
    "dim_temps",
    "dim_equipe",
    "dim_joueur",
    "dim_match"
]

ALL_TABLES = FACT_TABLES + DIM_TABLES
