-- Macro reutilizable > calcula el importe de una línea después de aplicar el descuento.
-- Recibe expresiones SQL como parámetros > dbt las sustituye durante la compilación.

{% macro calculate_discounted_amount(extended_price, discount) %}

    ({{ extended_price }} * (1 - {{ discount }}))

{% endmacro %}