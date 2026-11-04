-- Table materialization: dbt generally rebuilds the model's result when you run it.
-- Incremental materialization: after the initial build, dbt can process only the rows selected by your incremental SQL, 
-- provided the model is configured appropriately.
-- Important: Incremental materialization does not automatically know which rows are new. 
-- We must define the filtering logic and, when needed, a unique key and update strategy.

{{ config(materialized='table') }}
SELECT
    customer_id,
    COUNT(*) AS completed_order_count,
    SUM(order_amount) AS total_completed_amount
FROM {{ref("stg_orders")}}
WHERE order_status = 'COMPLETED'
GROUP BY customer_id
