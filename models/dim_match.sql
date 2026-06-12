-- #####################################################################
-- Description : Crée la dimension match
-- Granularité : Un match (une entrée dans la table source.Match)
-- Dépendances : source.Match et source.Match_Attributes
-- #####################################################################
CREATE TABLE IF NOT EXISTS dim_match AS
SELECT
    M.id AS id_match,
    M.date AS date_match,
    L.name AS nom_league,
    C.name AS nom_pays,
    M.stage AS Stage,
    M.season AS saison,
    M.home_team_goal AS buts_domicile,
    M.away_team_goal AS buts_exterieur,
    CASE 
        WHEN M.home_team_goal > M.away_team_goal THEN 'Domicile'
        WHEN M.home_team_goal < M.away_team_goal THEN 'Exterieur'
        ELSE 'Nul'
    END AS resultat,
    ABS(CAST(M.home_team_goal AS INTEGER) - CAST(M.away_team_goal AS INTEGER)) AS ecart_buts,
    CAST(M.home_team_goal AS INTEGER) + CAST(M.away_team_goal AS INTEGER) AS total_buts
FROM source.Match M
LEFT JOIN source.League L ON M.league_id = L.id
LEFT JOIN source.Country C ON L.country_id = C.id