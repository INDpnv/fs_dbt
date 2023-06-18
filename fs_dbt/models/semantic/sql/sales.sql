{{
  config(
    materialized = "view",
    tags = ['dwh']
   )
}}

with date_dim as (
    select date_key,
    date_day
    from {{ ref('dim_date') }}
)
select
    {{ dbt_utils.star(from=ref('fct_sales'), relation_alias='fs', except=[
        "sales_key", "customer_key", "order_date_key"]) }},
    {{ dbt_utils.star(from=ref('dim_customer'), relation_alias='c', except=["customer_key", "customer_id"]) }},
    date_dim.date_day as order_date
from {{ ref('fct_sales') }} fs
left join {{ ref('dim_customer') }} c on fs.customer_key = c.customer_key
left join date_dim on fs.order_date_key = date_dim.date_key