-- Olist Geolocation Dataset 
-- Data Quality Check

-- 1) Number of rows

select COUNT(*)
from olist_geolocation_dataset;

-- 2) NULL check

select COUNT(*) as count_rows,
SUM(case when geolocation_zip_code_prefix  is null then 1 else 0 END) as geolocation_zip_code_prefix_nulls,
SUM(case when geolocation_lat is null then 1 else 0 END) as geolocation_lat_nulls,
SUM(case when geolocation_lng is null then 1 else 0 END) as geolocation_lng_nulls,
SUM(case when geolocation_city is null then 1 else 0 END) as geolocation_city_nulls,
SUM(case when geolocation_state is null then 1 else 0 END) as geolocation_state_nulls
from olist_geolocation_dataset;

-- 3) Number of geolocations in each state
select geolocation_state, COUNT(*) as geolocations_count
from olist_geolocation_dataset
group by geolocation_state
order by geolocations_count desc;

-- 4) Number of geolocations in each city
select geolocation_city, COUNT(*) as geolocations_city_count
from olist_geolocation_dataset
group by geolocation_city
order by geolocations_city_count desc
limit 30;
