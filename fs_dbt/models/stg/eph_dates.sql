{{
    config(
        materialized = "ephemeral"
    )
}}

{{ dbt_date.get_date_dimension('1970-01-01', '2030-12-31') }}