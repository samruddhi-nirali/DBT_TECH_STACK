SELECT
    MATCH_KEY,
    MATCH_ID,
    INNINGS_NUMBER,
    BATTER_RUNS,
    EXTRAS_RUNS,
    TOTAL_RUNS
FROM {{ ref('fact_match_innings') }}
WHERE TOTAL_RUNS <> (
    COALESCE(BATTER_RUNS, 0)
    + COALESCE(EXTRAS_RUNS, 0)
)
