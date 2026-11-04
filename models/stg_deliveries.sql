
{{ config(materialized='view',
    database = 'CRICKET_ANALYTICS',
    schema = 'STAGING') 
}}

WITH source_matches AS (

    SELECT
        MATCH_ID,
        PAYLOAD
    FROM CRICKET_ANALYTICS.RAW.MATCH_JSON

),

innings AS (

    SELECT
        m.MATCH_ID,
        i.INDEX AS INNINGS_INDEX,
        i.VALUE AS INNINGS_DATA
    FROM source_matches m,
         LATERAL FLATTEN(INPUT => m.PAYLOAD:innings) i

),

overs AS (

    SELECT
        MATCH_ID,
        INNINGS_INDEX,
        INNINGS_DATA,
        o.INDEX AS OVER_INDEX,
        o.VALUE AS OVER_DATA
    FROM innings,
         LATERAL FLATTEN(INPUT => INNINGS_DATA:overs) o

),

deliveries AS (

    SELECT
        MATCH_ID,
        INNINGS_INDEX,
        INNINGS_DATA,
        OVER_INDEX,
        OVER_DATA,
        d.INDEX AS DELIVERY_INDEX,
        d.VALUE AS DELIVERY_DATA
    FROM overs,
         LATERAL FLATTEN(INPUT => OVER_DATA:deliveries) d

)

SELECT
    MATCH_ID,

    INNINGS_INDEX + 1 AS INNINGS_NUMBER,
    INNINGS_DATA:team::VARCHAR AS BATTING_TEAM,

    COALESCE(
        TRY_TO_NUMBER(OVER_DATA:over::VARCHAR),
        OVER_INDEX + 1
    ) AS OVER_NUMBER,

    DELIVERY_INDEX + 1 AS BALL_IN_OVER,

    DELIVERY_DATA:batter::VARCHAR AS BATTER,
    DELIVERY_DATA:bowler::VARCHAR AS BOWLER,
    DELIVERY_DATA:non_striker::VARCHAR AS NON_STRIKER,

    DELIVERY_DATA:runs:batter::INTEGER AS BATTER_RUNS,
    DELIVERY_DATA:runs:extras::INTEGER AS EXTRAS_RUNS,
    DELIVERY_DATA:runs:total::INTEGER AS TOTAL_RUNS,

    ARRAY_SIZE(DELIVERY_DATA:wickets) AS WICKET_COUNT,

    DELIVERY_DATA:extras AS EXTRAS_DETAILS,
    DELIVERY_DATA:wickets AS WICKETS_DETAILS

FROM deliveries
