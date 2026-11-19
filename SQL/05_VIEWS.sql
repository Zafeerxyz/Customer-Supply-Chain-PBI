-- 1. Executive KPIs (matches the dashboard cards)
CREATE OR REPLACE VIEW vw_executive_kpis AS
SELECT ROUND(SUM(f.order_item_total)::numeric, 2)       AS total_sales,
       ROUND(SUM(f.order_profit_per_order)::numeric, 2) AS total_profit,
       COUNT(*)                                         AS total_order_items,
       COUNT(DISTINCT f.order_id)                       AS distinct_orders,
       COUNT(DISTINCT f.customer_id)                    AS total_customers,
       SUM(f.order_item_quantity)                       AS qty_sold,
       ROUND(100.0 * SUM(s.late_delivery_risk) / COUNT(*), 2) AS late_delivery_pct
FROM fact_order_item f
JOIN dim_shipping s USING (shipping_key);

SELECT * FROM vw_executive_kpis;


-- 2. Customer profitability
CREATE OR REPLACE VIEW vw_customer_profitability AS
SELECT c.customer_id, c.customer_name, c.customer_segment, c.customer_state,
       COUNT(DISTINCT f.order_id)                       AS orders,
       ROUND(SUM(f.order_item_total)::numeric, 2)       AS sales,
       ROUND(SUM(f.order_profit_per_order)::numeric, 2) AS profit,
       ROUND((100.0 * SUM(f.order_profit_per_order)
              / NULLIF(SUM(f.order_item_total), 0))::numeric, 2) AS profit_margin_pct
FROM fact_order_item f
JOIN dim_customers c USING (customer_id)
GROUP BY c.customer_id, c.customer_name, c.customer_segment, c.customer_state;

SELECT * FROM vw_customer_profitability;

-- 3. Product performance
CREATE OR REPLACE VIEW vw_product_performance AS
SELECT p.product_name, p.category_name, p.department_name,
       SUM(f.order_item_quantity)                       AS qty_sold,
       ROUND(SUM(f.order_item_total)::numeric, 2)       AS sales,
       ROUND(SUM(f.order_profit_per_order)::numeric, 2) AS profit,
       ROUND(AVG(f.order_item_discount_rate)::numeric * 100, 2) AS avg_discount_pct
FROM fact_order_item f
JOIN dim_product p USING (product_card_id)
GROUP BY p.product_name, p.category_name, p.department_name;

select * from vw_product_performance

-- 4. Shipping performance by market and mode
CREATE OR REPLACE VIEW vw_shipping_performance AS
SELECT g.market, s.shipping_mode,
       COUNT(*)                                         AS shipments,
       ROUND(100.0 * SUM(s.late_delivery_risk) / COUNT(*), 2) AS late_pct,
       ROUND(AVG(s.days_for_shipping_real)::numeric, 2) AS avg_actual_days,
       ROUND(AVG(s.days_for_shipment_scheduled)::numeric, 2) AS avg_scheduled_days
FROM fact_order_item f
JOIN dim_shipping s  USING (shipping_key)
JOIN dim_geography g USING (geo_key)
GROUP BY g.market, s.shipping_mode;

select * from vw_shipping_performance

-- 5. Monthly trend
CREATE OR REPLACE VIEW vw_monthly_trend AS
SELECT d.year, d.month, d.month_name,
       ROUND(SUM(f.order_item_total)::numeric, 2)       AS sales,
       ROUND(SUM(f.order_profit_per_order)::numeric, 2) AS profit
FROM fact_order_item f
JOIN dim_date d USING (date_key)
GROUP BY d.year, d.month, d.month_name;

SELECT * FROM vw_monthly_trend