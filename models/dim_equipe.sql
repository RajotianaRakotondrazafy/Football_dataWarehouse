-- #####################################################################
-- Description : Crée la dimension équipe
-- Granularité : Une équipe (une entrée dans la table source.Equipe)
-- Dépendances : source.Equipe et source.Team_Attributes
-- #####################################################################
CREATE TABLE IF NOT EXISTS dim_equipe AS
SELECT
    T.team_api_id AS id_equipe,
    T.team_long_name AS nom_long,
    T.team_short_name AS nom_court,
    TA.buildUpPlaySpeed AS build_up_play_speed,
    TA.buildUpPlayPassing AS build_up_play_passing,
    TA.chanceCreationPassing AS chance_creation_passing,
    TA.chanceCreationCrossing AS chance_creation_crossing,
    TA.chanceCreationShooting AS chance_creation_shooting,
    TA.defencePressure AS defence_pressure,
    TA.defenceAggression AS defence_aggression,
FROM source.Team T
LEFT JOIN source.Team_Attributes TA ON T.team_api_id = TA.team_api_id
WHERE T.team_api_id IS NOT NULL
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY t.team_api_id 
    ORDER BY ta.date DESC
) = 1;