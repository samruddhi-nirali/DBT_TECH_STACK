
{{ config(materialized='table',
    database = 'CRICKET_ANALYTICS',
    schema = 'STAGING')
}}

SELECT
    m.MATCH_KEY,
    i.MATCH_ID,
    i.INNINGS_NUMBER,
    t.TEAM_KEY,
    i.BATTING_TEAM,
    i.DELIVERY_RECORDS,
    i.BATTER_RUNS,
    i.EXTRAS_RUNS,
    i.TOTAL_RUNS,
    i.WICKETS,
    i.OVERS_WITH_DELIVERIES

FROM {{ ref('int_match_innings_summary') }} i

LEFT JOIN {{ ref('dim_match') }} m
    ON i.MATCH_ID = m.MATCH_ID

LEFT JOIN {{ ref('dim_team') }} t
    ON i.BATTING_TEAM = t.TEAM_NAME
