{{
  config(
    materialized = "incremental",
    unique_key=['sales_key'],
    tags = ['dwh']
   )
}}

select
    {{ dbt_utils.generate_surrogate_key(['o.o_orderkey', 'oi.l_partkey', 'oi.l_suppkey', 'oi.l_linenumber']) }} as sales_key,
    {{ dbt_utils.generate_surrogate_key(['o.o_custkey']) }} as customer_key,
    {{ dbt_utils.generate_surrogate_key(['o.o_orderdate']) }} as order_date_key,
    o.o_orderkey as order_id,
    oi.l_partkey as product_id,
    oi.l_suppkey as supplier_id,
    o.o_custkey as customer_id,
    o.o_orderstatus as order_status,
    o.o_totalprice as order_total_price,
    o.o_orderpriority as order_priority,
    o.o_clerk as order_clerk,
    o.o_shippriority as order_ship_priority,
    oi.l_linenumber as line_item_number,
    oi.l_quantity as line_item_quantity,
    oi.l_extendedprice as line_item_extended_price,
    oi.l_discount as line_item_discount,
    oi.l_tax as line_item_tax,
    oi.l_returnflag as line_item_return_flag,
    oi.l_linestatus as line_item_status,
    oi.l_shipdate as line_item_ship_date,
    oi.l_commitdate as line_item_commit_date,
    oi.l_receiptdate as line_item_receipt_date,
    oi.l_shipinstruct as line_item_ship_instruction,
    oi.l_shipmode as line_item_ship_mode
from {{ source('snowflake_sample_data', 'orders') }} o
inner join {{ source('snowflake_sample_data', 'lineitem') }} oi
on o.o_orderkey = oi.l_orderkey
where 1=1
{% if is_incremental() %}
    and o.o_orderdate > current_date()-3
{% endif %}
