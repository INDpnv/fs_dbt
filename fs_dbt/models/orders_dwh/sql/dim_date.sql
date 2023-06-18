{{
    config(
        materialized = "table",
        tags = ['dwh', 'date']
    )
}}
with date_dimension as (
    select * from {{ ref('eph_dates') }}
)
select
    {{ dbt_utils.generate_surrogate_key(['d.date_day']) }} as date_key,
    d.*
from date_dimension d