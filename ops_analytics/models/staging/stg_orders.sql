with source as (

    select * from {{ source('raw', 'orders_raw') }}

),

renamed as (

    select
        -- identificadores
        `Order Id`                                                     as order_id,
        `Order Item Id`                                                as order_item_id,
        `Order Customer Id`                                            as customer_id,
        `Order Item Cardprod Id`                                       as order_item_cardprod_id,
        `Product Card Id`                                              as product_id,
        `Category Id`                                                  as category_id,
        `Department Id`                                                as department_id,

        -- fechas
        to_date(to_timestamp(`order date (DateOrders)`, 'M/d/yyyy H:mm'))    as order_date,
        to_date(to_timestamp(`shipping date (DateOrders)`, 'M/d/yyyy H:mm')) as shipping_date,

        -- envío y riesgo de entrega
        `Days for shipping (real)`                                     as shipping_days_real,
        `Days for shipment (scheduled)`                                as shipping_days_scheduled,
        `Shipping Mode`                                                as shipping_mode,
        `Delivery Status`                                              as delivery_status,
        `Late_delivery_risk`                                           as late_delivery_risk,

        -- cliente (sin PII)
        `Customer Segment`                                             as customer_segment,
        `Customer City`                                                as customer_city,
        `Customer State`                                               as customer_state,
        `Customer Country`                                             as customer_country,
        `Customer Zipcode`                                             as customer_zipcode,
        Latitude                                                       as latitude,
        Longitude                                                      as longitude,

        -- geografía del pedido
        Market                                                         as market,
        `Order Region`                                                 as order_region,
        `Order City`                                                   as order_city,
        `Order State`                                                  as order_state,
        `Order Country`                                                as order_country,

        -- producto
        `Category Name`                                                as category_name,
        `Department Name`                                              as department_name,
        `Product Name`                                                 as product_name,
        `Product Price`                                                as product_price,
        `Product Status`                                               as product_status,

        -- financiero
        `Order Item Quantity`                                          as item_quantity,
        `Order Item Product Price`                                     as item_product_price,
        `Order Item Discount`                                          as item_discount,
        `Order Item Discount Rate`                                     as item_discount_rate,
        `Order Item Total`                                             as item_total,
        `Order Item Profit Ratio`                                      as item_profit_ratio,
        `Order Profit Per Order`                                       as order_profit,
        `Benefit per order`                                            as benefit_per_order,
        Sales                                                          as sales,
        `Sales per customer`                                           as sales_per_customer,

        -- estado del pedido
        `Order Status`                                                 as order_status,
        Type                                                           as payment_type

    from source

)

select * from renamed