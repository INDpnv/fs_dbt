{{
  config(
    materialized = "table",
    tags = ['dwh']
   )
}}

select
{{ dbt_utils.generate_surrogate_key(['c.c_custkey']) }} as customer_key,
c.c_custkey as customer_id,
c.c_name as customer_name,
c.c_address as customer_address,
c.c_phone as customer_phone,
c.c_acctbal as customer_account_balance,
c.c_mktsegment as customer_market_segment,
n.nation_name as customer_nation_name,
n.region_name as customer_region_name
from {{ source('snowflake_sample_data', 'customer') }} c
left join {{ ref('eph_nation') }} n on c.c_nationkey = n.n_nationkey