# dbt TPC-H Analytics

Proyecto de Data Engineering desarrollado con dbt y Snowflake utilizando el dataset TPC-H.
Implementa una arquitectura por capas: staging, intermediate y marts.
Incluye modelos full load e incremental, distintas materializaciones y una macro reutilizable.
La capa de marts contiene dimensiones, una tabla de hechos y modelos agregados para consumo analítico.
El proyecto incluye tests de calidad y de negocio, documentación y lineage generado por dbt.
