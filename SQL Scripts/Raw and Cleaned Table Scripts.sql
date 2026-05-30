CREATE TABLE data_cleaning_2_raw (
	order_id VARCHAR(20),
	customer_name VARCHAR(20),
	email VARCHAR(50),
	order_date VARCHAR(20),
	product_name VARCHAR(50),
	quantity VARCHAR(20),
	price VARCHAR(20),
	country VARCHAR(30),
	order_status VARCHAR(20),
	notes VARCHAR(50)
);

BULK INSERT data_cleaning_2_raw
FROM 'customer_orders.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
);

SELECT * FROM data_cleaning_2_raw;

SELECT *
INTO data_cleaning_2_cleaned
FROM data_cleaning_2_raw;

SELECT * FROM data_cleaning_2_cleaned;