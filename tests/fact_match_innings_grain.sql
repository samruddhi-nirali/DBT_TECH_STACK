
SELECT
    MATCH_KEY,
    INNINGS_NUMBER,
    COUNT(*) AS RECORD_COUNT
FROM {{ ref('fact_match_innings') }}
GROUP BY
    MATCH_KEY,
    INNINGS_NUMBER
HAVING COUNT(*) > 1
