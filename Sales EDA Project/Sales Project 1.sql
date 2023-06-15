-- Inspecting Data
SELECT * FROM sales_project1.sales_data_sample;

-- Checking Unique Values
SELECT DISTINCT STATUS FROM sales_project1.sales_data_sample;
SELECT DISTINCT YEAR_ID FROM sales_project1.sales_data_sample;
SELECT DISTINCT PRODUCTLINE FROM sales_project1.sales_data_sample;
SELECT DISTINCT COUNTRY FROM sales_project1.sales_data_sample;
SELECT DISTINCT TERRITORY FROM sales_project1.sales_data_sample;
SELECT DISTINCT DEALSIZE FROM sales_project1.sales_data_sample;

-- Analysis
-- grouping by productline
SELECT productline, SUM(sales) Revenue
FROM sales_project1.sales_data_sample
GROUP BY productline
ORDER BY 2 DESC;

SELECT DISTINCT MONTH_ID 
FROM sales_project1.sales_data_sample
WHERE YEAR_ID = 2005;

-- grouping by year_id
SELECT YEAR_ID, SUM(sales) Revenue
FROM sales_project1.sales_data_sample
GROUP BY YEAR_ID
ORDER BY 2 DESC;

-- grouping by dealsize
SELECT DEALSIZE, SUM(sales) Revenue
FROM sales_project1.sales_data_sample
GROUP BY DEALSIZE
ORDER BY 2 DESC;

-- best month for sales in a specific year? how much earned that much?
SELECT MONTH_ID, SUM(sales) Revenue, COUNT(ORDERNUMBER) Frequency
FROM sales_project1.sales_data_sample
WHERE YEAR_ID = 2005 -- change year to see the rest
GROUP BY MONTH_ID
ORDER BY 2 DESC;

-- November seems to be best month; what product do they sell in November?
SELECT MONTH_ID, productline, SUM(sales) Revenue, COUNT(ORDERNUMBER) Frequency
FROM sales_project1.sales_data_sample
WHERE YEAR_ID = 2003 and MONTH_ID = 11 -- change year to see the rest
GROUP BY MONTH_ID, productline
ORDER BY 3 DESC;

-- Who is our best customer?
SELECT 
     CUSTOMERNAME,
     SUM(SALES) MonetaryValue,
     AVG(SALES) AvgMonetaryValue,
     count(ORDERNUMBER) Frequency,
     max(ORDERDATE) LastOrderDate,
     (SELECT max(ORDERDATE) FROM sales_project1.sales_data_sample) MaxOrderDate
	 -- DATEDIFF (max(ORDERDATE),(SELECT max(ORDERDATE) FROM sales_project1.sales_data_sample)) Recency
FROM sales_project1.sales_data_sample
GROUP BY customername
ORDER BY MonetaryValue desc;

-- what product most often sold together?

SELECT DISTINCT productcode
FROM sales_project1.sales_data_sample
WHERE ORDERNUMBER IN
	(
	SELECT ORDERNUMBER
	from(
	   SELECT ORDERNUMBER, COUNT(*) rn
	   FROM sales_project1.sales_data_sample
	   WHERE STATUS= 'shipped' 
	   GROUP BY ORDERNUMBER
	) m 
	WHERE rn=2
	)

