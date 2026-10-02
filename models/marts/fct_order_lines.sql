{{ config(materialized='table') }}

-- Fact de líneas de pedido > prepara las métricas y claves para consumo analítico.
-- Mantiene el grano de una fila por order_key + line_number.

with
order_lines as (
    select *
    from {{ ref('int_order_lines') }}
),
final as (
    select
        -- Identificadores granularidad
        order_key,
        line_number,
        -- Claves para relacionar con las dimensionales
        customer_key,
        part_key,
        supplier_key,
        -- Atributos del pedido
        order_date,
        order_status,
        order_priority,
        -- Métricas de la línea
        quantity,
        extended_price,
        discount,
        discounted_amount,
        tax,
        -- Estado y logística de la línea
        return_flag,
        line_status,
        ship_date,
        commit_date,
        receipt_date,
        ship_instruction,
        ship_mode
    from order_lines
)
select *
from final