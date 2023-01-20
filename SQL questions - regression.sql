# SQL questions - regression
# 1. Create a database called house_price_regression.
create database if not exists house_price_regression;
use house_price_regression;
# 2. Create a table house_price_data with the same columns as given in the csv file. Please make sure you use the correct data types for the columns.
create table house_price_data (
	`id` bigint not null,
    `date` text,
    `bedrooms` int,
    `bathrooms` decimal,
    `sqft_living` int,
    `sqft_lot` int,
    `floors` decimal,
    `waterfront` int,
    `view` int,
    `condition` int,
    `grade` int,
    `sqft_above` int,
    `sqft_basement` int,
    `yr_built` int,
    `yr_renovated` int,
    `zipcode` int,
    `lat` float,
    `long` float,
    `sqft_living15` int,
    `sqft_lot15` int,
    `price` int
    );
    select * from house_price_data;
    # 3. Import the data from the csv file into the table
SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';

load data local infile '/Users/usuari/Desktop/DATA ANALYTICS/Mid Project/data_mid_bootcamp_project_regression/regression_data.csv'
into table house_price_data fields terminated BY ','  lines terminated by '\n'
(`id`,`date`,`bedrooms`,`bathrooms`,`sqft_living`,`sqft_lot`,`floors`,`waterfront`,`view`,`condition`,`grade`,
    `sqft_above`,`sqft_basement`,`yr_built`,`yr_renovated`,`zipcode`,`lat`,`long`,`sqft_living15`,`sqft_lot15`,`price`);

# 4. Select all the data from table house_price_data to check if the data was imported correctly
    
select * from house_price_data;

# 5. Use the alter table command to drop the column date from the database, as we would not use it in the analysis with SQL. Select all the data from the table to verify if the command worked. Limit your returned results to 10.

alter table house_price_data
drop column date;

select * from house_price_data limit 10;

#6. Use sql query to find how many rows of data you have.
select count(*) from house_price_data; #The data have 21597 rows

# 7. Now we will try to find the unique values in some of the categorical columns:

# What are the unique values in the column bedrooms?
select distinct(bedrooms), count(id) as quantity_houses
from house_price_data group by bedrooms order by quantity_houses;

#What are the unique values in the column bathrooms?
select distinct(bathrooms), count(id) as quantity_houses
from house_price_data group by bathrooms order by quantity_houses;

#What are the unique values in the column floors?
select distinct(floors) from house_price_data order by floors;
select distinct(floors), count(id) as quantity_houses
from house_price_data group by floors order by quantity_houses;

#What are the unique values in the column condition?
select distinct(`condition`) from house_price_data order by `condition`;
select distinct(`condition`), count(id) as quantity_houses, round(avg(price), 0) as avg_price
from house_price_data group by `condition` order by avg_price asc;

#What are the unique values in the column grade?
select distinct(grade) from house_price_data order by grade;
select distinct(grade), count(id) as quantity_houses, round(avg(price), 0) as avg_price
from house_price_data group by grade order by avg_price asc;

# 8.Arrange the data in a decreasing order by the price of the house. Return only the IDs of the top 10 most expensive houses in your data.
select id, price from house_price_data order by price desc limit 10;

#9.What is the average price of all the properties in your data?
select round(avg(price),0) as avg_price from house_price_data; # The average price is 540.297

#10. In this exercise we will use simple group by to check the properties of some of the categorical variables in our data

#What is the average price of the houses grouped by bedrooms? The returned result should have only two columns, bedrooms and Average of the prices. Use an alias to change the name of the second column.
select distinct(bedrooms), round(avg(price),0) as avg_price from house_price_data group by bedrooms order by avg_price;

#What is the average sqft_living of the houses grouped by bedrooms? The returned result should have only two columns, bedrooms and Average of the sqft_living. Use an alias to change the name of the second column.
select bedrooms, round(avg(sqft_living),0) as avg_sqft_living from house_price_data group by bedrooms order by avg_sqft_living;

#What is the average price of the houses with a waterfront and without a waterfront? The returned result should have only two columns, waterfront and Average of the prices. Use an alias to change the name of the second column.
select waterfront, round(avg(price),0) as avg_price from house_price_data group by waterfront order by avg_price;

# Is there any correlation between the columns condition and grade? You can analyse this by grouping the data by one of the variables and then aggregating the results of the other column. Visually check if there is a positive correlation or negative correlation or no correlation between the variables.
#condition with avg_grade seems to have a correlation, since both ascende.  
#The second query doesnt show a correlation between grade and avg_condition.alter

#11. One of the customers is only interested in the following houses. Write a simple query to find what are the options available for them?
select * from house_price_data where bedrooms in (3,4) and bathrooms > 3 and floors = 1 and waterfront = 0 and `condition`>= 3 and grade >= 5 and price < 300000 order by price asc;
# Unfortunately we dont have a house with that exact conditions to show the client,  if the client accept house with less or 3 bathrooms, we have 53 options

#12. Your manager wants to find out the list of properties whose prices are twice more than the average of all the properties in the database. Write a query to show them the list of such properties. You might need to use a sub query for this problem.
select id,price from house_price_data where price > (select (avg(price) * 2) from house_price_data) order by price asc;

#13.Since this is something that the senior management is regularly interested in, create a view of the same query.alter
create view outliers_avgprice_houses as (select id, price from house_price_data where price > (select (avg(price) * 2) from house_price_data));
select * from outliers_avgprice_houses;

# 14. Most customers are interested in properties with three or four bedrooms. What is the difference in average prices of the properties with three and four bedrooms?
select round((avg(four.price) - avg(three.price)),2) as diff_avgprice from house_price_data as three
cross join house_price_data as four
where three.bedrooms = 3 and four.bedrooms = 4 group by four.bedrooms; # the difference from the price is considerable high from 3 to 4 bedrooms

#15. What are the different locations where properties are available in your database? (distinct zip codes)
select distinct(zipcode) as zones from house_price_data;

#16. Show the list of all the properties that were renovated.
select id, yr_renovated, bedrooms, bathrooms, grade, `condition`, zipcode, price from house_price_data where yr_renovated != 0 order by price asc;

# 17. Provide the details of the property that is the 11th most expensive property in your database.
select * from (select *, rank() over (order by price desc) as ranking from house_price_data) as ranked_table where ranking = 11;



