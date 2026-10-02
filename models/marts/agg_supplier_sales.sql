{{ config(materialized='view') }}

-- Agregado de ventas por proveedor > combina la fact con la dimensión de proveedores.
-- Cambia el grano de una línea de pedido a una fila por proveedor.

with
order_lines as (
    select *
    from {{ ref('fct_order_lines') }}
),
suppliers as (
    select *
    from {{ ref('dim_supplier') }}
),
supplier_sales as (
    select
        s.supplier_key,
        s.supplier_name,
        s.nation_name,
        s.region_name,
        count(distinct f.order_key) as order_count,
        count(*) as line_count,
        sum(f.quantity) as total_quantity,
        sum(f.extended_price) as gross_amount,
        sum(f.discounted_amount) as discounted_amount
    from order_lines as f
    inner join suppliers as s
        on f.supplier_key = s.supplier_key
    group by
        s.supplier_key,
        s.supplier_name,
        s.nation_name,
        s.region_name
),
final as (
    select *
    from supplier_sales
)
select *
from final