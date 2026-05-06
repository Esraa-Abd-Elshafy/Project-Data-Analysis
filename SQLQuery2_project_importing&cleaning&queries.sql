SELECT TOP (1000) [category]
      ,[city]
      ,[country]
      ,[customer_id]
      ,[customer_name]
      ,[discount]
      ,[market]
      ,[order_date]
      ,[order_id]
      ,[order_priority]
      ,[product_id]
      ,[product_name]
      ,[profit]
      ,[quantity]
      ,[region]
      ,[sales]
      ,[segment]
      ,[ship_date]
      ,[ship_mode]
      ,[shipping_cost]
      ,[state]
      ,[sub_category]
      ,[order_year]
      ,[order_month]
      ,[order_quarter]
      ,[order_day_of_week]
      ,[is_weekend]
      ,[order_week]
      ,[discount_bin]
      ,[profit_margin]
      ,[sales_per_unit]

  FROM [real_project].[dbo].[superstore_complete_2]
  --importing data & inserting
  CREATE TABLE dim_customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    market VARCHAR(50)
);

CREATE TABLE dim_products (
    product_key INT IDENTITY(1,1) PRIMARY KEY,
    product_id VARCHAR(50),
    product_name VARCHAR(255),
    category VARCHAR(50),
    sub_category VARCHAR(50)
);

CREATE TABLE dim_location (
    location_key INT IDENTITY(1,1) PRIMARY KEY,
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    region VARCHAR(50)
);

CREATE TABLE dim_shipping (
    ship_key INT IDENTITY(1,1) PRIMARY KEY,
    ship_mode VARCHAR(50),
    order_priority VARCHAR(50)
);

CREATE TABLE dim_date (
    date_key DATE PRIMARY KEY,
    order_year INT,
    order_month INT,
    order_quarter INT,
    order_week INT,
    order_day_of_week INT,
    is_weekend BIT
);

CREATE TABLE fact_sales (
    row_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id VARCHAR(50),
    customer_id VARCHAR(50),
    product_key INT,
    location_key INT,
    ship_key INT,
    order_date DATE,
    ship_date DATE,
    sales DECIMAL(18,2),
    quantity INT,
    discount DECIMAL(18,2),
    profit DECIMAL(18,2),
    shipping_cost DECIMAL(18,2),
    profit_margin DECIMAL(18,2),
    sales_per_unit DECIMAL(18,2),
	  FOREIGN KEY (customer_id) REFERENCES dim_customers(customer_id),
    FOREIGN KEY (product_key) REFERENCES dim_products(product_key),
    FOREIGN KEY (location_key) REFERENCES dim_location(location_key),
    FOREIGN KEY (ship_key) REFERENCES dim_shipping(ship_key)
);

---insert into tables

INSERT INTO dim_customers
SELECT DISTINCT
    customer_id,
    customer_name,
    segment,
    market
FROM superstore_complete_2;

INSERT INTO dim_products (product_id, product_name, category, sub_category)
SELECT DISTINCT
    product_id,
    product_name,
    category,
    sub_category
FROM superstore_complete_2;

INSERT INTO dim_location (country, city, state, region)
SELECT DISTINCT
    country,
    city,
    state,
    region
FROM superstore_complete_2;

INSERT INTO dim_shipping (ship_mode, order_priority)
SELECT DISTINCT
    ship_mode,
    order_priority
FROM superstore_complete_2;

INSERT INTO dim_date
SELECT DISTINCT
    order_date,
    order_year,
    order_month,
    order_quarter,
    order_week,
    order_day_of_week,
    is_weekend
FROM superstore_complete_2;

INSERT INTO fact_sales (
    order_id,
    customer_id, product_key, location_key, ship_key,
    order_date, ship_date,
    sales, quantity, discount, profit, shipping_cost,
    profit_margin, sales_per_unit
)
SELECT
    s.order_id,
    s.customer_id,
    p.product_key,
    l.location_key,
    sh.ship_key,
    s.order_date,
    s.ship_date,
    s.sales,
    s.quantity,
    s.discount,
    s.profit,
    s.shipping_cost,
    s.profit_margin,
    s.sales_per_unit
FROM superstore_complete_2 s

JOIN dim_products p 
    ON s.product_id = p.product_id

JOIN dim_location l 
    ON s.country = l.country
    AND s.city = l.city
    AND s.state = l.state
    AND s.region = l.region

JOIN dim_shipping sh 
    ON s.ship_mode = sh.ship_mode
    AND s.order_priority = sh.order_priority;

--10 queries

--1. Total Sales & Profit per Year
SELECT 
    d.order_year,
    SUM(f.sales) AS total_sales,
    SUM(f.profit) AS total_profit
FROM fact_sales f
JOIN dim_date d ON f.order_date = d.date_key
GROUP BY d.order_year
ORDER BY d.order_year;


--2. Top 5 Products by Sales
SELECT TOP 5
    p.product_name,
    SUM(f.sales) AS total_sales
FROM fact_sales f
JOIN dim_products p ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_sales DESC;

--3. Customers with Total Sales > 5000 (HAVING)
SELECT 
    c.customer_name,
    SUM(f.sales) AS total_sales
FROM fact_sales f
JOIN dim_customers c ON f.customer_id = c.customer_id
GROUP BY c.customer_name
HAVING SUM(f.sales) > 5000;


--4. Orders Count per Region
SELECT 
    l.region,
    COUNT(DISTINCT f.order_id) AS total_orders
FROM fact_sales f
JOIN dim_location l ON f.location_key = l.location_key
GROUP BY l.region;

--5. Products Above Average Sales
SELECT 
    p.product_name,
    SUM(f.sales) AS total_sales
FROM fact_sales f
JOIN dim_products p ON f.product_key = p.product_key
GROUP BY p.product_name
HAVING SUM(f.sales) > (
    SELECT AVG(sales) FROM fact_sales
);


--6. Profit Margin per Segment
SELECT 
    c.segment,
    SUM(f.profit) / SUM(f.sales) AS profit_margin
FROM fact_sales f
JOIN dim_customers c ON f.customer_id = c.customer_id
GROUP BY c.segment;

--7. Monthly Sales Trend
SELECT 
    d.order_year,
    d.order_month,
    SUM(f.sales) AS total_sales
FROM fact_sales f
JOIN dim_date d ON f.order_date = d.date_key
GROUP BY d.order_year, d.order_month
ORDER BY d.order_year, d.order_month;

--8. Highest Sales Order
SELECT *
FROM fact_sales
WHERE sales = (SELECT MAX(sales) FROM fact_sales);


--9. Top Shipping Modes by Profit
SELECT 
    s.ship_mode,
    SUM(f.profit) AS total_profit
FROM fact_sales f
JOIN dim_shipping s ON f.ship_key = s.ship_key
GROUP BY s.ship_mode
ORDER BY total_profit DESC;


--10 View Sales Summary
CREATE VIEW vw_sales_summary AS
SELECT 
    d.order_year,
    c.segment,
    p.category,
    SUM(f.sales) AS total_sales,
    SUM(f.profit) AS total_profit
FROM fact_sales f
JOIN dim_date d ON f.order_date = d.date_key
JOIN dim_customers c ON f.customer_id = c.customer_id
JOIN dim_products p ON f.product_key = p.product_key
GROUP BY d.order_year, c.segment, p.category;

SELECT * FROM vw_sales_summary;
