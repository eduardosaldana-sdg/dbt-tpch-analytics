{{ config(materialized='view') }}

-- Intermediate de geografía de clientes > enriquece cada cliente con su país y región.
-- Mantiene el grano de una fila por customer_key.

with
customer as (
    select *
    from {{ ref('stg_tpch__customer') }}

),
nation as (

    select *
    from {{ ref('stg_tpch__nation') }}
),

region as (
    select *
    from {{ ref('stg_tpch__region') }}
),
joined as (
    select
        c.customer_key,
        c.customer_name,
        c.address,
        c.phone_number,
        c.account_balance,
        c.market_segment,
        c.nation_key,
        n.nation_name,
        n.region_key,
        r.region_name
    from customer as c
    left join nation as n
        on c.nation_key = n.nation_key
    left join region as r
        on n.region_key = r.region_key
)
select *
from joined