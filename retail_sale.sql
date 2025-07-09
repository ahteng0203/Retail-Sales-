-- Create table 
DROP TABLE IF EXISTS retail_sales;
Create table retail_sales
(
	transactions_id	INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,	
	customer_id	INT,
	gender VARCHAR(15),	
	age	INT,
	category VARCHAR(15),	
	quantiy	INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);





select count(*) from retail_sales limit 10;

-- check null value/ Data cleaning 
select * from retail_sales where transactions_id is null or sale_date is null 
or sale_time is null or customer_id	is null or gender is null
or category is null or quantiy	is null or price_per_unit is null or cogs is null 
or total_sale is null; 

delete from retail_sales
where transactions_id is null or sale_date is null 
or sale_time is null or customer_id	is null or gender is null
or category is null or quantiy	is null or price_per_unit is null or cogs is null 
or total_sale is null; 

-- Data Exploration
--How many customer we have 
select count(distinct customer_id) from retail_sales;
select distinct category from retail_sales;

-- Data analysis & Business key questions & Answers
--1.Write a SQL query to retrieve all columns for sales made on '2022-11-05'
select * from retail_sales where sale_date ='2022-11-05' order by transactions_id;

--2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
select * from retail_sales where category='Clothing' and quantiy>= 4 
and sale_date between '2022-11-01' and '2022-11-30';


--3.Write a SQL query to calculate the total sales (total_sale) for each category.
select category,sum(total_sale) as total_sales,count(*) as total_orders from retail_sales
group by 1;

--4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
select round(avg(age)) from retail_sales
where category='Beauty';


--5.Write a SQL query to find all transactions where the total_sale is greater than 1000
select * from retail_sales where total_sale >1000;


--6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category
select gender,category,count(transactions_id) from retail_sales
group by 1,2;

--7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select year,month,avg_sale from
(select extract(year from sale_date) as year,
extract(month from sale_date) as month,
round(avg(total_sale)) as avg_sale,
RANK() Over(partition by extract(year from sale_date) order by round(avg(total_sale)) desc) as rank 
from retail_sales
group by 1,2
order by 1,2) where rank =1;

WITH monthly_sales AS (
  SELECT 
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    ROUND(AVG(total_sale)) AS avg_sale,
    RANK() OVER (
      PARTITION BY EXTRACT(YEAR FROM sale_date)
      ORDER BY ROUND(AVG(total_sale)) DESC
    ) AS rank
  FROM retail_sales
  GROUP BY 1, 2
)

SELECT year,month,avg_sale
FROM monthly_sales
WHERE rank = 1
ORDER BY year;


--8.Write a SQL query to find the top 5 customers based on the highest total sales
with high_total_sales AS (
select customer_id,sum(total_sale) as total_sales,
RANK() OVER(order by sum(total_sale)desc ) as rank 
from retail_sales group by 1 )

SELECT customer_id,total_sales
from high_total_sales where rank in (1,2,3,4,5) order by 2 desc;

select customer_id, sum(total_sale) as total_sales from retail_sales
group by 1 order by 2 desc limit 5;

--9.Write a SQL query to find the number of unique customers who purchased items from each category
select category, count(distinct customer_id ) from retail_sales
group by 1;

--10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
select case 
when EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
when EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
Else 'Evening' end AS time_of_day , count(*)
from retail_sales 
group by 1  ;


