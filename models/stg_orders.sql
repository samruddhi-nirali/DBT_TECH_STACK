
SELECT
    ORDER_ID,
    CUSTOMER_ID,
    ORDER_AMOUNT,
    ORDER_STATUS,
    updated_at
from 
{{source ('raw_data','RAW_ORDERS')}}  --This is a dbt Jinja function called source().It connects the SQL model to the SRC DEF in sources.yml.
