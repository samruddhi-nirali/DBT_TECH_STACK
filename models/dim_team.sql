
{{ config(materialized='table',
        database = 'CRICKET_ANALYTICS',
        schema = 'STAGING')
}}

WITH teams AS (

    SELECT DISTINCT BATTING_TEAM AS TEAM_NAME
    FROM {{ ref('stg_deliveries') }}
    WHERE BATTING_TEAM IS NOT NULL

)

SELECT
    ROW_NUMBER() OVER (ORDER BY TEAM_NAME) AS TEAM_KEY,
    TEAM_NAME
FROM teams
