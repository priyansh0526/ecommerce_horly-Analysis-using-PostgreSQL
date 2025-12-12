# 📊 E-Commerce SQL Data Analysis — PostgreSQL

This project demonstrates end–to–end SQL data analysis using an hourly e-commerce dataset.
It includes data import, cleaning, analysis queries, views, indexing, and complete SQL scripts runnable in pgAdmin 4.


---


## 📁 Project Structure

├── dataset_ecommerce_hourly.csv

├── ecommerce_analysis.sql

├── ecommerce_hourly_PostgreSQL_Query_with_Output.pdf

└── README.md

## 📌 Project Overview

This project focuses on analyzing hourly e-commerce activity such as:

- Visitors

- Page Views

- Products Viewed

- Add-to-Cart Activity

- Order Creation

- Ready-to-Ship Conversions

The goal is to learn:

- ✔ SQL fundamentals
- ✔ Data querying & filtering
- ✔ Aggregations
- ✔ Conversions & data cleaning
- ✔ Join operations
- ✔ Subqueries
- ✔ View creation
- ✔ Query optimization
- ✔ PostgreSQL best practices

## 🧰 Tech Stack

- PostgreSQL 14+

- pgAdmin 4

## CSV Dataset (Hourly E-Commerce Metrics)

### 🛠 Setup Instructions
- 1️⃣ Create the database
```SQL
CREATE DATABASE ecommerce_db;
```
- 2️⃣ Create the main table

```SQL
DROP TABLE IF EXISTS ecommerce_hourly;

CREATE TABLE ecommerce_hourly (
    datetime TIMESTAMP,
    visitors INT,
    page_views INT,
    products_viewed INT,
    view_without_purchase INT,
    rate_view_without_purchase TEXT,
    search_clicks INT,
    likes INT,
    add_to_cart_visitors INT,
    add_to_cart_products INT,
    cr_products_added_to_cart TEXT,
    buyers_orders_created INT,
    products_orders_created TEXT,
    products_ordered INT,
    cr_orders_created TEXT,
    buyers_ready_to_ship INT,
    products_ready_to_ship_original TEXT,
    products_ready_to_ship INT,
    cr_ready_to_ship TEXT,
    cr_ready_to_ship_over_orders_created TEXT
);
```
- 3️⃣ Import the CSV File (pgAdmin 4 GUI)

Right-click table → Import/Export → Choose CSV → Header YES → Delimiter ,

## 📚 SQL Concepts Covered
- ✔ SELECT, WHERE, ORDER BY
- ✔ GROUP BY, HAVING
- ✔ INNER / LEFT / RIGHT JOINS
- ✔ Aggregations (SUM, AVG, MAX, MIN)
- ✔ Subqueries (inline + correlated)
- ✔ Creation of Analytical Views
- ✔ Index Optimization
## 📌 Sample Analysis Queries
```SQL
Total Visitors
SELECT SUM(visitors) AS total_visitors
FROM ecommerce_hourly;
```
Top 5 Hours with Highest Page Views

```SQL
SELECT datetime, page_views
FROM ecommerce_hourly
ORDER BY page_views DESC
LIMIT 5;
```
Hours with Visitors > Daily Average

```SQL
SELECT * FROM ecommerce_hourly
WHERE visitors > (SELECT AVG(visitors) FROM ecommerce_hourly);
```
## 🗂 Views Created
### Daily Summary View
```SQL
CREATE OR REPLACE VIEW daily_summary AS
SELECT
    DATE(datetime) AS day,
    SUM(visitors) AS total_visitors,
    SUM(page_views) AS total_page_views,
    SUM(buyers_orders_created) AS total_orders
FROM ecommerce_hourly
GROUP BY DATE(datetime)
ORDER BY day;
```
### Cleaned Data View (numeric conversion)

Includes conversion of “33,33%” → 33.33.

## ⚡ Performance Optimization
- Recommended Indexes
```SQL
CREATE INDEX idx_datetime ON ecommerce_hourly (datetime);
CREATE INDEX idx_visitors ON ecommerce_hourly (visitors);
CREATE INDEX idx_page_views ON ecommerce_hourly (page_views);
```

## 📷 Deliverables for Task

- SQL Scripts (Create Table, Queries, Views, Indexes)

- Screenshots of pgAdmin outputs

- README.md (this file)

## 🎯 Learning Outcomes

By completing this project, we will learn:

- How to analyze structured data using SQL

- How to write clean, optimized PostgreSQL queries

- How to summarize data using GROUP BY

- How to convert text percentage fields to numeric

- How to create reusable SQL views

- How to apply indexes to improve query speed
