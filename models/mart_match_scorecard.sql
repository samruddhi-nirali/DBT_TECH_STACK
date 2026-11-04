
{{ config(materialized='table',
    database = 'CRICKET_ANALYTICS',
    schema = 'STAGING') 
}}

SELECT
    MATCH_KEY,
    MATCH_ID,
    INNINGS_NUMBER,
    TEAM_KEY,
    BATTING_TEAM,

    BATTER_RUNS,
    EXTRAS_RUNS,
    TOTAL_RUNS,
    WICKETS,

    DELIVERY_RECORDS,
    OVERS_WITH_DELIVERIES,

    CONCAT(
        TOTAL_RUNS,
        '/',
        WICKETS
    ) AS SCORE

FROM {{ ref('fact_match_innings') }}
