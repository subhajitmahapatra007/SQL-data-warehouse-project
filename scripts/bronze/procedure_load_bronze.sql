/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @batch_start_time DATETIME, @batch_end_time DATETIME,@start_time DATETIME,
		@end_time DATETIME
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '================================================';
		PRINT '              Loading Bronze Layer';
		PRINT '================================================';

		PRINT '   --------------------';
		PRINT '   Loading CRM Tables';
		PRINT '   --------------------';

		SET @start_time = GETDATE();
		PRINT '      --------------------------------------'
		PRINT '      >> Truncating Table: bronze.crm_cust_info'
		PRINT '      --------------------------------------'
		TRUNCATE TABLE bronze.crm_cust_info
		PRINT '      --------------------------------------'
		PRINT '      >> Inserting Data Into: bronze.crm_cust_info';
		PRINT '      --------------------------------------'
		BULK INSERT bronze.crm_cust_info
		FROM 'D:\Subhajit-DataScience\SQL\Data_with_Barra\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		)
		SET @end_time = GETDATE();
		PRINT '=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'
		PRINT 'Table Loading Time' + CAST(DATEDIFF(second,@start_time,@end_time)AS NVARCHAR) + 'second'
		PRINT '=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'

		SET @start_time = GETDATE();
		PRINT '      --------------------------------------'
		PRINT '      >> Truncating Table: bronze.crm_prd_info'
		PRINT '      --------------------------------------'
		TRUNCATE TABLE bronze.crm_prd_info
		PRINT '      --------------------------------------'
		PRINT '      >> Inserting Data Into: bronze.crm_prd_info';
		PRINT '      --------------------------------------'
		BULK INSERT bronze.crm_prd_info
		FROM 'D:\Subhajit-DataScience\SQL\Data_with_Barra\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		)
		SET @end_time = GETDATE();
		PRINT '=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'
		PRINT 'Table Loading Time' + CAST(DATEDIFF(second,@start_time,@end_time)AS NVARCHAR) + 'second'
		PRINT '=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'

		SET @start_time = GETDATE();
		PRINT '      --------------------------------------'
		PRINT '      >> Truncating Table: bronze.crm_prd_info'
		PRINT '      --------------------------------------'
		TRUNCATE TABLE bronze.crm_sales_details
		PRINT '      --------------------------------------'
		PRINT '      >> Inserting Data Into: bronze.crm_prd_info';
		PRINT '      --------------------------------------'
		BULK INSERT bronze.crm_sales_details
		FROM 'D:\Subhajit-DataScience\SQL\Data_with_Barra\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		)
		SET @end_time = GETDATE();
		PRINT '=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'
		PRINT 'Table Loading Time' + CAST(DATEDIFF(second,@start_time,@end_time)AS NVARCHAR) + 'second'
		PRINT '=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'


		PRINT '   ---------------------';
		PRINT '    Loading ERP Tables';
		PRINT '   ---------------------';

		SET @start_time = GETDATE();
		PRINT '      ----------------------------------------'
		PRINT '      >> Truncating Table: bronze.erp_cust_az12'
		PRINT '      ----------------------------------------'
		TRUNCATE TABLE bronze.erp_cust_az12
		PRINT '      --------------------------------------'
		PRINT '      >> Inserting Data Into: bronze.erp_cust_az12';
		PRINT '      --------------------------------------'
		BULK INSERT bronze.erp_cust_az12
		FROM 'D:\Subhajit-DataScience\SQL\Data_with_Barra\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		)
		SET @end_time = GETDATE();
		PRINT '=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'
		PRINT 'Table Loading Time' + CAST(DATEDIFF(second,@start_time,@end_time)AS NVARCHAR) + 'second'
		PRINT '=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'

		SET @start_time = GETDATE();
		PRINT '      --------------------------------------'
		PRINT '      >> Truncating Table: bronze.erp_loc_a101'
		PRINT '      --------------------------------------'
		TRUNCATE TABLE bronze.erp_loc_a101
		PRINT '      --------------------------------------'
		PRINT '      >> Inserting Data Into: bronze.erp_loc_a101';
		PRINT '      --------------------------------------'
		BULK INSERT bronze.erp_loc_a101
		FROM 'D:\Subhajit-DataScience\SQL\Data_with_Barra\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		)
		SET @end_time = GETDATE();
		PRINT '=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'
		PRINT 'Table Loading Time' + CAST(DATEDIFF(second,@start_time,@end_time)AS NVARCHAR) + 'second'
		PRINT '=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'

		SET @start_time = GETDATE();
		PRINT '      --------------------------------------'
		PRINT '      >> Truncating Table: bronze.erp_px_cat_g1v2'
		PRINT '      --------------------------------------'
		TRUNCATE TABLE bronze.erp_px_cat_g1v2
		PRINT '      --------------------------------------'
		PRINT '      >> Inserting Data Into: bronze.erp_px_cat_g1v2';
		PRINT '      --------------------------------------'
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'D:\Subhajit-DataScience\SQL\Data_with_Barra\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		)
		SET @end_time = GETDATE();
		PRINT '=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'
		PRINT 'Table Loading Time' + CAST(DATEDIFF(second,@start_time,@end_time)AS NVARCHAR) + 'second'
		PRINT '=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'


	SET @batch_end_time = GETDATE();
	PRINT '=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'
	PRINT 'Loading Bronze Layer is completed'
	PRINT ' Total Loading Time' + CAST(DATEDIFF(second,@batch_start_time,@batch_end_time)AS NVARCHAR) + 'second'
	PRINT '=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'
	END TRY
	BEGIN CATCH
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT 'ERROR MESSAGE' + ERROR_MESSAGE();
		PRINT 'ERROR NUMBER' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'ERROR STATE' + CAST(ERROR_State() AS NVARCHAR);
	END CATCH
END;


-- Execution of Store Procedure
EXEC bronze.load_bronze
