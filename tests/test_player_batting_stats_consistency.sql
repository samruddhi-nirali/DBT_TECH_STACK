SELECT
    MATCH_ID,
    INNINGS_NUMBER,
    PLAYER_NAME,
    RUNS_SCORED,
    FOURS,
    SIXES
FROM {{ ref('fact_player_match') }}
WHERE
       RUNS_SCORED < 0
    OR FOURS < 0
    OR SIXES < 0
    OR (FOURS * 4 + SIXES * 6) > RUNS_SCORED
