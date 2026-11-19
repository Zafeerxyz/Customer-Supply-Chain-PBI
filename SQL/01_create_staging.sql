CREATE DATABASE supply_chain;


CREATE TABLE staging_supply_chain (
    type                    TEXT,
    days_for_shipping_real  INT,
    days_for_shipment_scheduled INT,
    benefit_per_order       NUMERIC,
    sales_per_customer      NUMERIC,
    delivery_status         TEXT,
    late_delivery_risk      INT,
    category_id             INT,
    category_name           TEXT,
    customer_city           TEXT,
    customer_country        TEXT,
    customer_email          TEXT,
    customer_fname          TEXT,
    customer_id             INT,
    customer_lname          TEXT,
    customer_password       TEXT,
    customer_segment        TEXT,
    customer_state          TEXT,
    customer_street         TEXT,
    customer_zipcode        TEXT,
    department_id           INT,
    department_name         TEXT,
    latitude                NUMERIC,
    longitude               NUMERIC,
    market                  TEXT,
    order_city              TEXT,
    order_country           TEXT,
    order_customer_id       INT,
    order_date              TIMESTAMP,
    order_id                INT,
    order_item_cardprod_id  INT,
    order_item_discount     NUMERIC,
    order_item_discount_rate NUMERIC,
    order_item_id           INT,
    order_item_product_price NUMERIC,
    order_item_profit_ratio NUMERIC,
    order_item_quantity     INT,
    sales                   NUMERIC,
    order_item_total        NUMERIC,
    order_profit_per_order  NUMERIC,
    order_region            TEXT,
    order_state             TEXT,
    order_status            TEXT,
    order_zipcode           TEXT,
    product_card_id         INT,
    product_category_id     INT,
    product_description     TEXT,
    product_image           TEXT,
    product_name            TEXT,
    product_price           NUMERIC,
    product_status          INT,
    shipping_date           TIMESTAMP,
    shipping_mode           TEXT
);

SELECT COUNT(*) FROM staging_supply_chain;

-- Null counts on key columns
SELECT
  COUNT(*) FILTER (WHERE customer_id IS NULL) AS null_customers,
  COUNT(*) FILTER (WHERE order_id IS NULL)    AS null_orders,
  COUNT(*) FILTER (WHERE sales IS NULL)       AS null_sales
FROM staging_supply_chain;

-- Duplicate order items
SELECT order_item_id, COUNT(*)
FROM staging_supply_chain
GROUP BY order_item_id
HAVING COUNT(*) > 1;

-- Inconsistent categorical values
SELECT DISTINCT shipping_mode FROM staging_supply_chain;
SELECT DISTINCT delivery_status FROM staging_supply_chain;
