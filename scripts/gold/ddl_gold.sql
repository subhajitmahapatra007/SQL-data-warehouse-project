/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

--+-+-+-+-+-+-+---+-+-+-+-+-+-+---+-+-+-+-+-+-+---+-+-+-+-+-+-+---+-+-+-+-+-+-+---+-+-+-+-+-+-+-
-- Create Dimension: gold.dim_customers
--+-+-+-+-+-+-+---+-+-+-+-+-+-+---+-+-+-+-+-+-+---+-+-+-+-+-+-+---+-+-+-+-+-+-+---+-+-+-+-+-+-+-

IF OBJECT_ID('gold.dim_customer','V') IS NOT NULL
	DROP VIEW gold.dim_customer;
GO

CREATE VIEW gold.dim_customer AS
SELECT 
	ROW_NUMBER() OVER(ORDER BY cst_id) customer_key, -- Surrogate key
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	lo.cntry AS country,
	CASE 
		WHEN ci.cst_gndr IS NOT NULL AND ci.cst_gndr != 'N/A' THEN ci.cst_gndr
		ELSE COALESCE(cb.gen,'N/A')
	END AS new_gen,
	ci.cst_marital_status AS marital_status,
	cb.bdate AS birthdate,
	ci.cst_create_date AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 cb ON ci.cst_key = cb.cid
LEFT JOIN silver.erp_loc_a101 lo ON ci.cst_key = lo.cid;
GO

--+-+-+-+-+-+-+---+-+-+-+-+-+-+---+-+-+-+-+-+-+---+-+-+-+-+-+-+---+-+-+-+-+-+-+---+-+-+-+-+-+-+-
  -- Create Dimension: gold.dim_product
--+-+-+-+-+-+-+---+-+-+-+-+-+-+---+-+-+-+-+-+-+---+-+-+-+-+-+-+---+-+-+-+-+-+-+---+-+-+-+-+-+-+-
IF OBJECT_ID('gold.dim_product','V') IS NOT NULL
	DROP VIEW gold.dim_product;
GO

CREATE VIEW gold.dim_product AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY pr.prd_start_dt, pr.prd_key) AS product_key, -- Surrogate key
	pr.prd_id  AS product_id,
	
	pr.prd_key AS product_number,
	pr.prd_nm AS product_name,
	pr.cat_id AS category_id,
	pc.cat AS category,
	pc.subcat AS sub_category,
	pc.maintenance AS maintenance,
	pr.prd_cost AS cost,
	pr.prd_line product_line,
	pr.prd_start_dt AS  start_date
FROM silver.crm_prd_info pr
LEFT JOIN silver.erp_px_cat_g1v2 pc 
ON pr.cat_id = pc.id
WHERE pr.prd_end_dt IS NULL

GO

--+-+-+-+-+-+-+---+-+-+-+-+-+-+---+-+-+-+-+-+-+---+-+-+-+-+-+-+---+-+-+-+-+-+-+---+-+-+-+-+-+-+-
-- Create Dimension: gold.fact_sales
--+-+-+-+-+-+-+---+-+-+-+-+-+-+---+-+-+-+-+-+-+---+-+-+-+-+-+-+---+-+-+-+-+-+-+---+-+-+-+-+-+-+-

IF OBJECT_ID('gold.fact_sales','V') IS NOT NULL
	DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT 
	sls.sls_ord_num  AS order_number,
    prd.product_key  AS product_key,
    cst.customer_key AS customer_key,
    sls.sls_order_dt AS order_date,
    sls.sls_ship_dt  AS shipping_date,
    sls.sls_due_dt   AS due_date,
    sls.sls_sales    AS sales_amount,
    sls.sls_quantity AS quantity,
    sls.sls_price    AS price
FROM silver.crm_sales_details sls
LEFT JOIN gold.dim_customer cst ON sls.sls_cust_id = cst.customer_id
LEFT JOIN gold.dim_product prd ON sls.sls_prd_key = prd.product_number

GO

