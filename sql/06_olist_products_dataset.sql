-- Olist Products Dataset 
-- Data Quality Check

-- 1) Number of rows

select COUNT(*)
from olist_products_dataset;

-- 2) NULL check

select COUNT(*) as count_rows,
SUM(case when product_id is null then 1 else 0 END) as product_id_nulls,
SUM(case when product_category_name is null then 1 else 0 END) as product_category_name_nulls,
SUM(case when product_name_lenght is null then 1 else 0 END) as product_name_lenght_nulls,
SUM(case when product_description_lenght is null then 1 else 0 END) as product_description_lenght_nulls,
SUM(case when product_photos_qty is null then 1 else 0 END) as product_photos_qty_nulls,
SUM(case when product_weight_g is null then 1 else 0 END) as product_weight_g_nulls,
SUM(case when product_length_cm is null then 1 else 0 END) as product_length_cm_nulls,
SUM(case when product_height_cm is null then 1 else 0 END) as product_height_cm_nulls,
SUM(case when product_width_cm is null then 1 else 0 END) as product_width_cm_nulls
from olist_products_dataset;

-- 3) Duplicates:

-- a) product_id
 
select product_id, COUNT(*) as count
from olist_products_dataset
group by product_id 
having COUNT(*) > 1;

-- 4) Min/max

-- a) product_weight_g

select MAX(product_weight_g) as maximum, MIN(product_weight_g) as minimum
from olist_products_dataset;

-- b) product_length_cm

select MAX(product_length_cm) as maximum, MIN(product_length_cm) as minimum
from olist_products_dataset;

-- c) product_height_cm

select MAX(product_height_cm) as maximum, MIN(product_height_cm) as minimum
from olist_products_dataset;

-- d) product_width_cm

select MAX(product_width_cm) as maximum, MIN(product_width_cm) as minimum
from olist_products_dataset;

-- 5) Distribution of:

-- a) product_category_name

select product_category_name, COUNT(*) as count_category
from olist_products_dataset
group by product_category_name
order by count_category desc;

-- b) product_photos_qty

select product_photos_qty, COUNT(*) as count_photos_quantity
from olist_products_dataset
group by product_photos_qty
order by count_photos_quantity desc;

