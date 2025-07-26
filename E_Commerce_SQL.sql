
-- Retail Sales Analysis Project 

--creating a table named transactions

DROP TABLE IF EXISTS transactions;
CREATE TABLE transactions
  (
   Transaction_id TEXT,
   Sale_date DATE,
   Product_id TEXT,
   Product_name TEXT,
   Price FLOAT,
   Quantity INT,
   Customer_id TEXT, 
   Country TEXT
  )

  SELECT * FROM transactions;

  
-- Removing non-numeric characters from transaction_id & product_id
  
  ALTER TABLE transactions
  ADD COLUMN transaction_int INTEGER,
  ADD COLUMN product_int INTEGER

  UPDATE transactions
  SET transaction_int = CAST(regexp_replace(transaction_id, '\D', '', 'g') AS INTEGER),
      product_int = CAST(regexp_replace(product_id, '\D', '', 'g') AS INTEGER);
  
  
  
  SELECT 
     transaction_int,
	 product_int
  FROM transactions

ALTER TABLE transactions
DROP COLUMN transaction_id,
DROP COLUMN product_id

ALTER TABLE transactions
  RENAME COLUMN transaction_int TO transaction_id,
  RENAME COLUMN product_int TO product_id
        
 


-- Exploratory Data Analysis

-- Business questions

-- Sales trends over time

-- 1. Total sales by Month?

   SELECT 
    DATE_TRUNC('Month', sale_date)::DATE AS Sale_month,
     ROUND(SUM(price::numeric), 2) AS Total_revenue
   FROM transactions 
    GROUP BY Sale_month
    ORDER BY  Sale_month;

-- 2. How many customers does the store have?

     SELECT 
	   COUNT(Customer_id) AS Total_customers
	 FROM transactions

--  how mayny unique (distinct) customers?

   SELECT 
      COUNT(DISTINCT(Customer_id)) AS Distinct_customers
   FROM transactions
   
-- 3. Top performing products

 --  Top 10 products by revenue

     SELECT 
	   product_name,
	     ROUND(SUM(price::numeric), 2) AS Total_revenue_by_product
	 FROM transactions
	 GROUP BY product_name
	 ORDER BY Total_revenue_by_product DESC
	 LIMIT 10;
	 
   --Top 10 worst performing products by revenue
    SELECT 
	   product_name,
	     ROUND(SUM(price::numeric), 2) AS Total_revenue_by_product
	 FROM transactions
	 GROUP BY product_name
	 ORDER BY Total_revenue_by_product ASC
	 LIMIT 10;


-- 4. Country level insights

-- Revenue by country

  SELECT 
     Country,
	 ROUND(SUM(price::numeric), 2) AS Total_revenue_by_country
  FROM transactions
	 GROUP BY Country
	 ORDER BY Total_revenue_by_country DESC

-- Average transaction by country

  SELECT
    Country,
    ROUND(SUM(price::numeric) / COUNT(DISTINCT transaction_id), 2) AS Avg_trans_value
  FROM transactions
	 GROUP BY Country
	 ORDER BY Avg_trans_value DESC
	   
      
-- Product popularity by country using window function
 
 SELECT 
    Country,
	product_name,
	Total_Sales
   FROM(SELECT
     Country,
	 product_name,
	 COUNT(*) AS Total_Sales,
	 ROW_NUMBER() OVER(PARTITION BY Country ORDER BY COUNT(*) DESC) AS rank
  FROM transactions
  GROUP BY Country, product_name
       ) AS ranked
  WHERE rank = 1;
   



	  
 