-- Test de negocio > una línea no puede recibirse antes de haber sido enviada.
-- El test falla si la consulta devuelve una o más filas.

select
    order_key,
    line_number,
    ship_date,
    receipt_date
from {{ ref('stg_tpch__lineitem') }}
where receipt_date < ship_date