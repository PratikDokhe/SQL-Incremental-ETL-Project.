/*
----------------------------------
Validaty checks Target tables: 
Verified data loaded successfully or not
---------------------------------
*/

--Step 1 : Manually inserted new records in CSV file customers and products
-- Step 2: Updated one record in orders table
		


--Loading stage tables:
exec stage.load_stage;


-- loading target tables: 
exec target.load_target;




/*
----------------------------------
-- >>> Output message after execution <<

##################################################################
 ---------------- Loading Data into Target tables ----------------
##################################################################
----------------------------------------------------------------
creating temp table of cleaned customer table

(5 rows affected)
--------------------------------------
Inserting only new records

(1 row affected)
---------------------------------------------------------
updating records if any new info is updated

(0 rows affected)
------------------------------------------------------------
creating temp table of cleaned products table

(6 rows affected)
----------------------------------------------------
Inserting only new records

(1 row affected)
--------------------------------------------------------------
updating records if any new info is updated 

(0 rows affected)
--------------------------------------------------------------
creating temp table of cleaned orders table

(6 rows affected)
------------------------------------------------------------------
Inserting only new records:

(0 rows affected)
--------------------------------------------------------
updating records if any new info is updated 

(1 row affected)
-----------------------------------------------------------------------

Completion time: 2025-04-23T16:14:10.8523083+05:30

---------------------------------
*/
