-- Deep analysis

-- 1) Cancellation analysis

-- a) Cancellation rate (without unavailable)
select 
	ROUND(
		100.0 *  AVG(
			case
				when order_status = 'canceled'
					then 1
				else 0
			end
			)::numeric, 2
	) as cancellation_rate
from olist_orders_dataset;
-- 0,63% of orders were cancelled
-- But also exist type that is called "unavailable"
-- "Cancelled" - it means that order was cancelled by customer or seller
-- "Unavailable" - there was no product at all

-- b) Unavailable Rate
select 
	ROUND(
		100.0 *  AVG(
			case
				when order_status = 'unavailable'
					then 1
				else 0
			end
			)::numeric, 2
	) as cancellation_rate
from olist_orders_dataset;
-- 0,61 % of orders were unavailable

-- c) Order Failure Rate (cancelled + unavailable)
select 
	ROUND(
		100.0 *  AVG(
			case
				when order_status = 'canceled' or order_status = 'unavailable'
					then 1
				else 0
			end
			)::numeric, 2
	) as cancellation_rate
from olist_orders_dataset;

-- d) Distribution of order_status (%)
select order_status, COUNT(*) as status_count,
ROUND(
	COUNT(*) * 100.0 / SUM(COUNT(*)) over(), 2
	) as status_percentage
from olist_orders_dataset
group by order_status
order by status_count desc;

-- e) Share of Cancelled Orders by Сategory
with categ as(
	select product_category_name_english,
		SUM(case when order_status = 'canceled' then 1 else 0 end) as cancelled_categ
	from 
		olist_orders_dataset
		join olist_order_items_dataset using (order_id)
		join olist_products_dataset using (product_id)
		join product_category_name_translation using (product_category_name)
	group by product_category_name_english
)
select
	product_category_name_english,
	ROUND(
		cancelled_categ * 100.0 /
		SUM(cancelled_categ) over(), 
		2)
from categ
order by cancelled_categ desc;

-- f) Cancellation Rate by Category
with categ_orders as (
	select distinct 
		order_id,
		product_category_name_english,
		order_status
	from 
		olist_orders_dataset
		join olist_order_items_dataset using (order_id)
		join olist_products_dataset using (product_id)
		join product_category_name_translation using (product_category_name)
) 
select
	product_category_name_english,
	ROUND(
		(100.0 * 
			SUM(
				case when order_status = 'canceled' then 1 else 0 end
				) / COUNT(*)
			)::numeric, 2) as cancellation_rate
from categ_orders
group by product_category_name_english
order by cancellation_rate desc;

-- g) Cancellation rate by states (customers)
with state_orders as(
	select customer_state,
		order_status
	from
		olist_orders_dataset
		join olist_customers_dataset using (customer_id)
)
select
	customer_state,
	ROUND(
		(100.0 * 
			SUM(
				case when order_status='canceled' then 1 else 0 end
				) / COUNT(*)
		)::numeric, 2
	) as cancellation_rate
from state_orders 
group by customer_state
order by cancellation_rate desc;

-- g) Cancellation rate by states (sellers)
with state_orders as(
	select distinct order_id, 
		seller_state,
		order_status
	from
		olist_orders_dataset
		join olist_order_items_dataset using (order_id)
		join olist_sellers_dataset using (seller_id)
)
select
	seller_state,
	ROUND(
		(100.0 * 
			SUM(
				case when order_status='canceled' then 1 else 0 end
				) / COUNT(*)
		)::numeric, 2
	) as cancellation_rate
from state_orders 
group by seller_state
order by cancellation_rate desc;

-- h) Cancellation rate: 1) seller and customer are located in the same state
-- 2) seller and customer are not located in the same state

with state_orders as (
	select distinct
		order_id, 
		customer_state,
		seller_state,
		order_status
	from
		olist_orders_dataset
		join olist_customers_dataset using (customer_id)
		join olist_order_items_dataset using (order_id)
		join olist_sellers_dataset using (seller_id)
)
select 
	case
		when customer_state = seller_state
			then 'Same State'
		else 'Different States'
	end as order_type,
    COUNT(*) AS total_orders,
    SUM(
        case
            when order_status = 'canceled'
            then 1
            else 0
        end
    ) as cancelled_orders,
	ROUND(
		(
			100.0 * SUM(
				case
					when order_status = 'canceled'
					then 1
					else 0 
				end
				) / COUNT(*)
		)::numeric, 2
	) as cancellation_rate	
from state_orders
group by
	case
		when customer_state = seller_state
			then 'Same State'
		else 'Different States'
	end
order by cancellation_rate desc;
	
-- 'Same State' has more cancelled_orders while having less total_orders. 
-- Maybe SP-> SP is the biggest group of all operations
-- Let's check it:

with state_orders as (
    select distinct
        order_id,
        customer_state,
        seller_state
    from olist_orders_dataset
    join olist_customers_dataset using (customer_id)
    join olist_order_items_dataset using (order_id)
    join olist_sellers_dataset using (seller_id)
)
select
    COUNT(*) as sp_sp_orders,
    ROUND(
        (
            100.0 * COUNT(*) /
            (select COUNT(*) from state_orders)
        )::numeric,
        2
    ) as share_of_all_orders
from state_orders
where customer_state = 'SP' and seller_state = 'SP';

-- about 32% of orders are SP -> SP
-- It is important to check whether cancellation rate is high for SP -> SP

with state_orders as (
	select distinct 
	    order_id,
        customer_state,
        seller_state,
        order_status
    from olist_orders_dataset
    join olist_customers_dataset using (customer_id)
    join olist_order_items_dataset using (order_id)
    join olist_sellers_dataset using (seller_id)
)
select
	customer_state,
	seller_state,
	COUNT(*) as total_orders, 
	SUM(case 
			when order_status = 'canceled'
			then 1
			else 0
	end
	) as cancelled_orders,
	ROUND(
		(100.0 *
		SUM(case 
				when order_status = 'canceled'
				then 1
				else 0
			end
			) / COUNT(*)
		)::numeric, 2
	) as cancellation_rate
from state_orders
where customer_state = 'SP' and seller_state = 'SP'
group by customer_state, seller_state;
-- 208 of 240 'Same state'. So the high level of cancellation rate is connected with SP

-- 2) Customer Analysis

-- a) Distribution of orders per customer
with customers_orders as (
	select
		customer_unique_id,
		COUNT(order_id) as orders_count
	from
		olist_customers_dataset
		join olist_orders_dataset using (customer_id)
	group by customer_unique_id	
)
select
	orders_count,
	COUNT(*) as customer_count,
	ROUND(
		(100.0 * COUNT(*)
		/ SUM(COUNT(*)) over()
		)::numeric, 2
	) as customer_share
from customers_orders
group by orders_count
order by orders_count;
-- very few people buy more one once during this period (2016 - 2018)
-- it may be meaningful to start a retention camapaign
-- Let's check, may be there is no sense to encourage people to buy again

-- b) Average Revenue per Customer
with customers_types as (
	select
		customer_unique_id,
		COUNT(order_id) as orders_count
	from
		olist_customers_dataset
		join olist_orders_dataset using (customer_id)
	group by customer_unique_id	
),
customer_revenue as (
	select
		customer_unique_id,
		SUM(payment_value) as revenue
	from 
		olist_customers_dataset
		join olist_orders_dataset using (customer_id)
		join olist_order_payments_dataset using (order_id)
	group by customer_unique_id
)
select
	case
		when orders_count > 1
			then 'Repeat'
		else 'One-time'
	end as customer_type,
	COUNT(*) as customers_count,
	ROUND(
		AVG(revenue)::numeric,
		2) as avg_rev_per_customer
from 
	customers_types
	join customer_revenue using (customer_unique_id)
group by
	case
		when orders_count > 1
			then 'Repeat'
		else 'One-time'
	end;

-- It can be seen that those who buy twice bring in about 2 times more revenue
-- 161,82 and 314,99

-- May be those who buy more usually tend to buy less expensive products in average
-- c) Average Order Value
with customers_types as (
	select
		customer_unique_id,
		COUNT(distinct order_id) as orders_count,
		SUM(payment_value) as revenue
	from
		olist_customers_dataset
		join olist_orders_dataset using (customer_id)
		join olist_order_payments_dataset using (order_id)
	group by customer_unique_id	
)
select
	case
		when orders_count > 1
			then 'Repeat'
		else 'One-time'
	end as customer_type,
	COUNT(*) as customers_count,
	SUM(orders_count) as total_orders,
	ROUND(
		(SUM(revenue) / SUM(orders_count)
			)::numeric,
			2
		) as average_order_value
from 
	customers_types
group by
	case
		when orders_count > 1
			then 'Repeat'
		else 'One-time'
	end;

-- One-time customers usually spend more money on order but not too much
-- 161,82 vs 148,85
-- One can conclude that retention campaign can make sense

-- d) Category Preferences of One-time and Repeat Customers
with customers_types as (
	select
		customer_unique_id,
		case
		when COUNT(order_id) > 1
			then 'Repeat'
		else 'One-time'
		end as customer_type
	from
		olist_customers_dataset
		join olist_orders_dataset using (customer_id)
	group by customer_unique_id
),
category_orders as (
	select
		customer_type,
		product_category_name_english as category,
		order_id
	from
		olist_customers_dataset
		join olist_orders_dataset using (customer_id)
		join olist_order_items_dataset using (order_id)
		join olist_products_dataset using (product_id)
		join product_category_name_translation using (product_category_name)
		join customers_types using (customer_unique_id)
)
select
	customer_type,
	category,
	COUNT(*) as products_count
from category_orders
group by customer_type, category
order by products_count desc;
-- There some categories that company should encourage to buy more than once:
-- health_beauty (not so expensive and rather big as products_count), toys, pet_shop and others

-- 3) Delivery analysis

-- a) Worst states by delivery
-- Maybe some states have specific problems with delivery and one can concentrate on solving them
select
	customer_state,
	ROUND(
	AVG(
	extract(epoch from (order_delivered_customer_date - order_purchase_timestamp))
	/ 86400), 2
	) as avg_delivery_days
from
	olist_orders_dataset
	join olist_customers_dataset using (customer_id)
where order_delivered_customer_date is not null
group by customer_state
order by avg_delivery_days desc;
-- The best state is SP (a lot of sellers operate there so it is logic that it is the best)
-- The worst is RR (the northernmost and most sparsely populated state)

-- b) Delivery Time by Category
select
	product_category_name_english as category,
	COUNT(DISTINCT order_id) AS total_orders,
	ROUND(
	AVG(
	extract(epoch from (order_delivered_customer_date - order_purchase_timestamp))
	/ 86400), 2
	) as avg_delivery_days
from
	olist_orders_dataset
	join olist_order_items_dataset using (order_id)
	join olist_products_dataset using (product_id)
	join product_category_name_translation using (product_category_name)
where order_delivered_customer_date is not null
group by product_category_name_english
order by avg_delivery_days desc;

-- 4) Product Analysis

-- a) Top Categories by Revenue
select product_category_name_english,
	COUNT(*) as items_sold,
	ROUND((SUM(price))::numeric, 2) as revenue,
	ROUND((AVG(price))::numeric, 2) as avg_price
from
	olist_order_items_dataset
	join olist_products_dataset using (product_id)
	join product_category_name_translation using (product_category_name)
group by product_category_name_english
order by revenue desc;
-- health beauty is the best because of a lot of orders
-- top categories usually have medium prices but a lot of customers buy them












	


