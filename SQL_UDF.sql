create database Sales_data;  #(create database sales)
use Sales_data;

#creating a table 
CREATE TABLE sales (
	order_id VARCHAR(15) NOT NULL, 
	order_date VARCHAR(15) NOT NULL, 
	ship_date VARCHAR(15) NOT NULL, 
	ship_mode VARCHAR(14) NOT NULL, 
	customer_name VARCHAR(22) NOT NULL, 
	segment VARCHAR(11) NOT NULL, 
	state VARCHAR(36) NOT NULL, 
	country VARCHAR(32) NOT NULL, 
	market VARCHAR(6) NOT NULL, 
	region VARCHAR(14) NOT NULL, 
	product_id VARCHAR(16) NOT NULL, 
	category VARCHAR(15) NOT NULL, 
	sub_category VARCHAR(11) NOT NULL, 
	product_name VARCHAR(127) NOT NULL, 
	sales DECIMAL(38, 0) NOT NULL, 
	quantity DECIMAL(38, 0) NOT NULL, 
	discount DECIMAL(38, 3) NOT NULL, 
	profit DECIMAL(38, 8) NOT NULL, 
	shipping_cost DECIMAL(38, 2) NOT NULL, 
	order_priority VARCHAR(8) NOT NULL, 
	`year` DECIMAL(38, 0) NOT NULL
);
Select * from sales;
SET SESSION sql_mode = '';
# Loading data into a sales table
load data infile
'C:/sales_data_final.csv'
into table sales
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select * from sales;  #(sucessfully dump data into a sales table)

##Adding the order_date new column into a exist table with data datatype
alter table sales
add column order_date_new date after order_date;

##Adding the ship_date new column into a exist table with data datatype
alter table sales
add column ship_date_new date after ship_date;
SET SQL_SAFE_UPDATES = 0;

## Updating correct datatype into a order_date_new column with the help of existing column
update sales
set order_date_new = str_to_date(order_date,'%m/%d/%Y');
## Updating correct datatype into a ship_date_new column with the help of existing column
update sales
set ship_date_new = str_to_date(ship_date, '%m/%d/%Y');

select * from sales;

##Using where & between clause 
select * from sales where ship_date_new = '2011-01-05';
select * from sales where ship_date_new > '2011-01-05';
select * from sales where ship_date_new < '2011-01-05';
select * from sales where ship_date_new between '2011-01-05' and '2011-08-30';

##To know our present time along with date
select now();

select * from sales where ship_date_new < date_sub(now() , interval 1 week);
##Adding a new column into a sales table
alter table sales
add column flag date after order_id;

##Updating current date into flag column
update sales
set flag = now();

Select * from sales;
## Adding a new column into a sales table
alter table sales
add column Year_New int;
## Adding a new column into a sales table
alter table sales
add column Month_New int;
## Adding a new column into a sales table
alter table sales
add column Day_New int;

select * from sales limit 5;

update sales
set Month_new= month(order_date_new);
update sales
set Day_new= day(order_date_new);
update sales
set Year_New= year(order_date_new);

## Average sales by distinct year
select year, avg(sales) from sales group by Year_New;
select year, avg(quantity) from sales group by Year_New;

select (sales*discount+shipping_cost) as ctc from sales;
select order_id ,discount , if(discount > 0 ,'yes' , 'no') as discount_flag from sales;
## Adding a new column right after discount
alter table sales
add column discount_flag varchar(20) after discount;
## Updating data into a new colum using 'if' function
update sales
set discount_flag = if(discount > 0, 'yes', 'no');
select * from sales limit 4;

select discount_flag, count(discount_flag) from sales group by discount_flag;

##Creating customize fuction
DELIMITER &&
create function Final_Profits(profit decimal(20,6), discount decimal(20,6), sales decimal(20,6))
returns int
deterministic
begin
declare final_profit int;
set final_profit = profit-sales*discount;
return final_profit;
end &&

select profit, discount, Final_Profits(profit, discount,sales) from sales order by profit;

##Creating User define Function wiht Using IF and ELSEIF conditions into sales column
delimiter &&
create function	sales_tag(sales int)
returns varchar(30)
deterministic
begin
declare sales_price_tag varchar(30);
if sales <= 100 then
		set sales_price_tag = "super affordable product";
elseif sales >100 and sales <= 300 then
		set sales_price_tag = "affordable product";
elseif sales < 300 and sales >= 600 then
		set sales_price_tag = "moderate product";
else 
		set sales_price_tag = "expensive";
end if;
return sales_price_tag;
end &&

select sales,sales_tag(sales) from sales;











