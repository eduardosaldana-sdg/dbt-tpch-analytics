{{ config(materialized='table') }}

-- Dimensión de productos > prepara los atributos del producto para consumo analítico.
-- Mantiene el grano de una fila por part_key.

with
part as (
    select *
    from {{ ref('stg_tpch__part') }}
),
final as (
    select
        part_key,
        part_name,
        manufacturer,
        brand,
        part_type,
        part_size,
        container,
        retail_price
    from part
)
select *
from final