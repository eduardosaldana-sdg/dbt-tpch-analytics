{{ config(materialized='view') }}

-- Agregado mensual de ventas > resume las líneas de pedido por mes.
-- Cambia el grano de una línea de pedido a una fila por mes.

with
order_lines as (
    select *
    from {{ ref('fct_order_lines') }}
),
monthly_sales as (
    select
        date_trunc('month', order_date) as order_month,

        count(distinct order_key) as order_count,
        count(*) as line_count,
        count(distinct customer_key) as customer_count,
        sum(quantity) as total_quantity,
        sum(extended_price) as gross_amount,
        sum(discounted_amount) as discounted_amount
    from order_lines
    group by
        date_trunc('month', order_date)
),
final as (
    select *
    from monthly_sales
)
select *
from final
order by order_month asc