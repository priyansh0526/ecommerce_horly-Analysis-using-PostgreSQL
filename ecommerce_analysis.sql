-- CREATE TABLE
CREATE TABLE ecommerce_hourly (
    Datetime TIMESTAMP,
    Visitors INT,
    Page_Views INT,
    Products_Viewed INT,
    View_Without_Purchase INT,
    Rate_View_Without_Purchase TEXT,
    Search_Clicks INT,
    Likes INT,
    Add_to_Cart_Visitors INT,
    Add_to_Cart_Products INT,
    CR_Products_Added_to_Cart TEXT,
    Buyers_Orders_Created INT,
	Products_Orders_Created TEXT,
	Products_Ordered INT,
    CR_Orders_Created TEXT,
    Buyers_Ready_To_Ship INT,
    Products_Ready_To_Ship_Original TEXT,
    Products_Ready_To_Ship INT,
    CR_Ready_To_Ship TEXT,
    CR_Ready_To_Ship_over_Orders_Created TEXT
);

-- BASIC AQL QUERIES (SELECT, WHERE, ORDER BY, GROUP BY)

-- 1. Select all data
SELECT * FROM ecommerce_hourly LIMIT 5;

-- 2. Select specific ccolumns
SELECT datetime, visitors, page_views
FROM ecommerce_hourly LIMIT 10;

-- 3. Filter rows ( Hours where visitor > 50)
SELECT * FROM ecommerce_hourly
WHERE visitors > 50 LIMIT 10;

-- 4. Hours with more than 5 orders created
SELECT datetime, buyers_orders_created FROM ecommerce_hourly
WHERE buyers_orders_created > 5;

-- 5. Sort by datetime and visitors 
SELECT datetime, visitors FROM ecommerce_hourly 
ORDER BY visitors DESC LIMIT 10;

-- 6. Group by day -> total visitors per day
SELECT DATE(datetime) AS day, SUM(visitors) AS total_visitors FROM ecommerce_hourly
GROUP BY DATE(datetime)
ORDER BY day LIMIT 10;

-- Queries (INNER, RIGHT, LEFT)

-- 1. Create a Basic table for example
CREATE TABLE hour_category (
    hour INT PRIMARY KEY,
    category VARCHAR(50)
);
INSERT INTO hour_category VALUES
(0, 'Midnight'),
(1, 'Early Morning'),
(2, 'Early Morning'),
(8, 'Morning Rush'),
(12, 'Noon'),
(18, 'Evening Peak'),
(21, 'Late Night');

SELECT * FROM hour_category;

-- 2. Inner Join (Match Hour with Category)
SELECT e.datetime, e.visitors, c.category FROM ecommerce_hourly e
INNER JOIN hour_category c
ON EXTRACT(HOUR FROM e.datetime) = c.hour LIMIT 10;

-- 3. Left Join (Show All data even if category missing)
SELECT e.datetime, e.visitors, c.category FROM ecommerce_hourly e
LEFT JOIN hour_category c
ON EXTRACT(HOUR FROM e.datetime) = c.hour LIMIT 10;

-- 4. Right Join (Show All Categories even if no matching data) 
SELECT c.category, e.datetime, e.visitors FROM ecommerce_hourly e
RIGHT JOIN hour_category c
ON EXTRACT(HOUR FROM e.datetime) = c.hour LIMIT 10;

-- Sub Queries (NEsted QUeries)

-- 1. Find rows where visitors > average visitors
SELECT * FROM ecommerce_hourly
WHERE visitors >
    (SELECT AVG(visitors) FROM ecommerce_hourly) LIMIT 10;

-- 2. Highest product views using subquery
SELECT * FROM ecommerce_hourly
WHERE products_viewed = (
    SELECT MAX(products_viewed) FROM ecommerce_hourly) LIMIT 10;

-- 3. Top 5 busiest hours using subquery
SELECT datetime, visitors FROM ecommerce_hourly
ORDER BY visitors DESC LIMIT 5;

-- Aggregate Functions (SUM, AVG, MAX, MIN)
-- 1. Total Visitors
SELECT SUM(visitors) AS total_visitors FROM ecommerce_hourly;

-- 2. Average Page Views
SELECT ROUND(AVG(page_views), 2) AS avg_page_views FROM ecommerce_hourly;

-- 3. Max product viewed in an hour
SELECT MAX(products_viewed) AS max_products_viewed FROM ecommerce_hourly;

-- 4. Average add to cart conversion rate 
SELECT ROUND(AVG(REPLACE(REPLACE(cr_products_added_to_cart, '%', ''),',','.')::NUMERIC
        ),2) AS avg_cart_cr FROM ecommerce_hourly;

-- Create View for Analysis
--  View → Cleaned dataset with numeric conversion
CREATE OR REPLACE VIEW ecommerce_cleaned AS
SELECT
    datetime,
    visitors,
    page_views,
    products_viewed,
    view_without_purchase,
    REPLACE(REPLACE(rate_view_without_purchase, '%', ''), ',', '.')::FLOAT AS rate_view_without_purchase_float,
    search_clicks,
    likes,
    add_to_cart_visitors,
    add_to_cart_products,
    REPLACE(REPLACE(cr_products_added_to_cart, '%', ''), ',', '.')::FLOAT AS cr_products_added_float,
    buyers_orders_created,
    products_orders_created,
    products_ordered,
    REPLACE(REPLACE(cr_orders_created, '%', ''), ',', '.')::FLOAT AS cr_orders_created_float,
    buyers_ready_to_ship,
    products_ready_to_ship_original,
    products_ready_to_ship,
    REPLACE(REPLACE(cr_ready_to_ship, '%', ''), ',', '.')::FLOAT AS cr_ready_to_ship_float,
    REPLACE(REPLACE(cr_ready_to_ship_over_orders_created, '%', ''), ',', '.')::FLOAT AS cr_ready_ship_over_orders_float
FROM ecommerce_hourly;

SELECT * FROM ecommerce_cleaned LIMIT 10;

-- View Daily Summary

CREATE OR REPLACE VIEW daily_summary AS
SELECT
    DATE(datetime) AS day,
    SUM(visitors) AS total_visitors,
    SUM(page_views) AS total_page_views,
    SUM(buyers_orders_created) AS total_orders
FROM ecommerce_hourly
GROUP BY DATE(datetime)
ORDER BY day;

SELECT * FROM daily_summary;

-- Performance Optimization Using Indexes
-- 1. Index for faster date filtering
CREATE INDEX idx_datetime ON ecommerce_hourly (datetime);

-- 2. Index for visitors (used in WHERE + ORDER BY)
CREATE INDEX idx_visitors ON ecommerce_hourly (visitors);

-- 3. Index for page_views
CREATE INDEX idx_page_views ON ecommerce_hourly (page_views);

SELECT *FROM ecommerce_hourly;
