/*

===================================================================================================
Stored Procedure: Load Stage Layer (Source -> Bronze)
===================================================================================================

Script Purpose:

- This Procedure loads data into 'stage' schema from external CSV files (Source).
- Truncates the stage tables before loading data.
- Uses 'BULK INSERT' command.

----------------------------------
To Run: EXEC stage.load_stage;
---------------------------------
*/



CREATE OR ALTER PROCEDURE stage.load_stage AS

BEGIN
	print '##################################################################'

	print ' ---------------- Loading Data into Stage tables ----------------'

	print '##################################################################'

	print 'Truncating table: stage.customers'
	TRUNCATE table stage.customers;

	print 'Inserting Data into table: stage.customers'
	BULK INSERT stage.customers
	from 'K:\Learning 2024\SQL\SQL Projects\ChatGPT ETL Incremental Load Project\Source Files\customers.csv'
	with(
				firstrow=2,
				fieldterminator=',',
				--ROWTERMINATOR   = '\r\n',
				--CODEPAGE        = '65001',
				--DATAFILETYPE    = 'char',
				tablock
	);

	print '----------------------------------------------------------------------------'
	print 'Truncating table: stage.orders'
	TRUNCATE table stage.orders;

	print 'Inserting Data into table: stage.orders'

	BULK INSERT stage.orders
	from 'K:\Learning 2024\SQL\SQL Projects\ChatGPT ETL Incremental Load Project\Source Files\orders.csv'
	with (
	firstrow=2,
	fieldterminator=',',
	tablock
	);


	print '----------------------------------------------------------------------------'
	print 'Truncating table: stage.products'
	TRUNCATE table stage.products;

	print 'Inserting Data into table: stage.products'
	BULK INSERT stage.products
	from 'K:\Learning 2024\SQL\SQL Projects\ChatGPT ETL Incremental Load Project\Source Files\products.csv'
	with(
	firstrow=2,
	fieldterminator=',',
	tablock
	);

END



--exec stage.load_stage;
