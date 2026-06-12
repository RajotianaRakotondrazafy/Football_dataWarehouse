-- #####################################################################
-- Description : Crée la table de faits des statistiques joueur par saison
-- Granularité : Un joueur, une équipe, une saison
-- Dépendances : source.Player_Attributes
-- Stratégie   : Agrégation des évaluations par joueur/équipe/saison
-- #####################################################################

CREATE TABLE IF NOT EXISTS fait_stats_joueur_saison AS
SELECT
    PA.player_api_id AS id_joueur,
    CASE 
        WHEN CAST(strftime(CAST(PA.date AS DATE), '%m') AS INTEGER) BETWEEN 8 AND 12 
            THEN CAST(strftime(CAST(PA.date AS DATE), '%Y') AS INTEGER) || '-' ||  (CAST(strftime(CAST(PA.date AS DATE), '%Y') AS INTEGER) + 1)
            ELSE (CAST(strftime(CAST(PA.date AS DATE), '%Y') AS INTEGER) - 1) || '-' || CAST(strftime(CAST(PA.date AS DATE), '%Y') AS INTEGER)
    END AS saison,
    ROUND(AVG(CAST(PA.overall_rating AS FLOAT)), 1) AS note_moyenne,
    ROUND(AVG(CAST(PA.potential AS FLOAT)), 1) AS potentiel_moyen,
    COUNT(*) AS nb_evaluations

FROM source.Player_Attributes PA
WHERE PA.date IS NOT NULL
GROUP BY 
    PA.player_api_id, 
    PA.player_fifa_api_id, 
    saison;