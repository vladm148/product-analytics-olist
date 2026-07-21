-- Olist Sellers Dataset 
-- Data Quality Check

-- 1) Number of rows

select COUNT(*)
from olist_sellers_dataset;

-- 2) NULL check

select COUNT(*) as count_rows,
SUM(case when seller_id is null then 1 else 0 END) as seller_id_nulls,
SUM(case when seller_zip_code_prefix is null then 1 else 0 END) as seller_zip_code_prefix_nulls,
SUM(case when seller_city is null then 1 else 0 END) as seller_city_nulls,
SUM(case when seller_state is null then 1 else 0 END) as seller_state_nulls
from olist_sellers_dataset;

-- 3) Duplicates:

-- a) seller_id
 
select seller_id, COUNT(*) as count
from olist_sellers_dataset
group by seller_id 
having COUNT(*) > 1;

-- 4) Distribution of:

-- a) seller_city

select seller_city, COUNT(*) as count_city
from olist_sellers_dataset
group by seller_city
order by count_city desc;

-- b) seller_state

select seller_state, COUNT(*) as count_seller_state
from olist_sellers_dataset
group by seller_state
order by count_seller_state desc;

