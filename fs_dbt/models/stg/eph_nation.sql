{{
  config(
    materialized = "ephemeral"
   )
}}

select n.n_nationkey,
n.n_name as nation_name,
r.r_name as region_name
from {{ source('snowflake_sample_data', 'nation') }} n
left join {{ source('snowflake_sample_data', 'region') }} r on n.n_regionkey = r.r_regionkey