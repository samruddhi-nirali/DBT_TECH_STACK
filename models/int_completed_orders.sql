-- In dbt, dbt run and dbt build are similar, but dbt build does more than dbt run.
-- 1. dbt run vs dbt build
-- Feature	dbt run	dbt build
-- Executes models	Yes	Yes
-- Runs data tests	No	Yes
-- Loads seeds	No	Yes
-- Runs snapshots	No	Yes
-- Checks model dependencies	Yes	Yes
-- Best used for	Building or updating models	Building models and validating them together

{{
    config(
        materialized='incremental',
        unique_key='order_id'
    )
}}

{% if is_incremental() %}

WITH cutoff AS (
    SELECT
        DATEADD(
            MINUTE,
            -5,
            COALESCE(
                MAX(updated_at),
                '1900-01-01'::TIMESTAMP_NTZ
            )
        ) AS cutoff_time
    FROM {{ this }}
)

SELECT
    s.order_id,
    s.customer_id,
    s.order_amount,
    s.order_status,
    s.updated_at

FROM {{ ref('stg_orders') }} AS s

CROSS JOIN cutoff AS c

WHERE s.order_status = 'COMPLETED'
  AND s.updated_at >= c.cutoff_time

{% else %}

SELECT
    order_id,
    customer_id,
    order_amount,
    order_status,
    updated_at

FROM {{ ref('stg_orders') }}

WHERE order_status = 'COMPLETED'

{% endif %}

    -- the below code won't handle the records if the previous id's status got updated
    -- hence changing the incremental logic
    -- {% if is_incremental() %}
    -- AND order_id > (
    -- SELECT COALESCE(MAX(order_id), 0)
    -- FROM {{ this }}
    -- )
    -- {% endif %}
    -- You've now seen the incremental workflow:
    -- 1. Insert a new record into the source.
    -- 2. Run the dbt model again.
    -- 3. dbt selects the qualifying new record instead of selecting all previously
    -- processed records.
    -- 4. The target retains its existing records and adds the new one.



    
