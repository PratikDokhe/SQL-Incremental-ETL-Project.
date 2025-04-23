
create or alter procedure target.load_target as 

BEGIN
	
	print '##################################################################'

	print ' ---------------- Loading Data into Stage tables ----------------'

	print '##################################################################'

	---- ###### Customers table ########
	print '----------------------------------------------------------------'
	print 'creating temp table of cleaned customer table'

	IF OBJECT_ID('tempdb..#cleaned_customers') IS NOT NULL
		DROP TABLE #cleaned_customers;

	select 
		customer_id,
		first_name,
		last_name,
		email,
		signup_date,
		status
	into #cleaned_customers
	from (
		select
			sc.customer_id,
			sc.first_name,
			coalesce(sc.last_name,'') as last_name,
			coalesce(sc.email,'') as email,

			Coalesce(TRY_CONVERT(DATE,sc.signup_date,105) , TRY_CONVERT(DATE,sc.signup_date,120)) as signup_date,

			lower(substring(sc.status,1,charindex(',',sc.status)-1)) as status,
			row_number() over(partition by sc.customer_id order by signup_date desc) as r
		from stage.customers sc where lower(substring(sc.status,1,charindex(',',sc.status)-1))='active'
	)t where r=1 

	print '--------------------------------------'
	print 'Inserting only new records'
	insert into target.customers(
		customer_id,
		first_name,
		last_name,
		email,
		signup_date,
		status
	)

	select 
		sc.customer_id,
		sc.first_name,
		sc.last_name,
		sc.email,
		sc.signup_date,
		sc.status

	from #cleaned_customers sc
	left join target.customers tc on sc.customer_id=tc.customer_id 
	where tc.customer_id is null;


	print '---------------------------------------------------------'
	print 'updating records if any new info is updated' 
	update tc 
	set 
		tc.first_name = sc.first_name,
		tc.last_name = sc.last_name,
		tc.email = sc.email,
		tc.signup_date = sc.signup_date,
		tc.status =sc.status

	from target.customers tc 
	join #cleaned_customers sc on tc.customer_id=sc.customer_id
	where 
		coalesce(tc.first_name,'') != coalesce(sc.first_name,'') or
		coalesce(tc.last_name,'') != coalesce(sc.last_name,'') or
		coalesce(tc.email,'') != coalesce(sc.email,'') or
		coalesce(tc.signup_date,'') != coalesce(sc.signup_date,'') or
		coalesce(tc.status,'') != coalesce(sc.status,'') 




	-- ###### Products table ########
	print '------------------------------------------------------------'
	print 'creating temp table of cleaned products table'
	IF OBJECT_ID('tempdb..#cleaned_products') IS NOT NULL
		DROP TABLE #cleaned_products;

	select 
		product_id,
		trim(name) as name,
		coalesce(category,'') as category,
		coalesce(TRY_CONVERT(FLOAT,price),-1) as price, -- setting -1 for null records
		case 
			when lower(discontinued) = 'yes' then 'Y'
			when lower(discontinued) = 'no' then 'N'
			else discontinued
		end as discontinued
	into #cleaned_products
	from stage.products;

	print '----------------------------------------------------'
	print 'Inserting only new records'

	insert into target.products(
		product_id,
		name,
		category,
		price,
		discontinued
	)

	select 
		sp.product_id,
		sp.name,
		sp.category,
		sp.price,
		sp.discontinued
	from #cleaned_products as sp
	left join target.products tp on sp.product_id=tp.product_id
	where tp.product_id is null;

	print '--------------------------------------------------------------'
	print 'updating records if any new info is updated '

	update tp

	set 

		tp.name = sp.name,
		tp.category = sp.category,
		tp.price = sp.price,
		tp.discontinued = sp.discontinued

	from target.products tp
	join #cleaned_products sp on tp.product_id=sp.product_id
	where 
		coalesce(tp.name,'') != coalesce(sp.name,'') or
		coalesce(tp.category,'') != coalesce(sp.category,'') or
		coalesce(tp.price,'') != coalesce(sp.price,'') or
		coalesce(tp.discontinued,'') != coalesce(sp.discontinued,'');


	---- ###### Orders table ########
	print '--------------------------------------------------------------'
	print 'creating temp table of cleaned orders table'

	IF OBJECT_ID('tempdb..#cleaned_orders') IS NOT NULL
		DROP TABLE #cleaned_orders;

	select 
		order_id,
		customer_id,
		product_id,
		try_convert(DATE,order_date,105) as order_date,
		case 
			when quantity<0 then quantity * -1
			else quantity
		end as quantity,
		case 
			when total_amount<0 then total_amount * -1
			else total_amount
		end as total_amount
	into #cleaned_orders
	from stage.orders;



	print '------------------------------------------------------------------'
	print 'Inserting only new records:'

	insert into target.orders (
	order_id,
	customer_id,
	product_id,
	order_date,
	quantity,
	total_amount
	)

	select 
		so.order_id,
		so.customer_id,
		so.product_id,
		so.order_date,
		so.quantity,
		so.total_amount
	from #cleaned_orders so
	left join target.orders tao on so.order_id = tao.order_id
	where tao.order_id is null

	print '--------------------------------------------------------'
	print 'updating records if any new info is updated '

	update tao
	set

		tao.customer_id = so.customer_id,
		tao.product_id = so.product_id,
		tao.order_date = so.order_date,
		tao.quantity = so.quantity,
		tao.total_amount = so.total_amount
	from target.orders tao 
	join #cleaned_orders so on tao.order_id=so.order_id
	where 
		coalesce(tao.customer_id,'') != coalesce(so.customer_id,'') or 
		coalesce(tao.product_id,'') != coalesce(so.product_id,'') or
		coalesce(tao.order_date,'') != coalesce(so.order_date,'') or
		coalesce(tao.quantity,'') != coalesce(so.quantity,'') or
		coalesce(tao.total_amount,'') != coalesce(so.total_amount,'')

	print '-----------------------------------------------------------------------'

END


--exec target.load_target;

-- hit and tries: 

--case 
--	when charindex('-',sc.signup_date) = 5 then case 
--													when substring(sc.signup_date,6,7)<= 12 and substring(sc.signup_date,9,10)<=31 then 'temp'
--													else ''
--													end
--	else sc.signup_date
--end as signup_date2,
--cast(sc.signup_date as date),



--select * from #cleaned_customers;


--truncate table target.customers;
