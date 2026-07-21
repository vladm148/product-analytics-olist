-- Olist Category Name Translation Dataset 
-- Data Quality Check

-- 1) Number of rows

select COUNT(*)
from product_category_name_translation;

-- 2) NULL check

select COUNT(*) as count_rows,
SUM(case when product_category_name is null then 1 else 0 END) as product_category_name_nulls,
SUM(case when product_category_name_english is null then 1 else 0 END) as product_category_name_english_nulls
from product_category_name_translation;

