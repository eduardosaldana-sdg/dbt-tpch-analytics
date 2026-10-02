{{ config(materialized='table') }}

-- Staging de relación producto-proveedor > mantiene una fila por combinación producto y proveedor.
-- Renombra las columnas de origen > sin aplicar lógica de negocio.

with
source as (
    select *
    from {{ source('tpch', 'partsupp') }}

),

renamed as (
    select
        ps_partkey as part_key,
        ps_suppkey as supplier_key,
        ps_availqty as available_quantity,
        ps_supplycost as supply_cost,
        ps_comment as comment
    from source
)
select *
from renamed