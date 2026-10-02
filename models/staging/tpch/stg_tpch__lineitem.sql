-- Staging incremental de líneas de pedido > mantiene una fila por línea de pedido.
-- TPC-H no dispone de timestamp de ingestión/actualización > ship_date se usa como watermark demostrativo.
-- En producción sería preferible utilizar updated_at, ingestion_timestamp o CDC.

{{
    config(
        materialized='incremental',
        unique_key=['order_key', 'line_number'],
        incremental_strategy='merge'
    )
}}

with
source as (
    select *
    from {{ source('tpch', 'lineitem') }}
    -- En ejecuciones incrementales > relee una ventana de 3 días para contemplar llegadas tardías.
    {% if is_incremental() %}
    where l_shipdate >= (
        select dateadd(day, -3, max(ship_date))
        from {{ this }}
    )
    {% endif %}
),
renamed as (
    select
        l_orderkey as order_key,
        l_partkey as part_key,
        l_suppkey as supplier_key,
        l_linenumber as line_number,
        l_quantity as quantity,
        l_extendedprice as extended_price,
        l_discount as discount,
        l_tax as tax,
        l_returnflag as return_flag,
        l_linestatus as line_status,
        l_shipdate as ship_date,
        l_commitdate as commit_date,
        l_receiptdate as receipt_date,
        l_shipinstruct as ship_instruction,
        l_shipmode as ship_mode,
        l_comment as comment
    from source
)
select *
from renamed