{{ config(materialized='table') }}

-- Staging de países > mantiene una fila por país.
-- Renombra las columnas de origen > sin aplicar lógica de negocio.

with
source as (
    select *
    from {{ source('tpch', 'nation') }}
),
renamed as (
    select
        n_nationkey as nation_key,
        n_name as nation_name,
        n_regionkey as region_key,
        n_comment as comment
    from source
)
select *
from renamed