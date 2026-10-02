{{ config(materialized='table') }}

-- Dimensión de clientes > prepara los atributos del cliente para consumo analítico.
-- Mantiene el grano de una fila por customer_key.

with
customer_geography as (
    select *
    from {{ ref('int_customer_geography') }}
),
final as (
    select
        customer_key,
        customer_name,
        address,
        phone_number,
        account_balance,
        market_segment,
        nation_name,
        region_name
    from customer_geography
)
select *
from final