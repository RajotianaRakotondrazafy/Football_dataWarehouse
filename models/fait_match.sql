-- #####################################################################
-- Description : Crée la table de faits des matchs
-- Granularité : Un match
-- Dépendances : source.Match
-- #####################################################################

CREATE TABLE IF NOT EXISTS fait_match AS
SELECT
    M.id AS id_match,
    CAST(strftime(CAST(M.date AS DATE), '%Y%m%d') AS INTEGER) AS id_temps,
    M.home_team_api_id AS id_equipe_domicile,
    M.away_team_api_id AS id_equipe_exterieur,
    M.home_team_goal AS buts_domicile,
    M.away_team_goal AS buts_exterieur,
    CAST(M.home_team_goal AS INTEGER) + CAST(M.away_team_goal AS INTEGER) AS total_buts

FROM source.Match M
WHERE M.date IS NOT NULL;