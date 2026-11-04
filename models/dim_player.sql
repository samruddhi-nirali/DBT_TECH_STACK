
{{ config(materialized='table',
        database = 'CRICKET_ANALYTICS',
        schema = 'STAGING')
}}

WITH players AS (

    SELECT BATTER AS PLAYER_NAME
    FROM {{ ref('stg_deliveries') }}
    WHERE BATTER IS NOT NULL

    UNION

    SELECT BOWLER AS PLAYER_NAME
    FROM {{ ref('stg_deliveries') }}
    WHERE BOWLER IS NOT NULL

    UNION

    SELECT NON_STRIKER AS PLAYER_NAME
    FROM {{ ref('stg_deliveries') }}
    WHERE NON_STRIKER IS NOT NULL

)

SELECT
    row_number()over(order by PLAYER_NAME) as PLAYER_KEY,
    PLAYER_NAME
FROM players
