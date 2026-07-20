-- Olist Order_Items Dataset 
-- Data Quality Check

-- 1) Number of rows

select COUNT(*)
from olist_order_items_dataset;

-- 2) NULL check

select COUNT(*) as count_rows,
SUM(case when order_id is null then 1 else 0 END) as order_id_nulls,
SUM(case when order_item_id is null then 1 else 0 END) as order_item_id_nulls,
SUM(case when product_id is null then 1 else 0 END) as product_id_nulls,
SUM(case when seller_id is null then 1 else 0 END) as seller_id_nulls,
SUM(case when shipping_limit_date is null then 1 else 0 END) as shipping_limit_date_nulls,
SUM(case when price is null then 1 else 0 END) as price_nulls,
SUM(case when freight_value is null then 1 else 0 END) as freight_value_nulls
from olist_order_items_dataset;

-- 3) Duplicates:

-- a) order_id
 
select order_id, COUNT(*) as count
from olist_order_items_dataset
group by order_id 
having COUNT(*) > 1;

-- b) order_item_id

select order_item_id, COUNT(*) as count
from olist_order_items_dataset
group by order_item_id 
having COUNT(*) > 1;

-- c) product_id

select product_id, COUNT(*) as count
from olist_order_items_dataset
group by product_id 
having COUNT(*) > 1;

-- d) seller_id

select seller_id, COUNT(*) as count
from olist_order_items_dataset
group by seller_id 
having COUNT(*) > 1;

-- 4) Min/max

-- a) Price

select MAX(price) as maximum, MIN(price) as minimum
from olist_order_items_dataset;

-- b) Freight_value

select MAX(freight_value) as maximum, MIN(freight_value) as minimum
from olist_order_items_dataset;

-- c) Shipping_limit_date
select MAX(Shipping_limit_date) as maximum, MIN(Shipping_limit_date) as minimum
from olist_order_items_dataset;
