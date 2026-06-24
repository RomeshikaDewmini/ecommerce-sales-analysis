-- Create database if it doesn't exist
CREATE DATABASE IF NOT EXISTS ecommerce_sales;

-- Select the database to use
USE ecommerce_sales;

SELECT 
    Category,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM orders
GROUP BY Category
ORDER BY Total_Sales DESC;

SELECT 
    Region,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM orders
GROUP BY Region
ORDER BY Total_Sales DESC;

SELECT 
    DATE_FORMAT(Order_Date, '%Y-%m') AS Month,
    ROUND(SUM(Sales), 2) AS Monthly_Sales
FROM orders
GROUP BY DATE_FORMAT(Order_Date, '%Y-%m')
ORDER BY Month;

SELECT 
    Product_Name,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM orders
GROUP BY Product_Name
ORDER BY Total_Sales DESC
LIMIT 10;


SELECT 
    COUNT(*) AS Total_Transactions,
    COUNT(DISTINCT Order_ID) AS Unique_Orders,
    COUNT(DISTINCT Customer_ID) AS Unique_Customers,
    COUNT(DISTINCT Product_ID) AS Unique_Products,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(AVG(Sales), 2) AS Avg_Sales
FROM orders;

-- Drop table if it already exists
DROP TABLE IF EXISTS orders;

-- Create the orders table with appropriate columns
CREATE TABLE orders (
    Row_ID INT,                         -- Unique row identifier
    Order_ID VARCHAR(50),               -- Order ID
    Order_Date DATE,                    -- Order date
    Ship_Date DATE,                     -- Shipping date
    Ship_Mode VARCHAR(50),              -- Shipping mode (Standard, Second Class, etc.)
    Customer_ID VARCHAR(50),            -- Customer ID
    Customer_Name VARCHAR(100),         -- Customer name
    Segment VARCHAR(50),                -- Customer segment (Consumer, Corporate, etc.)
    Country VARCHAR(50),                -- Country
    City VARCHAR(100),                  -- City
    State VARCHAR(50),                  -- State
    Postal_Code VARCHAR(20),            -- Postal code
    Region VARCHAR(50),                 -- Region (East, West, South, Central)
    Product_ID VARCHAR(50),             -- Product ID
    Category VARCHAR(50),               -- Product category (Furniture, Office Supplies, Technology)
    Sub_Category VARCHAR(50),           -- Product sub-category
    Product_Name VARCHAR(200),          -- Product name
    Sales DECIMAL(10,4)                 -- Sales amount
);

-- Load data from CSV file into orders table
LOAD DATA LOCAL INFILE 'C:/Users/ACER/Desktop/ecommerce-sales-analysis/data/Superstore_Sales_Dataset.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','              -- Fields separated by comma
OPTIONALLY ENCLOSED BY '"'            -- Fields optionally enclosed by double quotes
LINES TERMINATED BY '\n'              -- Lines terminated by newline
IGNORE 1 ROWS                         -- Skip the header row
-- Map CSV columns to table columns
(Row_ID, Order_ID, @Order_Date, @Ship_Date, Ship_Mode, Customer_ID, Customer_Name, 
 Segment, Country, City, State, Postal_Code, Region, Product_ID, Category, 
 Sub_Category, Product_Name, Sales)
-- Convert date formats from DD/MM/YYYY to YYYY-MM-DD
SET 
    Order_Date = STR_TO_DATE(@Order_Date, '%d/%m/%Y'),
    Ship_Date = STR_TO_DATE(@Ship_Date, '%d/%m/%Y');
    
 -- View first 10 rows to verify data
SELECT * FROM orders LIMIT 10;

-- Count total rows imported
SELECT COUNT(*) AS Total_Rows FROM orders;

-- View table structure
DESCRIBE orders;

-- Summary statistics: total sales, unique orders, total transactions
SELECT 
    ROUND(SUM(Sales), 2) AS Total_Sales,                    -- Total sales amount
    COUNT(DISTINCT Order_ID) AS Total_Orders,               -- Number of unique orders
    COUNT(*) AS Total_Transactions                          -- Number of transactions
FROM orders;


  -- Sales by product category
SELECT 
    Category,                                               -- Product category
    ROUND(SUM(Sales), 2) AS Total_Sales,                    -- Total sales per category
    COUNT(*) AS Order_Count                                 -- Number of orders per category
FROM orders
GROUP BY Category
ORDER BY Total_Sales DESC;                                  -- Sort by highest sales first


 -- Top 10 performing sub-categories
SELECT 
    Sub_Category,                                           -- Product sub-category
    ROUND(SUM(Sales), 2) AS Total_Sales,                    -- Total sales per sub-category
    COUNT(*) AS Order_Count                                 -- Number of orders
FROM orders
GROUP BY Sub_Category
ORDER BY Total_Sales DESC
LIMIT 10;                                                   -- Show top 10 only

-- Top 10 products by sales
SELECT 
    Product_Name,                                           -- Product name
    ROUND(SUM(Sales), 2) AS Total_Sales,                    -- Total sales per product
    SUM(Quantity) AS Total_Quantity                         -- Total quantity sold
FROM orders
GROUP BY Product_Name
ORDER BY Total_Sales DESC
LIMIT 10;                                                   -- Show top 10 products

-- Sales performance by region
SELECT 
    Region,                                                 -- Region name
    ROUND(SUM(Sales), 2) AS Total_Sales,                    -- Total sales per region
    COUNT(DISTINCT Order_ID) AS Orders_Count                -- Number of unique orders per region
FROM orders
GROUP BY Region
ORDER BY Total_Sales DESC;                                  -- Sort by highest sales first

-- Top 5 states by sales
SELECT 
    State,                                                  -- State name
    ROUND(SUM(Sales), 2) AS Total_Sales                     -- Total sales per state
FROM orders
GROUP BY State
ORDER BY Total_Sales DESC
LIMIT 5;                                                    -- Show top 5 states

-- Monthly sales trend
SELECT 
    DATE_FORMAT(Order_Date, '%Y-%m') AS Month,              -- Format date as Year-Month
    ROUND(SUM(Sales), 2) AS Monthly_Sales,                  -- Total sales per month
    COUNT(DISTINCT Order_ID) AS Orders_Count                -- Number of orders per month
FROM orders
GROUP BY DATE_FORMAT(Order_Date, '%Y-%m')                   -- Group by year-month
ORDER BY Month;                                             -- Sort chronologically

-- Top 10 customers by revenue
SELECT 
    Customer_Name,                                          -- Customer name
    ROUND(SUM(Sales), 2) AS Total_Sales,                    -- Total sales per customer
    COUNT(DISTINCT Order_ID) AS Orders_Count                -- Number of orders per customer
FROM orders
GROUP BY Customer_Name
ORDER BY Total_Sales DESC
LIMIT 10;                                                   -- Show top 10 customers

-- Sales by customer segment
SELECT 
    Segment,                                                -- Customer segment
    ROUND(SUM(Sales), 2) AS Total_Sales,                    -- Total sales per segment
    COUNT(DISTINCT Customer_ID) AS Customer_Count           -- Number of customers per segment
FROM orders
GROUP BY Segment
ORDER BY Total_Sales DESC;

-- Shipping mode analysis
SELECT 
    Ship_Mode,                                              -- Shipping mode
    COUNT(*) AS Orders_Count,                               -- Number of orders per shipping mode
    ROUND(SUM(Sales), 2) AS Total_Sales                     -- Total sales per shipping mode
FROM orders
GROUP BY Ship_Mode
ORDER BY Orders_Count DESC;

-- Year-over-year sales comparison
SELECT 
    YEAR(Order_Date) AS Year,                               -- Year
    ROUND(SUM(Sales), 2) AS Total_Sales,                    -- Total sales per year
    COUNT(DISTINCT Order_ID) AS Orders_Count                -- Number of orders per year
FROM orders
GROUP BY YEAR(Order_Date)
ORDER BY Year;

-- Complete business overview statistics
SELECT 
    COUNT(*) AS Total_Transactions,                         -- Total transactions
    COUNT(DISTINCT Order_ID) AS Unique_Orders,              -- Unique orders
    COUNT(DISTINCT Customer_ID) AS Unique_Customers,        -- Unique customers
    COUNT(DISTINCT Product_ID) AS Unique_Products,          -- Unique products
    ROUND(SUM(Sales), 2) AS Total_Sales,                    -- Total sales
    ROUND(AVG(Sales), 2) AS Avg_Sales,                      -- Average sales per transaction
    ROUND(MIN(Sales), 2) AS Min_Sales,                      -- Minimum sales amount
    ROUND(MAX(Sales), 2) AS Max_Sales                       -- Maximum sales amount
FROM orders;

    