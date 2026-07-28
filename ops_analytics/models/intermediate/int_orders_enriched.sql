-- Adds calculated business metrics on top of clean staging data:
-- delivery performance, profitability, and order value segmentation.

with orders as (

    select * from {{ ref('stg_orders') }}

),

enriched as (

    select
        *,

        -- Delivery performance
        (shipping_days_real - shipping_days_scheduled) as delivery_delay_days,
        case when delivery_status = 'Late delivery' then true else false end as is_late,

        -- Profitability
        case
            when sales > 0 then round(order_profit / sales, 4)
            else null
        end as profit_margin_pct,

        -- Order value segmentation
        case
            when sales < 100 then 'low'
            when sales < 300 then 'medium'
            else 'high'
        end as order_value_segment

    from orders

)

select * from enriched