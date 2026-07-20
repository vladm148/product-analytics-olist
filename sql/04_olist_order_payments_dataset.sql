-- Olist Order_payments Dataset 
-- Data Quality Check

-- 1) Number of rows

select COUNT(*)
from olist_order_payments_dataset;

-- 2) NULL check

select COUNT(*) as count_rows,
SUM(case when order_id is null then 1 else 0 END) as order_id_nulls,
SUM(case when payment_sequential is null then 1 else 0 END) as payment_sequential_nulls,
SUM(case when payment_type is null then 1 else 0 END) as payment_type_nulls,
SUM(case when payment_installments is null then 1 else 0 END) as payment_installments_nulls,
SUM(case when payment_value is null then 1 else 0 END) as payment_value_nulls
from olist_order_payments_dataset;

-- 3) Duplicates:

-- a) order_id
 
select order_id, COUNT(*) as count
from olist_order_payments_dataset
group by order_id 
having COUNT(*) > 1;

-- 4) Min/max

-- a) Payment_installments

select MAX(payment_installments) as maximum, MIN(payment_installments) as minimum
from olist_order_payments_dataset;

-- b) Payment_value

select MAX(payment_value) as maximum, MIN(payment_value) as minimum
from olist_order_payments_dataset;

-- 5) Distribution of:

-- a) Payment_types

select payment_type, COUNT(*) as count_type
from olist_order_payments_dataset
group by payment_type
order by count_type desc;

-- b) Payment_sequential

select payment_sequential, COUNT(*) as count_sequential
from olist_order_payments_dataset
group by payment_sequential
order by count_sequential desc;

