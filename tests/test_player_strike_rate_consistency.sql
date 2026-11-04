
SELECT
    MATCH_ID,
    INNINGS_NUMBER,
    PLAYER_NAME,
    RUNS_SCORED,
    BALLS_FACED,
    STRIKE_RATE,
    ROUND(
        100.0 * RUNS_SCORED /
        NULLIF(BALLS_FACED, 0),
        2
    ) AS EXPECTED_STRIKE_RATE
FROM {{ ref('fact_player_match') }}
WHERE
    BALLS_FACED > 0
    AND STRIKE_RATE <>
        ROUND(
            100.0 * RUNS_SCORED /
            NULLIF(BALLS_FACED, 0),
            2
        )
