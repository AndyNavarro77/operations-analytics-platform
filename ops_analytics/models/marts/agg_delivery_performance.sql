-- Pre-aggregated delivery performance by region and shipping mode.
-- Powers the operations dashboard without recomputing over 180K rows each time.

with orders as (

    select * from {{ ref('fact_orders') }}

),

aggregated as (

    select
        order_region,
        shipping_mode,
        count(*)                                          as total_orders,
        sum(case when is_late then 1 else 0 end)           as late_orders,
        round(
            sum(case when is_late then 1 else 0 end) / count(*), 4
        )                                                   as late_rate,
        round(avg(delivery_delay_days), 2)                 as avg_delay_days,
        round(avg(profit_margin_pct), 4)                   as avg_profit_margin_pct,
        round(sum(sales), 2)                                as total_sales

    from orders
    group by order_region, shipping_mode

)

select * from aggregated