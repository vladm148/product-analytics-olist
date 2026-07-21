-- Olist Orders Dataset 
-- Data Quality Check

-- 1) Number of rows

select COUNT(*)
from olist_orders_dataset;

-- 2) NULL check

select COUNT(*) as count_rows,
SUM(case when order_id is null then 1 else 0 END) as order_id_nulls,
SUM(case when customer_id is null then 1 else 0 END) as customer_id_nulls,
SUM(case when order_status is null then 1 else 0 END) as order_status_nulls,
SUM(case when order_purchase_timestamp is null then 1 else 0 END) as order_purchase_timestamp_nulls,
SUM(case when order_approved_at is null then 1 else 0 END) as order_approved_at_nulls,
SUM(case when order_delivered_carrier_date is null then 1 else 0 END) as order_delivered_carrier_date_nulls,
SUM(case when order_delivered_customer_date is null then 1 else 0 END) as order_delivered_customer_date_nulls,
SUM(case when order_estimated_delivery_date is null then 1 else 0 END) as order_estimated_delivery_date_nulls
from olist_orders_dataset;

-- 3) Duplicates:

-- a) order_id
 
select order_id, COUNT(*) as count
from olist_orders_dataset
group by order_id 
having COUNT(*) > 1;

-- b) customer_id

select customer_id, COUNT(*) as count
from olist_orders_dataset
group by customer_id 
having COUNT(*) > 1;

-- 4) Min/max

-- a) order_purchase_timestamp

select MAX(order_purchase_timestamp) as maximum, MIN(order_purchase_timestamp) as minimum
from olist_orders_dataset;

-- b) order_approved_at

select MAX(order_approved_at) as maximum, MIN(order_approved_at) as minimum
from olist_orders_dataset;

-- c) order_delivered_carrier_date

select MAX(order_delivered_carrier_date) as maximum, MIN(order_delivered_carrier_date) as minimum
from olist_orders_dataset;

-- d) order_delivered_customer_date

select MAX(order_delivered_customer_date) as maximum, MIN(order_delivered_customer_date) as minimum
from olist_orders_dataset;

-- e) order_estimated_delivery_date

select MAX(order_estimated_delivery_date) as maximum, MIN(order_estimated_delivery_date) as minimum
from olist_orders_dataset;


-- 5) Distribution of:

-- a) order_status

select order_status, COUNT(*) as count_order_status
from olist_orders_dataset
group by order_status
order by count_order_status desc;

-- b) Payment_sequential

select payment_sequential, COUNT(*) as count_sequential
from olist_order_payments_dataset
group by payment_sequential
order by count_sequential desc;

