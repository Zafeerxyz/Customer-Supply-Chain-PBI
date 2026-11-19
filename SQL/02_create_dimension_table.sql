--creating dimension table

CREATE TABLE dim_customers AS
SELECT DISTINCT ON (customer_id)
       customer_id,
       customer_fname || ' ' || customer_lname AS customer_name,
       customer_segment, customer_city, customer_state,
       customer_country, customer_zipcode, customer_street
FROM staging_supply_chain
ORDER BY customer_id;

ALTER TABLE dim_customers ADD PRIMARY KEY (customer_id);



CREATE TABLE dim_product AS
SELECT DISTINCT ON (product_card_id)
       product_card_id, product_category_id, product_name, product_price,
       category_name, department_name
FROM staging_supply_chain
ORDER BY product_card_id;

ALTER TABLE dim_product ADD PRIMARY KEY (product_card_id);


CREATE TABLE dim_geography AS
SELECT ROW_NUMBER() OVER () AS geo_key, t.*
FROM (SELECT DISTINCT market, order_region, order_country, order_city
      FROM staging_supply_chain) t;

ALTER TABLE dim_geography ADD PRIMARY KEY (geo_key);




CREATE TABLE dim_shipping AS
SELECT ROW_NUMBER() OVER () AS shipping_key, t.*,
       t.days_for_shipping_real - t.days_for_shipment_scheduled AS difference
FROM (SELECT DISTINCT shipping_mode, delivery_status, late_delivery_risk,
             days_for_shipment_scheduled, days_for_shipping_real
      FROM staging_supply_chain) t;

ALTER TABLE dim_shipping ADD PRIMARY KEY (shipping_key);





CREATE TABLE dim_date AS
SELECT d::date AS date_key,
       EXTRACT(YEAR FROM d)::int    AS year,
       EXTRACT(QUARTER FROM d)::int AS quarter,
       EXTRACT(MONTH FROM d)::int   AS month,
       TRIM(TO_CHAR(d, 'Month'))    AS month_name
FROM generate_series('2015-01-01'::date, '2018-12-31'::date, '1 day') d;

ALTER TABLE dim_date ADD PRIMARY KEY (date_key);


CREATE TABLE state_ab (
    state TEXT PRIMARY KEY,
    state_full_name TEXT
);


SELECT 'dim_customers' AS tbl, COUNT(*) FROM dim_customers UNION ALL
SELECT 'dim_product',   COUNT(*) FROM dim_product   UNION ALL
SELECT 'dim_geography', COUNT(*) FROM dim_geography UNION ALL
SELECT 'dim_shipping',  COUNT(*) FROM dim_shipping  UNION ALL
SELECT 'dim_date',      COUNT(*) FROM dim_date      UNION ALL
SELECT 'state_ab',      COUNT(*) FROM state_ab;



--data-quality finding.
SELECT DISTINCT c.customer_state
FROM dim_customers c
LEFT JOIN state_ab s ON s.state = c.customer_state
WHERE s.state IS NULL;
