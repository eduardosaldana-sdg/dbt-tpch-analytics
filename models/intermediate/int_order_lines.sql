{{ config(materialized='view') }}

-- Intermediate de líneas de pedido > enriquece cada línea con datos de su pedido.
-- Mantiene el grano de una fila por order_key + line_number.

with
lineitem as (
    select *
    from {{ ref('stg_tpch__lineitem') }}
),
orders as (
    select *
    from {{ ref('stg_tpch__orders') }}
),
joined as (
    select
        l.order_key,
        l.line_number,
        l.part_key,
        l.supplier_key,
        o.customer_key,
        o.order_date,
        o.order_status,
        o.order_priority,
        l.quantity,
        l.extended_price,
        l.discount,
        l.tax,
        -- Macro dbt > genera el cálculo del importe después del descuento.
        {{ calculate_discounted_amount('l.extended_price', 'l.discount') }} as discounted_amount,
        l.return_flag,
        l.line_status,
        l.ship_date,
        l.commit_date,
        l.receipt_date,
        l.ship_instruction,
        l.ship_mode
    from lineitem as l
    left join orders as o
        on l.order_key = o.order_key
)
select *
from joined