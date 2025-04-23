/*

=======================================================================
DDL Script: Create Target Tables
=======================================================================

*/






IF OBJECT_ID ('target.customers','U') IS NOT NULL
	DROP TABLE target.customers;

create table target.customers (
customer_id NVARCHAR(50),
first_name NVARCHAR(50),
last_name NVARCHAR(50),
email NVARCHAR(50),
signup_date DATE,
status NVARCHAR(50),

);


IF OBJECT_ID ('target.products','U') IS NOT NULL
	DROP TABLE target.products;

create table target.products (
product_id NVARCHAR(50),
name NVARCHAR(50),
category NVARCHAR(50),
price FLOAT,
discontinued NVARCHAR(50),


)

IF OBJECT_ID ('target.orders','U') IS NOT NULL
	DROP TABLE target.orders;

create table target.orders(
order_id NVARCHAR(50),
customer_id NVARCHAR(50),
product_id NVARCHAR(50),
order_date DATE,
quantity INT,
total_amount INT,


)
