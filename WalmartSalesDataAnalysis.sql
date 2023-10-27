

Create database salesDataWalmart;

-- Table 

CREATE TABLE sale(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

Select * from sales;



------------------------------------------------------------------------
-------- Feature Engineering
-- time_of_day 

Select  
    time,
    ( CASE
      WHEN 'time' between "00:00:00" AND "12:00:00" THEN "MORNING"
	  WHEN 'time' between "12:00:00" AND "16:00:00" THEN "AFTERNOON"
      ELSE
      "EVENING"
   END
   ) AS time_of_date
    from sales;

ALTER TABLE SALES ADD COLUMN time_of_day Varchar(20);

UPDATE SALES 
SET time_of_day = (
  CASE
      WHEN 'time' between "00:00:00" AND "12:00:00" THEN "MORNING"
	  WHEN 'time' between "12:00:00" AND "16:00:00" THEN "AFTERNOON"
      ELSE
      "EVENING"
   END
   ) ;

  ------------------------------------------------------------------------------------------
  -- day_name
  
 Select date ,
   dayname(date) AS day_name
 from sales;
 
 
 ALTER TABLE SALES ADD COLUMN day_name varchar(20);
 
UPDATE sales
set day_name = dayname(DATE);



---------------- 
-- Month name

Select 
date,
monthname(date) 
from sales;

alter TABLE SALES ADD COLUMN Month_name varchar(20);

UPDATE sales
set Month_name = monthname(Date);



-----------------------------------------------------------------------------
-- Generic---------
-- How many uniquecities does the data have?
 
 Select 
 distinct city
 FROM SALES;


SELECT
distinct branch
FROM SALES;

-- 	IN which city is each branch
SELECT 
DISTINCT CITY,
BRANCH 
FROM SALES;

-- Product

 -- How many unique product line does the data have
select count(product_line) 
from sales;

-- most common payment method
Select payment,
 Count(payment) as cnt
from sales
group by payment 
order by cnt desc;

-- most selling productline

Select * from sales;

Select product_line,
count(product_line) as cnt
from sales
Group by product_line
order by cnt desc;

-- total revenue by month

 select
 month_name as Month,
 SUM(total) as total_revenue
 from sales
 Group by month_name
 order by total_revenue;
 
 
-- Which month has largest cogs

Select 
month_name as Month,
sum(cogs) as cogs
from sales
group by month
order by cogs desc;


-- What product line had the largest revenue?

Select 
product_line,
sum(total) as total_revenue
from sales
group by product_line 
order by total_revenue desc;


-- What city had the largest revenue?

Select 
branch,
city,
sum(total) as total_revenue
from sales
group by city ,branch
order by total_revenue desc;

-- Which product line had largest VAT?
Select product_line,
avg(tax_pct) AS avg_tax
from sales
group by product_line
order by avg_tax desc;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
 
 
 
 
 -- Which branch sold more products than average product sold?
  Select 
  branch, 
  sum(Quantity) as qty
  from sales
  Group by branch
  having SUM(quantity) > (Select Avg(Quantity) from sales);
  
  -- What is the most common product line by gender?
  Select distinct product_line , gender,
  Count(gender) as total_cnt
  from sales
  group by product_line,gender
  order by total_cnt desc;
  
  
  -- What is the average rating of each product line?
  
  select product_line,
  ROUND (avg(Rating) , 2) as average_ratings
  from sales
  Group by product_line
  order by average_ratings desc;
  
  
  -------------------------------------------------------------------------
  -- SALES-----------
  
  SELECT * FROM SALES;
  
 -- Number of sales made in each time of the day per weekday 
SELECT
	time_of_day,
	COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Sunday"
GROUP BY time_of_day 
ORDER BY total_sales DESC;
-- Evenings experience most sales, the stores are 
-- filled during the evening hours

-- Which of the customer types brings the most revenue?
SELECT
	customer_type,
	SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue;

-- Which city has the largest tax/VAT percent?
SELECT
	city,
    ROUND(AVG(tax_pct), 2) AS avg_tax_pct
FROM sales
GROUP BY city 
ORDER BY avg_tax_pct DESC;

-- Which customer type pays the most in VAT?
SELECT
	customer_type,
	AVG(tax_pct) AS total_tax
FROM sales
GROUP BY customer_type
ORDER BY total_tax;

-- -------------------------- Customers -------------------------------
-- --------------------------------------------------------------------

-- How many unique customer types does the data have?
SELECT
	DISTINCT customer_type
FROM sales;

-- How many unique payment methods does the data have?
SELECT
	DISTINCT payment
FROM sales;


-- What is the most common customer type?
SELECT
	customer_type,
	count(*) as count
FROM sales
GROUP BY customer_type
ORDER BY count DESC;

-- Which customer type buys the most?
SELECT
	customer_type,
    COUNT(*)
FROM sales
GROUP BY customer_type;


-- What is the gender of most of the customers?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sales
GROUP BY gender
ORDER BY gender_cnt DESC;

-- What is the gender distribution per branch?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sales
WHERE branch = "C"
GROUP BY gender
ORDER BY gender_cnt DESC;
-- Gender per branch is more or less the same hence, I don't think has
-- an effect of the sales per branch and other factors.

-- Which time of the day do customers give most ratings?
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;
-- Looks like time of the day does not really affect the rating, its
-- more or less the same rating each time of the day.alter


-- Which time of the day do customers give most ratings per branch?
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM sales
WHERE branch = "A"
GROUP BY time_of_day
ORDER BY avg_rating DESC;
-- Branch A and C are doing well in ratings, branch B needs to do a 
-- little more to get better ratings.


-- Which day fo the week has the best avg ratings?
SELECT
	day_name,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name 
ORDER BY avg_rating DESC;
-- Mon, Tue and Friday are the top best days for good ratings
-- why is that the case, how many sales are made on these days?



-- Which day of the week has the best average ratings per branch?
SELECT 
	day_name,
	COUNT(day_name) total_sales
FROM sales
WHERE branch = "C"
GROUP BY day_name
ORDER BY total_sales DESC;




  