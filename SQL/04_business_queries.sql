--KPIs
SELECT ROUND(SUM(f.order_item_total)/1000000, 2)          AS total_sales_m,
       ROUND(SUM(f.order_profit_per_order)/1000000, 2)    AS total_profit_m,
       COUNT(*)                                           AS total_order_items,
       COUNT(DISTINCT f.order_id)                         AS distinct_orders,
       COUNT(DISTINCT f.customer_id)                      AS total_customers,
       SUM(f.order_item_quantity)                         AS qty_sold,
       ROUND(100.0 * SUM(s.late_delivery_risk) / COUNT(*), 2) AS late_delivery_pct
FROM fact_order_item f
JOIN dim_shipping s USING (shipping_key);


-- 1. Sales and profit by market, ranked
SELECT g.market, ROUND(SUM(f.sales)) AS total_sales,
       ROUND(SUM(f.order_profit_per_order)) AS total_profit,
       RANK() OVER (ORDER BY SUM(f.sales) DESC) AS sales_rank
FROM fact_order_item f JOIN dim_geography g USING (geo_key)
GROUP BY g.market;

-- 2. Month-over-month sales growth
WITH monthly AS (
  SELECT DATE_TRUNC('month', date_key) AS month, SUM(sales) AS sales
  FROM fact_order_item GROUP BY 1)
SELECT month, ROUND(sales) AS sales,
       ROUND((sales - LAG(sales) OVER (ORDER BY month))
             / LAG(sales) OVER (ORDER BY month) * 100, 2) AS mom_growth_pct
FROM monthly ORDER BY month;

-- 3. Top 10 products by sales
SELECT p.product_name, ROUND(SUM(f.sales)) AS sales
FROM fact_order_item f JOIN dim_product p USING (product_card_id)
GROUP BY p.product_name ORDER BY sales DESC LIMIT 10;

-- 4. Customers with high sales but negative profit
SELECT c.customer_id, c.customer_name,
       ROUND(SUM(f.sales)) AS sales,
       ROUND(SUM(f.order_profit_per_order)) AS profit
FROM fact_order_item f JOIN dim_customers c USING (customer_id)
GROUP BY c.customer_id, c.customer_name
HAVING SUM(f.order_profit_per_order) < 0
ORDER BY sales DESC LIMIT 20;

-- 5. Late delivery % by shipping mode
SELECT s.shipping_mode,
       ROUND(100.0 * SUM(s.late_delivery_risk) / COUNT(*), 2) AS late_pct
FROM fact_order_item f JOIN dim_shipping s USING (shipping_key)
GROUP BY s.shipping_mode ORDER BY late_pct DESC;

-- 6. Sales by customer segment, with share of total
SELECT c.customer_segment, ROUND(SUM(f.sales)) AS sales,
       ROUND(100.0 * SUM(f.sales) / SUM(SUM(f.sales)) OVER (), 2) AS pct_of_total
FROM fact_order_item f JOIN dim_customers c USING (customer_id)
GROUP BY c.customer_segment;

-- 7. Sales by category (for the Fishing claim in your report)
SELECT p.category_name, ROUND(SUM(f.sales)) AS sales
FROM fact_order_item f JOIN dim_product p USING (product_card_id)
GROUP BY p.category_name ORDER BY sales DESC LIMIT 10;