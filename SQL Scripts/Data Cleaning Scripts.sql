-- Data Cleaning - 1. Inconsistent customer name formatting
SELECT
	customer_name,
	 CASE 
		WHEN CHARINDEX(' ',TRIM(customer_name)) = 0 THEN
			CONCAT(
				UPPER(LEFT(TRIM(customer_name),1)), 
				SUBSTRING(TRIM(customer_name),2,LEN(TRIM(customer_name)))
			)
		ELSE
			CONCAT(
				UPPER(LEFT(TRIM(customer_name),1)), 
				LOWER(SUBSTRING(TRIM(customer_name),2,CHARINDEX(' ',TRIM(customer_name)) - 2)), 
				' ', 
				UPPER(SUBSTRING(TRIM(customer_name),CHARINDEX(' ',TRIM(customer_name)) + 1, 1)), 
				LOWER(SUBSTRING(TRIM(customer_name),CHARINDEX(' ',TRIM(customer_name)) + 2, LEN(TRIM(customer_name)) - 1))
			)
	END
FROM data_cleaning_2_cleaned

UPDATE data_cleaning_2_cleaned
SET customer_name = CASE 
						WHEN CHARINDEX(' ',TRIM(customer_name)) = 0 THEN
							CONCAT(
								UPPER(LEFT(TRIM(customer_name),1)), 
								SUBSTRING(TRIM(customer_name),2,LEN(TRIM(customer_name)))
							)
						ELSE
							CONCAT(
								UPPER(LEFT(TRIM(customer_name),1)), 
								LOWER(SUBSTRING(TRIM(customer_name),2,CHARINDEX(' ',TRIM(customer_name)) - 2)), 
								' ', 
								UPPER(SUBSTRING(TRIM(customer_name),CHARINDEX(' ',TRIM(customer_name)) + 1, 1)), 
								LOWER(SUBSTRING(TRIM(customer_name),CHARINDEX(' ',TRIM(customer_name)) + 2, LEN(TRIM(customer_name)) - 1))
							)
					END

SELECT * FROM data_cleaning_2_cleaned;

-- Data Cleaning - 2. Inconsistent order date formatting
SELECT
	order_date,
	CAST(order_date AS DATE)
FROM data_cleaning_2_cleaned;

UPDATE data_cleaning_2_cleaned
SET order_date = CAST(order_date AS DATE);

SELECT * FROM data_cleaning_2_cleaned;

-- Data Cleaning - 3. Inconsistent product name formatting

SELECT DISTINCT
	LOWER(product_name)
FROM data_cleaning_2_cleaned;

UPDATE data_cleaning_2_cleaned
SET product_name = CASE
						WHEN LOWER(product_name) = 'apple watch' THEN 'Apple Watch'
						WHEN LOWER(product_name) = 'google pixel' THEN 'Google Pixel'
						WHEN LOWER(product_name) = 'iphone 14' THEN 'iPhone 14'
						WHEN LOWER(product_name) = 'macbook pro' THEN 'MacBook Pro'
						WHEN LOWER(product_name) = 'samsung galaxy s22' THEN 'Samsung Galaxy S22'
						ELSE 'Others'
					END;

SELECT * FROM data_cleaning_2_cleaned;

-- Data Cleaning - 4. Quantity includes alphabetical quantities

UPDATE data_cleaning_2_cleaned
SET quantity = 2
WHERE quantity = 'two';

-- Data Cleaning - 5. Inconsistent formatting in price column

SELECT
	price
FROM data_cleaning_2_cleaned
WHERE price NOT LIKE '[0-9]%';

SELECT
	RIGHT(price,LEN(price) - 1)
FROM data_cleaning_2_cleaned
WHERE price NOT LIKE '[0-9]%';

UPDATE data_cleaning_2_cleaned
SET price = RIGHT(price,LEN(price) - 1)
WHERE price NOT LIKE '[0-9]%';

-- Data Cleaning - 6. Inconsistent formatting of country names

SELECT DISTINCT	
	LOWER(country)
FROM data_cleaning_2_cleaned;

UPDATE data_cleaning_2_cleaned
SET country = CASE
				WHEN LOWER(country) IN ('uk','united kingdom') THEN 'United Kingdom'
				WHEN LOWER(country) IN ('us', 'usa', 'united states') THEN 'United States of America'
				WHEN LOWER(country) = 'canada' THEN 'Canada'
				WHEN LOWER(country) = 'spain' THEN 'Spain'
				WHEN LOWER(country) = 'india' THEN 'India'
				ELSE 'Others'
			  END;

SELECT * FROM data_cleaning_2_cleaned;

-- Data Cleaning - 7. Inconsistent formatting of order status column

SELECT DISTINCT
	LOWER(order_status)
FROM data_cleaning_2_cleaned;

UPDATE data_cleaning_2_cleaned
SET order_status = CASE
						WHEN LOWER(order_status) = 'delivered' THEN 'Delivered'
						WHEN LOWER(order_status) = 'pending' THEN 'Pending'
						WHEN LOWER(order_status) = 'refunded' THEN 'Refunded'
						WHEN LOWER(order_status) = 'returned' THEN 'Returned'
						WHEN LOWER(order_status) = 'shipped' THEN 'Shipped'
						ELSE 'Others'
				   END;

SELECT * FROM data_cleaning_2_cleaned;

-- Data Cleaning - 8. Customer name has NULL strings

SELECT
	customer_name,
	email
FROM data_cleaning_2_cleaned
WHERE 
	customer_name IS NULL
	OR customer_name = 'NULL';

UPDATE data_cleaning_2_cleaned
SET customer_name = 'Unknown'
WHERE 
	customer_name IS NULL
	OR customer_name = 'NULL';

SELECT * FROM data_cleaning_2_cleaned;

-- Data Cleaning - 9. email has NULL values

SELECT
	customer_name,
	email
FROM data_cleaning_2_cleaned AS a
WHERE EXISTS (
	SELECT 1
	FROM data_cleaning_2_cleaned AS b
	WHERE 
		email IS NULL
		AND a.customer_name = b.customer_name
	);

UPDATE data_cleaning_2_cleaned
SET email = 'tom.obrien@gmail.com'
WHERE email IS NULL;

SELECT * FROM data_cleaning_2_cleaned;

-- Data Cleaning - 10. Price has NULL values

SELECT DISTINCT
	product_name,
	price
FROM data_cleaning_2_cleaned;

UPDATE data_cleaning_2_cleaned
SET price = CASE product_name
				WHEN 'Apple Watch' THEN 399
				WHEN 'Google Pixel' THEN 599
				WHEN 'iPhone 14' THEN 1099
				WHEN 'MacBook Pro' THEN 1299
				WHEN 'Samsung Galaxy S22' THEN 799
				ELSE 0
			END;

SELECT * FROM data_cleaning_2_cleaned;

-- Data Cleaning - 11. Check for alphabets in the customer name

SELECT
	customer_name,
	email
FROM data_cleaning_2_cleaned
WHERE customer_name LIKE '%[^A-Za-z ]%';

UPDATE data_cleaning_2_cleaned
SET customer_name = 'Carlos Hernandez'
WHERE email = 'carlos@hernandez.com';

SELECT * FROM data_cleaning_2_cleaned;

-- Data Cleaning - 12. Check for duplicates
WITH duplicates AS (
	SELECT
		order_id,
		ROW_NUMBER() OVER(PARTITION BY customer_name, email, order_date, product_name, quantity, price, country, order_status ORDER BY order_date) AS rn
	FROM data_cleaning_2_cleaned
)
DELETE FROM data_cleaning_2_cleaned
WHERE order_id IN (SELECT 
						order_id 
				   FROM duplicates
				   WHERE rn > 1)

SELECT * FROM data_cleaning_2_cleaned;

-- Data Cleaning - 13. Change the column datatypes to appropriate datatypes
ALTER TABLE data_cleaning_2_cleaned
ALTER COLUMN order_id INT;

ALTER TABLE data_cleaning_2_cleaned
ALTER COLUMN customer_name VARCHAR(30);

ALTER TABLE data_cleaning_2_cleaned
ALTER COLUMN email VARCHAR(30);

ALTER TABLE data_cleaning_2_cleaned
ALTER COLUMN order_date DATE;

ALTER TABLE data_cleaning_2_cleaned
ALTER COLUMN product_name VARCHAR(20);

ALTER TABLE data_cleaning_2_cleaned
ALTER COLUMN quantity INT;

ALTER TABLE data_cleaning_2_cleaned
ALTER COLUMN price INT;

ALTER TABLE data_cleaning_2_cleaned
ALTER COLUMN country VARCHAR(30);

ALTER TABLE data_cleaning_2_cleaned
ALTER COLUMN order_status VARCHAR(10);

-- Data Cleaning - 14. Drop Column "notes"

ALTER TABLE data_cleaning_2_cleaned
DROP COLUMN notes;

SELECT * FROM data_cleaning_2_cleaned;