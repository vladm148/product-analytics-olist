# Description of database schema

Database Schema consists of 7 dataset tables (geolocation and reviews are not used)

The main table is **olist_orders_dataset**

## Ties between datasets

olist_orders_dataset is connected with:

- olist_order_payments_dataset **using order_id**
- olist_customers_dataset **using customer_id**
- olist_order_items_dataset **using order_id**

olist_order_items_dataset is connected with:

- olist_orders_dataset **using order_id**
- olist_sellers_dataset **using seller_id**
- olist_products_dataset **using product_id**

olist_products_dataset is connected with:

- olist_order_items_dataset **using product_id**
- product_category_name_translation **using product_category_name**

Other datasets can be connected using these tables
