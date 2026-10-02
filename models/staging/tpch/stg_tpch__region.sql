{{ config(materialized='table') }}

-- Staging de regiones > mantiene una fila por región.
-- Renombra las columnas de origen > sin aplicar lógica de negocio.

with
source as (
    select *
    from {{ source('tpch', 'region') }}

),
renamed as (
    select
        r_regionkey as region_key,
        r_name as region_name,
        r_comment as comment
    from source
)
select *
from renamed