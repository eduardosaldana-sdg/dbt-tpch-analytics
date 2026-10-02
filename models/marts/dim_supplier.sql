{{ config(materialized='table') }}

-- Dimensión de proveedores > enriquece cada proveedor con su país y región.
-- Mantiene el grano de una fila por supplier_key.

with
supplier as (
    select *
    from {{ ref('stg_tpch__supplier') }}
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
        s.supplier_key,
        s.supplier_name,
        s.address,
        s.phone_number,
        s.account_balance,
        n.nation_name,
        r.region_name
    from supplier as s
    left join nation as n
        on s.nation_key = n.nation_key
    left join region as r
        on n.region_key = r.region_key
),

final as (
    select *
    from joined
)
select *
from final