
{{ config(materialized='table',
    database = 'CRICKET_ANALYTICS',
    schema = 'STAGING') 
}}

SELECT
    p.PLAYER_KEY,
    s.BATTER AS PLAYER_NAME,
    t.TEAM_KEY,
    s.BATTING_TEAM,
    m.MATCH_KEY,
    s.MATCH_ID,
    s.INNINGS_NUMBER,
    s.RUNS_SCORED,
    s.BALLS_FACED,
    s.FOURS,
    s.SIXES,
    s.STRIKE_RATE

FROM {{ ref('int_player_batting_stats') }} s

LEFT JOIN {{ ref('dim_player') }} p
    ON s.BATTER = p.PLAYER_NAME

LEFT JOIN {{ ref('dim_team') }} t
    ON s.BATTING_TEAM = t.TEAM_NAME

LEFT JOIN {{ ref('dim_match') }} m
    ON s.MATCH_ID = m.MATCH_ID

