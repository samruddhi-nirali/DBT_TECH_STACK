
{{ config(materialized='table',
        database = 'CRICKET_ANALYTICS',
        schema = 'STAGING') 
}}

WITH matches AS (

    SELECT DISTINCT
        MATCH_ID
    FROM {{ ref('stg_matches') }}
    WHERE MATCH_ID IS NOT NULL

)

SELECT
    ROW_NUMBER() OVER (ORDER BY MATCH_ID) AS MATCH_KEY,
    MATCH_ID

FROM matches
