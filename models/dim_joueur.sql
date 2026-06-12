-- #####################################################################
-- Description : Crée la dimension joueur
-- Granularité : Un joueur (une entrée dans la table source.Joueur)
-- Dépendances : source.Joueur et source.Player_Attributes
-- #####################################################################
CREATE TABLE IF NOT EXISTS dim_joueur AS
SELECT
    P.player_api_id AS id_joueur,
    P.player_name AS nom_joueur,
    P.birthday AS date_naissance,
    CAST(P.height AS FLOAT) AS taille_cm,
    CAST(P.weight AS FLOAT) AS poids_kg,
    PA.overall_rating AS note_globale,
    PA.potential AS potentiel,
    PA.preferred_foot AS pied_fort,
    PA.attacking_work_rate AS style_attaque,
    PA.defensive_work_rate AS style_defense,
    PA.crossing AS centre,
    PA.finishing AS finition,
    PA.heading_accuracy AS tete,
    PA.short_passing AS passe_courte,
    PA.long_passing AS passe_longue,
    PA.dribbling AS dribble,
    PA.ball_control AS controle_balle,
    PA.curve AS effet,
    PA.free_kick_accuracy AS coup_franc,
    PA.volleys AS volee,
    PA.shot_power AS puissance_tir,
    PA.long_shots AS tir_loin,
    PA.penalties AS penalties,
    PA.acceleration AS acceleration,
    PA.sprint_speed AS vitesse,
    PA.agility AS agilite,
    PA.stamina AS endurance,
    PA.strength AS force,
    PA.balance AS equilibre,
    PA.jumping AS detente,
    PA.aggression AS agressivite,
    PA.interceptions AS interceptions,
    PA.positioning AS placement,
    PA.vision AS vision,
    PA.reactions AS reactivite,
    PA.marking AS marquage,
    PA.standing_tackle AS tacle_debout,
    PA.sliding_tackle AS tacle_glisse,
    PA.gk_diving AS plongeon,
    PA.gk_handling AS prise_balle,
    PA.gk_kicking AS degagement,
    PA.gk_positioning AS placement_gardien,
    PA.gk_reflexes AS reflexe_gardien
FROM source.Player P
LEFT JOIN source.Player_Attributes PA ON P.player_api_id = PA.player_api_id
WHERE P.player_api_id IS NOT NULL
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY P.player_api_id 
    ORDER BY PA.date DESC
) = 1;