
-- Online Store Sales Analysis
-- Dataset: bigquery-public-data.thelook_ecommerce
-- Run date: 2026-10-22
-- Revenue rule: only items with status NOT IN ('Cancelled', 'Returned') count as revenue.


-- Q1. Data exploration and table previews

-- First observation
-- First 10 rows of 'users' table
SELECT *
FROM `bigquery-public-data.thelook_ecommerce.users`
LIMIT 10;

-- Number of rows present in 'users' table
SELECT COUNT(*) AS num_of_rows
FROM `bigquery-public-data.thelook_ecommerce.users`;

-- Second observation
-- First 10 rows of 'orders' table
SELECT *
FROM `bigquery-public-data.thelook_ecommerce.orders`
LIMIT 10;

-- Number of rows present in 'orders' table
SELECT COUNT(*) AS num_of_rows
FROM `bigquery-public-data.thelook_ecommerce.orders`;

-- Third observation
-- First 10 rows of 'order_items' table
SELECT *
FROM `bigquery-public-data.thelook_ecommerce.order_items`
LIMIT 10;

-- Number of rows present in 'order_items' table
SELECT COUNT(*) AS num_of_rows
FROM `bigquery-public-data.thelook_ecommerce.order_items`;

-- Fourth observation
-- First 10 rows of 'products' table
SELECT *
FROM `bigquery-public-data.thelook_ecommerce.products`
LIMIT 10;

-- Number of rows present in 'products' table
SELECT COUNT(*) AS num_of_rows
FROM `bigquery-public-data.thelook_ecommerce.products`;

-- Inspect distinct product category and cost combinations
SELECT DISTINCT category, cost
FROM `bigquery-public-data.thelook_ecommerce.products`
ORDER BY category, cost;


-- Q2. Monthly revenue

-- Monthly revenue from February 2019 to September 2026
-- Excludes cancelled and returned items.
-- (Jan 2019 and Oct 2026 are partial months, so they are left out.)
SELECT DATE_TRUNC(DATE(created_at), MONTH) AS month,
       ROUND(SUM(sale_price), 0) AS revenue
FROM `bigquery-public-data.thelook_ecommerce.order_items`
WHERE status NOT IN ('Cancelled', 'Returned')
      AND created_at >= '2019-02-01'
      AND created_at < '2026-10-01'
GROUP BY month
ORDER BY month ASC;


-- Q3. Top 10 product categories by revenue

-- Top 10 categories by revenue (excluding cancelled/returned items)
SELECT products.category,
       ROUND(SUM(order_items.sale_price), 0) AS revenue_per_category
FROM `bigquery-public-data.thelook_ecommerce.products` AS products
JOIN `bigquery-public-data.thelook_ecommerce.order_items` AS order_items
ON products.id = order_items.product_id
WHERE order_items.status NOT IN ('Cancelled', 'Returned')
GROUP BY products.category
ORDER BY revenue_per_category DESC
LIMIT 10;


-- Q4. Orders by status

-- Number of orders per status
SELECT status, COUNT(order_id) AS num_per_status
FROM `bigquery-public-data.thelook_ecommerce.orders`
GROUP BY status
ORDER BY num_per_status DESC;


-- Q5. Top 10 customers by spending

-- Top 10 customers by total spend (excluding cancelled/returned items)
SELECT u.id,
       u.first_name,
       u.last_name,
       ROUND(SUM(oi.sale_price), 0) AS customer_total_spend
FROM `bigquery-public-data.thelook_ecommerce.users` AS u
JOIN `bigquery-public-data.thelook_ecommerce.order_items` AS oi
ON u.id = oi.user_id
WHERE oi.status NOT IN ('Cancelled', 'Returned')
GROUP BY u.id, u.first_name, u.last_name
ORDER BY customer_total_spend DESC
LIMIT 10;


-- Q6. Average item price by country

-- Average item price by country (excluding cancelled/returned items, countries with 1,000+ items sold)
SELECT
       u.country,
       ROUND(AVG(oi.sale_price), 2) AS avg_price,
       COUNT(*) AS item_sold
FROM `bigquery-public-data.thelook_ecommerce.users` AS u
JOIN `bigquery-public-data.thelook_ecommerce.order_items` AS oi
ON u.id = oi.user_id
WHERE oi.status NOT IN ('Cancelled', 'Returned')
GROUP BY u.country
HAVING COUNT(*) >= 1000
ORDER BY avg_price DESC;