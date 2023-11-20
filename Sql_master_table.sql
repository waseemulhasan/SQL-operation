show databases;
use analyst;

## creating customer table along with constraint
CREATE table if not exists MW_CUSTOMER_NAME
(
Customer_Index int PRIMARY KEY,
Customer_Names varchar(40));

## creating Region table along with constraint
CREATE table if not exists MW_REGIONS
(
Region_index int PRIMARY KEY,
City varchar(30),
Country varchar(30)
);

## creating Products table along with constraint
CREATE table if not exists MW_PRODUCTS
(
Product_index int PRIMARY KEY,
Product_Name varchar(40)
);

## creating Sales Order table along with constraint
CREATE TABLE IF NOT EXISTS MW_SALES
(
ORDERNUMBER VARCHAR (15),
ORDERDATE VARCHAR(20),
CUSTOMER_INDEX INT,
CHANNEL VARCHAR (15),
WAREHOUSE_CODE VARCHAR (15),
DELIVERY_REGION_INDEX INT NOT NULL,
PRODUCT_INDEX INT ,
ORDER_QTY INT,
UNIT_PRICE_USD decimal(7,2),
TOTAL_REVENUE_USD decimal (7,2), 
TOTAL_UNITS_COST decimal (7,2),
FOREIGN KEY(PRODUCT_INDEX) REFERENCES MW_PRODUCTS(Product_index)
); 

##loading data into customer table
Load data infile
'C:/customer.csv'
into table MW_CUSTOMER_NAME
fields terminated by ','
enclosed by '"'
lines terminated by'\n'
ignore 1 rows;

## Loading data into Regions Table
load data infile
'C:/regions.csv'
into table MW_REGIONS
fields terminated by','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

## Loading data into Products table
Load data infile
'C:/products.csv'
into table MW_PRODUCTS
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

## Loading data into Sales Order table
LOAD DATA INFILE
'C:/sales_order.csv'
into table MW_SALES
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY'\n'
IGNORE 1 ROWS;

Select * from MW_CUSTOMER_NAME;
Select * from MW_PRODUCTS;
Select * from MW_REGIONS;
Select * from MW_SALES;

##Creating view along with joins
Create or replace view MW_MASTER_TABLE AS
select A.*,B.Product_Name,C.City, C.Country, D.Customer_Names 
from MW_SALES A
inner join MW_PRODUCTS B ON A.PRODUCT_INDEX= B.Product_index
inner join MW_REGIONS C ON A.DELIVERY_REGION_INDEX = C.Region_index
inner join MW_CUSTOMER_NAME D ON A.CUSTOMER_INDEX = D.Customer_Index;

SELECT * FROM MW_MASTER_TABLE WHERE CUSTOMER_INDEX = 'NULL';

SELECT CHANNEL, COUNT(ORDERNUMBER) FROM MW_MASTER_TABLE
	group by 1
    order by 1;

##Using concentination to merge 2 columns
select concat('city', ' , ', country) as Full_Name from MW_MASTER_TABLE;











