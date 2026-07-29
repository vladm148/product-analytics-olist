-- Aggregated Table
create table supertable as
with payments_aggregated AS (
    select
        order_id,
        SUM(payment_value) AS total_payment_value,
        MAX(payment_installments) AS max_payment_installments,
        STRING_AGG(
            distinct payment_type,
            ', '
        ) as payment_types
    from olist_order_payments_dataset
    group by order_id
)
select
    oi.order_id,
    oi.order_item_id,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_approved_at,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,
    c.customer_unique_id,
    c.customer_city,
    c.customer_state,
    s.seller_id,
    s.seller_city,
    s.seller_state,
    oi.product_id,
    p.product_category_name,
    pct.product_category_name_english,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm,
    p.product_photos_qty,
    oi.price,
    oi.freight_value,
    pa.total_payment_value,
    pa.max_payment_installments,
    pa.payment_types,
    ROUND(
        (
            extract(
                epoch from
                (
                    o.order_delivered_customer_date - o.order_purchase_timestamp
                )
            ) / 86400
        )::numeric,
        2
    ) as delivery_days,
    case
        when o.order_delivered_customer_date 
             <= o.order_estimated_delivery_date
        then 1
        else 0
    end as is_on_time,
    DATE_TRUNC(
        'month',
        o.order_purchase_timestamp
    ) as purchase_month,
    extract(
        year from o.order_purchase_timestamp
    ) as purchase_year,
    extract(
        month from o.order_purchase_timestamp
    ) as purchase_month_number,
    extract(
        DOW from o.order_purchase_timestamp
    ) as purchase_weekday,
    extract(
        hour from o.order_purchase_timestamp
    ) AS purchase_hour,
    case
        when c.customer_state = s.seller_state
        then 1
        else 0
    end as same_state_order
from olist_order_items_dataset oi
left join olist_orders_dataset o
    using(order_id)
left join olist_customers_dataset c
    using(customer_id)
left join olist_products_dataset p
    using(product_id)
left join product_category_name_translation pct
    using(product_category_name)
left join olist_sellers_dataset s
    using(seller_id)
left join payments_aggregated pa
    using(order_id);

-- Checks
select COUNT(*)
from supertable;
-- Correct, 112 650 rows

select 
    COUNT(*) as rows,
    COUNT(distinct (order_id, order_item_id)) as unique_items
from supertable;
-- Correct

select SUM(price)
from supertable;
-- Correct

-- SHOULD NOT USE total_payment_value AS SUM!!!

