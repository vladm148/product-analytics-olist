-- 1)Number of orders
select COUNT(*)
from olist_orders_dataset;
-- 99 441 

-- 2) Gross Merchandise Value (GVM)
select SUM(payment_value) as GVM
from olist_order_payments_dataset;
-- 16 009 004

-- 3) Average Order Value
select AVG(payment_value) as AOV
from olist_order_payments_dataset;
-- 154,1004

-- 4) Average Items per Order
select COUNT(*)::numeric / COUNT(distinct order_id) as AIPO
from olist_order_items_dataset;
-- 1,1417 customers often buy only one product

-- 5) Average Revenue per Customer
select ROUND((SUM(payment_value) / 
COUNT(distinct customer_unique_id))::numeric, 2) as ARPC
from olist_order_payments_dataset
join olist_orders_dataset using (order_id)
join olist_customers_dataset using (customer_id);
-- 166,6

-- 6) Repeat Purchase Rate
with customer_orders as (
	select
		customer_unique_id,
		COUNT(order_id) as repeat_count
	from 
		olist_customers_dataset
		join olist_orders_dataset using (customer_id)
	group by customer_unique_id
)
select
	ROUND( 
		(100.0 * SUM(case when repeat_count > 1 then 1 else 0 end) / COUNT(*))::numeric, 2
	) as repeat_purchase_rate
from customer_orders;
-- 3,12 % of unique customers have placed more than one order during the entire period

-- 7) Average Delivery Time
select ROUND(
	AVG(
		extract (EPOCH from (
			order_delivered_customer_date - order_purchase_timestamp
			)) / 86400
			)::numeric, 2 ) as average_delivert_days		
from olist_orders_dataset
where order_delivered_customer_date is not null;
-- 12,56 days

-- 8) On-Time Delivery Rate
with delivery as (
	select (
		case when order_delivered_customer_date <= order_estimated_delivery_date then 1 else 0 end
		) as on_time
	from olist_orders_dataset
	where order_delivered_customer_date is not null
)
select 
	ROUND(
		(100.0 * SUM(on_time) / COUNT(*))::numeric, 2
		) as odr 
from delivery;
-- 91,89 % of orders were delivered on time

-- 9) Cancellation Rate
SELECT
    order_status,
    COUNT(*)
FROM olist_orders_dataset
GROUP BY order_status
ORDER BY COUNT(*) DESC;

with cancellation as (
	select (
		case when order_status = 'canceled' then 1 else 0 end
		) as cancelled
	from olist_orders_dataset
)
select 
	ROUND(
		(100.0 * SUM(cancelled) / COUNT(*))::numeric, 2
		) as cancellation_rate 
from cancellation;
-- 0,63% of orders were cancelled

-- 10) Revenue by Category
select product_category_name_english, SUM(price) as category_revenue
from 
	olist_order_items_dataset
	join olist_products_dataset opd using (product_id)
	join product_category_name_translation pcnt
	on pcnt.product_category_name = opd.product_category_name
group by product_category_name_english
order by category_revenue desc;

-- 11) Revenue by State
select customer_state, SUM(payment_value) as state_revenue
from
	olist_order_payments_dataset
	join olist_orders_dataset using (order_id)
	join olist_customers_dataset using (customer_id)
group by customer_state
order by state_revenue desc;






