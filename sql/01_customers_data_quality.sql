-- Olist Customers Dataset 
-- Data Quality Check

-- 1) Number of rows

select COUNT(*)
from olist_customers_dataset;

-- 2) NULL check

select COUNT(*) as count_rows,
SUM(case when customer_id is null then 1 else 0 END) as customer_id_nulls,
SUM(case when customer_unique_id is null then 1 else 0 END) as customer_unique_id_nulls,
SUM(case when customer_zip_code_prefix is null then 1 else 0 END) as customer_zip_code_prefix_nulls,
SUM(case when customer_city is null then 1 else 0 END) as customer_city_nulls,
SUM(case when customer_state is null then 1 else 0 END) as customer_state_nulls
from olist_customers_dataset;

-- 3) Duplicates:

-- a) customer_id
 
select customer_id, COUNT(*) as count
from olist_customers_dataset
group by customer_id 
having COUNT(*) > 1;

-- b) customer_unique_id

select customer_unique_id, COUNT(*) as count
from olist_customers_dataset
group by customer_unique_id 
having COUNT(*) > 1;


-- 4) Unique states

select distinct customer_state
from olist_customers_dataset
order by customer_state;

-- 5) Number of client in each state
select customer_state, COUNT(*) as clients_count
from olist_customers_dataset
group by customer_state
order by clients_count desc;
