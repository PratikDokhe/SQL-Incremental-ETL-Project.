/*

=======================================================================
DDL Script: Create Stage Tables
=======================================================================

*/


IF OBJECT_ID ('stage.customers','U') IS NOT NULL
	DROP TABLE stage.customers;

create table stage.customers (
customer_id NVARCHAR(50),
first_name NVARCHAR(50),
last_name NVARCHAR(50),
email NVARCHAR(50),
signup_date NVARCHAR(50),
status NVARCHAR(50),

);


IF OBJECT_ID ('stage.products','U') IS NOT NULL
	DROP TABLE stage.products;

create table stage.products (
product_id NVARCHAR(50),
name NVARCHAR(50),
category NVARCHAR(50),
price NVARCHAR(50),
discontinued NVARCHAR(50),


)

IF OBJECT_ID ('stage.orders','U') IS NOT NULL
	DROP TABLE stage.orders;

create table stage.orders(
order_id NVARCHAR(50),
customer_id NVARCHAR(50),
product_id NVARCHAR(50),
order_date NVARCHAR(50),
quantity NVARCHAR(50),
total_amount NVARCHAR(50),


)
