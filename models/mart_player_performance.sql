
{{ config(materialized='table',
    database = 'CRICKET_ANALYTICS',
    schema = 'STAGING') 
 }}

SELECT
    PLAYER_KEY,
    PLAYER_NAME,

    COUNT(DISTINCT MATCH_KEY) AS MATCHES_PLAYED,

    COUNT(*) AS INNINGS_PLAYED,

    SUM(RUNS_SCORED) AS TOTAL_RUNS,

    MAX(RUNS_SCORED) AS HIGHEST_INNINGS_SCORE,

    SUM(FOURS) AS TOTAL_FOURS,

    SUM(SIXES) AS TOTAL_SIXES,

    ROUND(
        SUM(RUNS_SCORED) * 100.0
        / NULLIF(SUM(BALLS_FACED), 0),
        2
    ) AS OVERALL_STRIKE_RATE

FROM {{ ref('fact_player_match') }}

GROUP BY
    PLAYER_KEY,
    PLAYER_NAME
