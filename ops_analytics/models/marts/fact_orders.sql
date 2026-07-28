-- Final, stable orders fact table. One row per order item.
-- This is the contract the rest of the project (Power BI, ML notebook) relies on.

select * from {{ ref('int_orders_enriched') }}