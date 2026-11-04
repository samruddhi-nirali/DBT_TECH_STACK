
{{ config(materialized='table',
    database = 'CRICKET_ANALYTICS',
    schema = 'STAGING') 
}}

SELECT
    PLAYER_KEY,
    PLAYER_NAME,
    TEAM_KEY,
    BATTING_TEAM,

    SUM(RUNS_SCORED) AS TOTAL_RUNS,

    SUM(FOURS) AS TOTAL_FOURS,
    SUM(SIXES) AS TOTAL_SIXES,

    COUNT(DISTINCT MATCH_KEY) AS MATCHES_PLAYED,

    ROUND(
        SUM(RUNS_SCORED) * 100.0
        / NULLIF(SUM(BALLS_FACED), 0),
        2
    ) AS OVERALL_STRIKE_RATE

FROM {{ ref('fact_player_match') }}

GROUP BY
    PLAYER_KEY,
    PLAYER_NAME,
    TEAM_KEY,
    BATTING_TEAM

ORDER BY TOTAL_RUNS DESC
