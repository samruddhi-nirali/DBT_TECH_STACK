
{{ config(materialized='table',
        database = 'CRICKET_ANALYTICS',
        schema = 'STAGING') }}

WITH innings AS (

    SELECT
        MATCH_KEY,
        MATCH_ID,

        MAX(
            CASE
                WHEN INNINGS_NUMBER = 1
                THEN BATTING_TEAM
            END
        ) AS FIRST_INNINGS_TEAM,

        MAX(
            CASE
                WHEN INNINGS_NUMBER = 1
                THEN TOTAL_RUNS
            END
        ) AS FIRST_INNINGS_RUNS,

        MAX(
            CASE
                WHEN INNINGS_NUMBER = 2
                THEN BATTING_TEAM
            END
        ) AS SECOND_INNINGS_TEAM,

        MAX(
            CASE
                WHEN INNINGS_NUMBER = 2
                THEN TOTAL_RUNS
            END
        ) AS SECOND_INNINGS_RUNS

    FROM {{ ref('fact_match_innings') }}

    GROUP BY
        MATCH_KEY,
        MATCH_ID
)

SELECT
    MATCH_KEY,
    MATCH_ID,

    FIRST_INNINGS_TEAM,
    FIRST_INNINGS_RUNS,

    SECOND_INNINGS_TEAM,
    SECOND_INNINGS_RUNS,

    FIRST_INNINGS_RUNS - SECOND_INNINGS_RUNS
        AS RUN_DIFFERENCE,

    CASE
        WHEN SECOND_INNINGS_RUNS IS NULL
            THEN 'INCOMPLETE'
        WHEN SECOND_INNINGS_RUNS > FIRST_INNINGS_RUNS
            THEN 'SECOND INNINGS HIGHER'
        WHEN SECOND_INNINGS_RUNS < FIRST_INNINGS_RUNS
            THEN 'FIRST INNINGS HIGHER'
        ELSE 'EQUAL SCORES'
    END AS INNINGS_COMPARISON

FROM innings
