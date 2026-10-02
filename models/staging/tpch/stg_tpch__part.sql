{{ config(materialized='table') }}

-- Staging de productos > mantiene una fila por producto.
-- Renombra las columnas de origen > sin aplicar lógica de negocio.

with
source as (
    select *
    from {{ source('tpch', 'part') }}
),
renamed as (
    select
        p_partkey as part_key,
        p_name as part_name,
        p_mfgr as manufacturer,
        p_brand as brand,
        p_type as part_type,
        p_size as part_size,
        p_container as container,
        p_retailprice as retail_price,
        p_comment as comment
    from source
)
select *
from renamed