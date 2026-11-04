
{{ config(materialized='table',
        database = 'CRICKET_ANALYTICS',
        schema = 'STAGING') 
}}

SELECT
    TEAM_KEY,
    BATTING_TEAM,

    COUNT(DISTINCT MATCH_KEY) AS MATCHES_PLAYED,

    COUNT(*) AS INNINGS_PLAYED,

    SUM(TOTAL_RUNS) AS TOTAL_RUNS,

    ROUND(AVG(TOTAL_RUNS), 2) AS AVG_RUNS_PER_INNINGS,

    MAX(TOTAL_RUNS) AS HIGHEST_INNINGS_SCORE,

    SUM(WICKETS) AS TOTAL_WICKETS_LOST

FROM {{ ref('fact_match_innings') }}

GROUP BY
    TEAM_KEY,
    BATTING_TEAM
