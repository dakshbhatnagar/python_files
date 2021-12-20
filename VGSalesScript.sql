-- Checking what the datatypes are for the each column in our dataset
desc sales;

-- Seeing what our table looks like
SELECT 
    *
FROM
    sales;

-- Seeing if there are any null values in our data
Select * from sales where Year is null;
Select * from sales where genre is null;
select * from sales where NA_Sales is null;
select * from sales where Global_Sales is null;

-- No null values would mean no cleaning is too be done. Lets start with writing some queries and see the data in action

-- Top 10 records ordering by Global Sales
SELECT 
    *
FROM
    sales
ORDER BY Global_Sales DESC
LIMIT 10; 

-- Finding out which top 10 publisher bagged most sales
SELECT 
    *
FROM
    sales
GROUP BY Publisher
ORDER BY Global_Sales DESC
LIMIT 10; 

-- Finding out top 10 years that got the most sales (in descending order)
SELECT 
    *
FROM
    sales
GROUP BY year
ORDER BY Global_Sales DESC
LIMIT 10; 

-- Finding Out which market contributes how much to the global sales
SELECT 
    name,
    Platform,
    Year,
    Genre,
    publisher,
    ROUND((NA_Sales / Global_Sales) * 100, 2) AS NA_Rounded,
    ROUND((EU_Sales / Global_Sales) * 100, 2) AS EU_Rounded,
    ROUND((JP_Sales / Global_Sales) * 100, 2) AS Japan_Rounded,
    ROUND((Other_Sales / Global_Sales) * 100, 2) AS Other_Rounded,
    Global_Sales
FROM
    sales;

-- Top 5 genre based on Global Sales
SELECT 
    *
FROM
    sales
GROUP BY genre
ORDER BY global_sales DESC
LIMIT 5;

-- Top Genre in descending order (based on Global Sales)
SELECT 
    genre, 
    COUNT(year) AS RecordsCount, 
    Global_Sales
FROM
    sales
GROUP BY genre
ORDER BY RecordsCount DESC;