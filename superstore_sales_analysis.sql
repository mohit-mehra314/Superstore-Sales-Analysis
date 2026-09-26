-- Superstore Sales SQL Analysis Project
-- Database: MySQL 8+
-- Dataset: Superstore Orders

CREATE DATABASE IF NOT EXISTS superstore_sales;
USE superstore_sales;

DROP TABLE IF EXISTS superstore_orders;

CREATE TABLE superstore_orders (
    order_id VARCHAR(30),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(30),
    customer_name VARCHAR(150),
    segment VARCHAR(30),
    state VARCHAR(100),
    country VARCHAR(100),
    market VARCHAR(50),
    region VARCHAR(50),
    product_id VARCHAR(50),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(255),
    sales DECIMAL(14,2),
    quantity INT,
    discount DECIMAL(6,4),
    profit DECIMAL(14,2),
    shipping_cost DECIMAL(14,2),
    order_priority VARCHAR(20),
    year INT,
    order_year INT,
    order_month INT,
    order_month_name VARCHAR(20),
    order_year_month VARCHAR(10)
);

-- Import the CSV file after placing it in a permitted MySQL LOCAL INFILE location.
-- Update the path below for your computer.
LOAD DATA LOCAL INFILE 'C:/path/to/superstore_orders.csv'
INTO TABLE superstore_orders
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- =========================================================
-- 1. DATA QUALITY CHECKS
-- =========================================================

SELECT COUNT(*) AS total_rows
FROM superstore_orders;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS unique_orders,
    COUNT(DISTINCT customer_name) AS unique_customers,
    COUNT(DISTINCT product_id) AS unique_products
FROM superstore_orders;

SELECT *
FROM superstore_orders
WHERE order_id IS NULL
   OR order_date IS NULL
   OR sales IS NULL
   OR profit IS NULL;

SELECT order_id, COUNT(*) AS row_count
FROM superstore_orders
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY row_count DESC;

-- =========================================================
-- 2. OVERALL BUSINESS KPIs
-- =========================================================

SELECT
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    SUM(quantity) AS total_quantity,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_name) AS total_customers,
    ROUND(SUM(profit) / NULLIF(SUM(sales), 0) * 100, 2) AS profit_margin_pct
FROM superstore_orders;

-- =========================================================
-- 3. SALES & PROFIT BY CATEGORY
-- =========================================================

SELECT
    category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    SUM(quantity) AS total_quantity,
    ROUND(SUM(profit) / NULLIF(SUM(sales), 0) * 100, 2) AS profit_margin_pct
FROM superstore_orders
GROUP BY category
ORDER BY total_sales DESC;

-- =========================================================
-- 4. SALES & PROFIT BY SUB-CATEGORY
-- =========================================================

SELECT
    sub_category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM superstore_orders
GROUP BY sub_category
ORDER BY total_sales DESC;

-- =========================================================
-- 5. REGIONAL PERFORMANCE
-- =========================================================

SELECT
    region,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore_orders
GROUP BY region
ORDER BY total_sales DESC;

-- =========================================================
-- 6. MARKET PERFORMANCE
-- =========================================================

SELECT
    market,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales), 0) * 100, 2) AS profit_margin_pct
FROM superstore_orders
GROUP BY market
ORDER BY total_sales DESC;

-- =========================================================
-- 7. YEARLY SALES TREND
-- =========================================================

SELECT
    order_year,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM superstore_orders
GROUP BY order_year
ORDER BY order_year;

-- =========================================================
-- 8. MONTHLY SALES TREND
-- =========================================================

SELECT
    order_year_month,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM superstore_orders
GROUP BY order_year_month
ORDER BY order_year_month;

-- =========================================================
-- 9. TOP 10 PRODUCTS BY SALES
-- =========================================================

SELECT
    product_id,
    product_name,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM superstore_orders
GROUP BY product_id, product_name
ORDER BY total_sales DESC
LIMIT 10;

-- =========================================================
-- 10. TOP 10 PRODUCTS BY PROFIT
-- =========================================================

SELECT
    product_id,
    product_name,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(sales), 2) AS total_sales
FROM superstore_orders
GROUP BY product_id, product_name
ORDER BY total_profit DESC
LIMIT 10;

-- =========================================================
-- 11. LOWEST PROFIT / LOSS-MAKING PRODUCTS
-- =========================================================

SELECT
    product_id,
    product_name,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM superstore_orders
GROUP BY product_id, product_name
ORDER BY total_profit ASC
LIMIT 10;

-- =========================================================
-- 12. CUSTOMER SEGMENT ANALYSIS
-- =========================================================

SELECT
    segment,
    COUNT(DISTINCT customer_name) AS customers,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM superstore_orders
GROUP BY segment
ORDER BY total_sales DESC;

-- =========================================================
-- 13. TOP 10 CUSTOMERS BY SALES
-- =========================================================

SELECT
    customer_name,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM superstore_orders
GROUP BY customer_name
ORDER BY total_sales DESC
LIMIT 10;

-- =========================================================
-- 14. DISCOUNT VS PROFIT
-- =========================================================

SELECT
    ROUND(discount, 2) AS discount_rate,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(*) AS order_lines
FROM superstore_orders
GROUP BY ROUND(discount, 2)
ORDER BY discount_rate;

-- =========================================================
-- 15. SHIPPING MODE ANALYSIS
-- =========================================================

SELECT
    ship_mode,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(AVG(shipping_cost), 2) AS avg_shipping_cost
FROM superstore_orders
GROUP BY ship_mode
ORDER BY total_sales DESC;

-- =========================================================
-- 16. ORDER PRIORITY ANALYSIS
-- =========================================================

SELECT
    order_priority,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM superstore_orders
GROUP BY order_priority
ORDER BY total_sales DESC;

-- =========================================================
-- 17. WINDOW FUNCTION: RANK CATEGORIES BY SALES
-- =========================================================

SELECT
    category,
    ROUND(SUM(sales), 2) AS total_sales,
    RANK() OVER (ORDER BY SUM(sales) DESC) AS sales_rank
FROM superstore_orders
GROUP BY category
ORDER BY sales_rank;

-- =========================================================
-- 18. WINDOW FUNCTION: TOP 3 PRODUCTS WITHIN EACH CATEGORY
-- =========================================================

WITH product_sales AS (
    SELECT
        category,
        product_id,
        product_name,
        SUM(sales) AS total_sales,
        ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY SUM(sales) DESC
        ) AS product_rank
    FROM superstore_orders
    GROUP BY category, product_id, product_name
)
SELECT
    category,
    product_id,
    product_name,
    ROUND(total_sales, 2) AS total_sales,
    product_rank
FROM product_sales
WHERE product_rank <= 3
ORDER BY category, product_rank;

-- =========================================================
-- 19. PROFITABLE VS LOSS-MAKING ORDER LINES
-- =========================================================

SELECT
    CASE
        WHEN profit > 0 THEN 'Profitable'
        WHEN profit < 0 THEN 'Loss'
        ELSE 'Break-even'
    END AS profit_status,
    COUNT(*) AS order_lines,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM superstore_orders
GROUP BY profit_status;

-- =========================================================
-- 20. SALES & PROFIT BY COUNTRY
-- =========================================================

SELECT
    country,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM superstore_orders
GROUP BY country
ORDER BY total_sales DESC
LIMIT 20;
