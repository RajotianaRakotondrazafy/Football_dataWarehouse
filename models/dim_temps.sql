-- #####################################################################
-- Description : Crée la dimension temps à partir des dates de match
-- Granularité : Un jour (une date de match)
-- Dépendances : source.Match
-- #####################################################################
CREATE TABLE IF NOT EXISTS dim_temps AS
SELECT DISTINCT
    CAST(strftime(CAST(date AS DATE), '%Y%m%d') AS INTEGER) AS id_temps,
    date,
    strftime(CAST(date AS DATE), '%A') AS jour_semaine,
    CAST(strftime(CAST(date AS DATE), '%d') AS INTEGER) AS jour_mois,
    CAST(strftime(CAST(date AS DATE), '%m') AS INTEGER) AS mois,
    CAST(strftime(CAST(date AS DATE), '%Y') AS INTEGER) AS annee,
    CASE 
         WHEN CAST(strftime(CAST(date AS DATE), '%m') AS INTEGER) BETWEEN 8 AND 12 
            THEN CAST(strftime(CAST(date AS DATE), '%Y') AS INTEGER) || '-' || (CAST(strftime(CAST(date AS DATE), '%Y') AS INTEGER) + 1)
        ELSE (CAST(strftime(CAST(date AS DATE), '%Y') AS INTEGER) - 1) || '-' || CAST(strftime(CAST(date AS DATE), '%Y') AS INTEGER)
    END AS saison
FROM source.Match
WHERE date IS NOT NULL;