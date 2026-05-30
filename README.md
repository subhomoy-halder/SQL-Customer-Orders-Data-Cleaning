# E-Commerce Customer Orders: Complete SQL Data Cleaning Project

## 🎯 Project Overview
This project focuses on taking a raw, messy dataset of e-commerce customer orders and transforming it into a clean, structured, and reliable format ready for exploratory data analysis (EDA) and reporting. The project is entirely SQL-based, utilizing a series of scripts to load, explore, and meticulously clean the data step-by-step.

## 📁 Repository Files
This repository contains the following files:
* **`data/Raw Data.csv`**: The initial, uncleaned dataset containing inconsistencies, duplicates, and missing values.
* **`data/Cleaned Data.csv`**: The final output after all SQL transformations have been applied.
* **`SQL Scripts/CREATE TABLE Scripts.sql`**: DDL and DML scripts to create the database tables and bulk insert the raw CSV data.
* **`SQL Scripts/Data Cleaning Scripts.sql`**: The core transformation pipeline containing the UPDATE, DELETE, and ALTER statements used to resolve all 14 issues.

---

## 🧹 The 14-Step Data Cleaning Process
During the data exploration phase, 14 specific data discrepancies were identified. The `Data Cleaning Scripts.sql` file addresses each of them in the following order:

### 1. Standardizing Customer Names
**Issue:** Names had inconsistent casing and arbitrary spacing (e.g., `SARAH THOMPSON`, `john smith`).
**Solution:** Utilized complex string manipulation (`CHARINDEX`, `UPPER`, `LOWER`, `SUBSTRING`, `TRIM`) to dynamically format all names to proper Title Case.

### 2. Standardizing Order Dates
**Issue:** Dates were stored as strings in various formats (e.g., `2023/10/30`, `11/02/2023`).
**Solution:** Used the `CAST` function to standardize the column into a proper SQL `DATE` format (`YYYY-MM-DD`).

### 3. Standardizing Product Names
**Issue:** Inconsistent casing and spelling of core products (e.g., `apple watch`, `Iphone 14`).
**Solution:** Applied a `CASE WHEN` statement combined with `LOWER()` to categorize all products into their official brand formatting, placing unrecognized items into an 'Others' bucket.

### 4. Fixing Alphabetical Quantities
**Issue:** Numerical quantity columns contained text strings (e.g., `two`).
**Solution:** Updated the specific text values to their corresponding numerical integers.

### 5. Cleaning Financial Formatting
**Issue:** The price column contained non-numeric characters like dollar signs (e.g., `$399.99`).
**Solution:** Used the `RIGHT` and `LEN` functions to strip leading non-numeric characters to prepare the column for mathematical operations.

### 6. Standardizing Country Names
**Issue:** Countries were entered with multiple variations and abbreviations (e.g., `uk`, `USA`, `spain`).
**Solution:** Used a `CASE WHEN` statement with `IN` operators to map all regional variations to standardized names (`United Kingdom`, `United States of America`, `Spain`, etc.).

### 7. Standardizing Order Statuses
**Issue:** Casing inconsistencies in shipping statuses (e.g., `DELIVERED`, `shipped`).
**Solution:** Normalized all statuses to Title Case using a `CASE WHEN` statement.

### 8 & 9. Handling Missing Customer Information (NULLs)
**Issue:** `customer_name` and `email` columns contained missing values or literal `'NULL'` strings.
**Solution:** Replaced `NULL` names with `'Unknown'` and utilized existing data matching to impute missing email addresses where applicable.

### 10. Imputing Missing Prices
**Issue:** The `price` column contained `NULL` values.
**Solution:** Built a lookup `CASE` statement based on the `product_name` to backfill missing prices with the correct retail value (e.g., setting 'iPhone 14' to 1099).

### 11. Removing Invalid Characters from Names
**Issue:** Customer names contained non-alphabetical characters/symbols (e.g., `Carlos Hern+índez`).
**Solution:** Used pattern matching (`LIKE '%[^A-Za-z ]%'`) to identify bad strings and `UPDATE` statements to correct the corrupted names.

### 12. Removing Duplicate Records
**Issue:** The raw dataset contained exact row-level duplicates.
**Solution:** Created a Common Table Expression (CTE) utilizing the `ROW_NUMBER()` Window Function, partitioned by all relevant columns, to isolate and `DELETE` duplicate entries while retaining the original records.

### 13. Casting Data Types
**Issue:** Because the data was imported from a raw CSV, all columns defaulted to `VARCHAR`.
**Solution:** Used `ALTER TABLE` and `ALTER COLUMN` commands to convert the standardized strings into optimal structural data types (`INT`, `DATE`, and specific `VARCHAR` lengths) to optimize database storage and performance.

### 14. Dropping Unnecessary Columns
**Issue:** The `notes` column contained unstructured, irrelevant text.
**Solution:** Dropped the column entirely to reduce table bloat and finalize the clean dataset.

---

## 🛠️ Skills & Technologies Demonstrated
* **RDBMS:** Microsoft SQL Server (T-SQL)
* **Data Import:** `BULK INSERT` for flat files.
* **Advanced SQL:** CTEs, Window Functions (`ROW_NUMBER`).
* **Data Manipulation (DML):** `UPDATE`, `DELETE`, `CAST`, `CASE WHEN`.
* **String Functions:** `TRIM`, `UPPER`, `LOWER`, `SUBSTRING`, `CHARINDEX`, `RIGHT`, `LEN`.
* **Data Definition (DDL):** `CREATE TABLE`, `ALTER TABLE`, `DROP COLUMN`.
