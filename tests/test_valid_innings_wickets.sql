
SELECT
    MATCH_ID,
    INNINGS_NUMBER,
    WICKETS
FROM {{ ref('fact_match_innings') }}
WHERE
       WICKETS < 0
    OR WICKETS > 10
