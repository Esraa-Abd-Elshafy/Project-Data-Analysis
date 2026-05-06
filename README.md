# Project-Data-Analysis
 Sales Data Analysis Project – Star Schema Data Warehouse & Power BI Dashboard
📌 Project Overview
This project presents a complete end-to-end data analytics pipeline for a superstore sales dataset. It includes:

Data cleaning and normalization using SQL Server

Star Schema data warehouse design (fact & dimension tables)

Complex analytical queries for business insights

Interactive Power BI dashboard for visualization and decision-making

The goal is to transform raw sales data into actionable business intelligence that helps improve profitability, optimize shipping strategies, and identify high-value customers and products.

🧱 Data Architecture – Star Schema
The raw table superstore_complete_2 was normalized into the following structure:

Fact Table
Table	Description
fact_sales	Stores quantitative metrics: sales, profit, quantity, discount, shipping cost, profit margin, sales per unit. Contains foreign keys to all dimension tables.
Dimension Tables
Table	Description
dim_customers	Customer ID, name, segment, market
dim_products	Product ID, name, category, sub-category
dim_location	Country, city, state, region
dim_shipping	Ship mode, order priority
dim_date	Date key, year, month, quarter, week, day of week, weekend flag
Relationship Diagram
text
fact_sales ──┬── dim_customers
             ├── dim_products
             ├── dim_location
             ├── dim_shipping
             └── dim_date
🛠️ Technologies Used
Tool	Purpose
SQL Server	Data storage, ETL, normalization, querying
Power BI	Interactive dashboards & data visualization
DAX	Measures: YTD Sales, Sales Growth %, Product Rank, Profit Margin
GitHub	Version control and project documentation
📈 Key Business Questions Answered
What are the total sales and profit per year?

Which are the top 5 products by sales?

Which customers have total sales > 5000?

What is the order count per region?

Which products perform above average sales?

What is the profit margin per customer segment?

What is the monthly sales trend?

Which order has the highest sales?

Which shipping modes generate the most profit?

How do sales and profit vary by year, segment, and category?

📊 Dashboard Pages & Insights
Page 1 – Executive KPI Dashboard
KPIs: Total Sales (13M), Total Profit (1.47M), Total Orders (103M), Profit Margin (242K)

Filters: Year, Category, Country

Insights: Consumer segment drives 51% of profit; Standard Class shipping is most profitable.

Page 2 – Sales & Profit Trends
Line Chart: Sales and profit growth from 2011 to 2014

Insight: Consistent YoY growth (~15–20%)

Page 3 – Category Profitability
Furniture: Only 6.49% profit margin despite 93.51% of sales

Recommendation: Review discounting and shipping costs for Furniture

Page 4 – Product Performance
Top products (e.g., Canon imageCLASS) drive high sales & profit

Bottom products show negative profit → discontinue or bundle

Page 5 – Geographic Sales
USA dominates (28M YTD sales)

Emerging markets: India, Brazil, Indonesia

Page 6 – Shipping Mode Profit
Standard Class: 0.89M profit

Same Day: 0.08M profit → restrict or surcharge

Page 7 – Segment Distribution
Consumer: 51.06% of profit

Corporate: 30.07%

Home Office: 18.88%

⭐ Acknowledgments
Sample dataset: Superstore sales data

Tools: Microsoft SQL Server, Power BI.


