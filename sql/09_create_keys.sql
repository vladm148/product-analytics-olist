-- Creating keys

-- Primary keys:

-- 1) Customers
alter table olist_customers_dataset
add constraint pk_customers
primary key (customer_id);

-- 2) Orders
alter table olist_orders_dataset
add constraint pk_orders
primary key (order_id);

-- 3) Products
alter table olist_products_dataset
add constraint pk_products
primary key (product_id);

-- 4) Sellers
alter table olist_sellers_dataset
add constraint pk_sellers
primary key (seller_id);

-- 5) Order Items
alter table olist_order_items_dataset
add constraint pk_order_items
primary key (order_id, order_item_id);

-- 6) Payments
alter table olist_order_payments_dataset
add constraint pk_payments
primary key (order_id, payment_sequential);

-- 7) Product_category_name_translation
alter table product_category_name_translation
add constraint pk_product_category
primary key (product_category_name);

-- Foreign keys

-- 1) Customers --> Orders
alter table olist_orders_dataset
add constraint fk_orders_customer
foreign key (customer_id)
references olist_customers_dataset(customer_id);

-- 2) Orders --> Order Items
alter table olist_order_items_dataset
add constraint fk_items_order
foreign key (order_id)
references olist_orders_dataset(order_id);

-- 3) Products --> Order Items
alter table olist_order_items_dataset
add constraint fk_items_product
foreign key (product_id)
references olist_products_dataset(product_id);

-- 4) Sellers --> Order Items
alter table olist_order_items_dataset
add constraint fk_items_seller
foreign key (seller_id)
references olist_sellers_dataset(seller_id);

-- 5) Orders --> Payments
alter table olist_order_payments_dataset
add constraint fk_payments_order
foreign key (order_id)
references olist_orders_dataset(order_id);

-- 6) Product_category_name_translation --> Products
alter table olist_products_dataset
add constraint fk_products_category
foreign key (product_category_name)
references product_category_name_translation(product_category_name);
