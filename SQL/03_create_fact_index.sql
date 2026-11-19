

CREATE TABLE fact_order_item AS
SELECT s.order_item_id, s.order_id, s.customer_id, s.product_card_id,
       s.order_date::date AS date_key,
       g.geo_key, sh.shipping_key,
       s.sales, s.order_item_total, s.order_profit_per_order,
       s.order_item_quantity, s.order_item_discount,
       s.order_item_discount_rate, s.order_item_product_price,
       s.order_item_profit_ratio, s.benefit_per_order, s.sales_per_customer,
       CASE
         WHEN s.order_item_product_price <= 50  THEN '$0 - $50'
         WHEN s.order_item_product_price <= 100 THEN '$51 - $100'
         WHEN s.order_item_product_price <= 200 THEN '$101 - $200'
         WHEN s.order_item_product_price <= 500 THEN '$201 - $500'
         ELSE '$500+'
       END AS price_range
FROM staging_supply_chain s
JOIN dim_geography g
  ON g.market = s.market AND g.order_region = s.order_region
 AND g.order_country = s.order_country AND g.order_city = s.order_city
JOIN dim_shipping sh
  ON sh.shipping_mode = s.shipping_mode
 AND sh.delivery_status = s.delivery_status
 AND sh.late_delivery_risk = s.late_delivery_risk
 AND sh.days_for_shipment_scheduled = s.days_for_shipment_scheduled
 AND sh.days_for_shipping_real = s.days_for_shipping_real;


--Validate the row count
SELECT (SELECT COUNT(*) FROM staging_supply_chain)      AS staging_rows,
       (SELECT COUNT(*) FROM fact_order_item) AS fact_rows;



ALTER TABLE fact_order_item ADD PRIMARY KEY (order_item_id);


ALTER TABLE fact_order_item
  ADD FOREIGN KEY (customer_id)     REFERENCES dim_customers(customer_id),
  ADD FOREIGN KEY (product_card_id) REFERENCES dim_product(product_card_id),
  ADD FOREIGN KEY (date_key)        REFERENCES dim_date(date_key),
  ADD FOREIGN KEY (geo_key)         REFERENCES dim_geography(geo_key),
  ADD FOREIGN KEY (shipping_key)    REFERENCES dim_shipping(shipping_key);



CREATE INDEX idx_fact_customer ON fact_order_item(customer_id);
CREATE INDEX idx_fact_product  ON fact_order_item(product_card_id);
CREATE INDEX idx_fact_date     ON fact_order_item(date_key);
CREATE INDEX idx_fact_geo      ON fact_order_item(geo_key);
CREATE INDEX idx_fact_ship     ON fact_order_item(shipping_key);



