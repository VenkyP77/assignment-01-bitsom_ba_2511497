-- ============================================================
-- Star Schema for Retail Transactions Data Warehouse
-- ============================================================

-- ============================================================
-- DIMENSION TABLES
-- ============================================================

-- dim_date: Date dimension for time-based analysis
CREATE TABLE dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE NOT NULL,
    day_of_month INT NOT NULL,
    month INT NOT NULL,
    month_name VARCHAR(20) NOT NULL,
    quarter INT NOT NULL,
    year INT NOT NULL,
    day_of_week INT NOT NULL,
    day_name VARCHAR(20) NOT NULL
);

-- dim_store: Store dimension for location-based analysis
CREATE TABLE dim_store (
    store_key INT PRIMARY KEY,
    store_name VARCHAR(50) NOT NULL,
    store_city VARCHAR(50) NOT NULL
);

-- dim_product: Product dimension for product-based analysis
CREATE TABLE dim_product (
    product_key INT PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL,
    category VARCHAR(50) NOT NULL
);

-- ============================================================
-- FACT TABLE
-- ============================================================

-- fact_sales: Central fact table with foreign keys and measures
CREATE TABLE fact_sales (
    sale_key INT PRIMARY KEY,
    date_key INT NOT NULL,
    store_key INT NOT NULL,
    product_key INT NOT NULL,
    transaction_id VARCHAR(20) NOT NULL,
    customer_id VARCHAR(20) NOT NULL,
    units_sold INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    total_amount DECIMAL(12, 2) NOT NULL,
    FOREIGN KEY (date_key) REFERENCES dim_date(date_key),
    FOREIGN KEY (store_key) REFERENCES dim_store(store_key),
    FOREIGN KEY (product_key) REFERENCES dim_product(product_key)
);

-- ============================================================
-- INSERT DIMENSION DATA
-- ============================================================

-- Data Cleaning Notes:
--   1. Dates standardized to YYYY-MM-DD (ISO 8601 / SQL standard) from mixed formats (DD/MM/YYYY, DD-MM-YYYY, YYYY-MM-DD)
--   2. NULL store_city values inferred from store_name (e.g., "Chennai Anna" -> "Chennai")
--   3. Category casing standardized: "electronics" -> "Electronics", "Grocery" -> "Groceries"

-- dim_date: Distinct dates used by the sample fact rows
INSERT INTO dim_date (date_key, full_date, day_of_month, month, month_name, quarter, year, day_of_week, day_name) VALUES
(20230111, '2023-01-11', 11, 1, 'January',   1, 2023, 4, 'Wednesday'),
(20230115, '2023-01-15', 15, 1, 'January',   1, 2023, 1, 'Sunday'),
(20230205, '2023-02-05',  5, 2, 'February',  1, 2023, 1, 'Sunday'),
(20230220, '2023-02-20', 20, 2, 'February',  1, 2023, 2, 'Monday'),
(20230414, '2023-04-14', 14, 4, 'April',     2, 2023, 6, 'Friday'),
(20230521, '2023-05-21', 21, 5, 'May',       2, 2023, 1, 'Sunday'),
(20230604, '2023-06-04',  4, 6, 'June',      2, 2023, 1, 'Sunday'),
(20230809, '2023-08-09',  9, 8, 'August',    3, 2023, 4, 'Wednesday'),
(20230829, '2023-08-29', 29, 8, 'August',    3, 2023, 3, 'Tuesday'),
(20231026, '2023-10-26', 26, 10, 'October',  4, 2023, 5, 'Thursday'),
(20231118, '2023-11-18', 18, 11, 'November', 4, 2023, 7, 'Saturday'),
(20231208, '2023-12-08',  8, 12, 'December', 4, 2023, 6, 'Friday'),
(20231212, '2023-12-12', 12, 12, 'December', 4, 2023, 3, 'Tuesday');

-- dim_store: 5 distinct stores (city values cleaned from NULLs)
INSERT INTO dim_store (store_key, store_name, store_city) VALUES
(1, 'Chennai Anna',   'Chennai'),
(2, 'Delhi South',    'Delhi'),
(3, 'Bangalore MG',   'Bangalore'),
(4, 'Mumbai Central', 'Mumbai'),
(5, 'Pune FC Road',   'Pune');

-- dim_product: 16 distinct products (categories standardized)
INSERT INTO dim_product (product_key, product_name, category) VALUES
(1,  'Speaker',     'Electronics'),
(2,  'Tablet',      'Electronics'),
(3,  'Phone',       'Electronics'),
(4,  'Smartwatch',  'Electronics'),
(5,  'Laptop',      'Electronics'),
(6,  'Headphones',  'Electronics'),
(7,  'Jeans',       'Clothing'),
(8,  'Jacket',      'Clothing'),
(9,  'Saree',       'Clothing'),
(10, 'T-Shirt',     'Clothing'),
(11, 'Atta 10kg',   'Groceries'),
(12, 'Biscuits',    'Groceries'),
(13, 'Milk 1L',     'Groceries'),
(14, 'Pulses 1kg',  'Groceries'),
(15, 'Oil 1L',      'Groceries'),
(16, 'Rice 5kg',    'Groceries');

-- ============================================================
-- INSERT FACT DATA (12 cleaned sample rows)
-- ============================================================
-- Cleaning applied per row:
--   TXN5000: date "29/08/2023" -> "2023-08-29", category "electronics" -> "Electronics"
--   TXN5001: date "12-12-2023" -> "2023-12-12"
--   TXN5002: date already "2023-02-05", no issues
--   TXN5003: date "20-02-2023" -> "2023-02-20"
--   TXN5004: date already "2023-01-15", category "electronics" -> "Electronics"
--   TXN5005: date already "2023-08-09", no issues
--   TXN5007: date already "2023-10-26", no issues
--   TXN5008: date already "2023-12-08", no issues
--   TXN5010: date already "2023-06-04", no issues
--   TXN5012: date already "2023-05-21", no issues
--   TXN5014: date already "2023-11-18", no issues
--   TXN5029: date already "2023-01-11", no issues

INSERT INTO fact_sales (sale_key, date_key, store_key, product_key, transaction_id, customer_id, units_sold, unit_price, total_amount) VALUES
(1,  20230829, 1, 1,  'TXN5000', 'CUST045',  3, 49262.78, 147788.34),
(2,  20231212, 1, 2,  'TXN5001', 'CUST021', 11, 23226.12, 255487.32),
(3,  20230205, 1, 3,  'TXN5002', 'CUST019', 20, 48703.39, 974067.80),
(4,  20230220, 2, 2,  'TXN5003', 'CUST007', 14, 23226.12, 325165.68),
(5,  20230115, 1, 4,  'TXN5004', 'CUST004', 10, 58851.01, 588510.10),
(6,  20230809, 3, 11, 'TXN5005', 'CUST027', 12, 52464.00, 629568.00),
(7,  20231026, 5, 7,  'TXN5007', 'CUST041', 16,  2317.47,  37079.52),
(8,  20231208, 3, 12, 'TXN5008', 'CUST030',  9, 27469.99, 247229.91),
(9,  20230604, 1, 8,  'TXN5010', 'CUST031', 15, 30187.24, 452808.60),
(10, 20230521, 3, 5,  'TXN5012', 'CUST044', 13, 42343.15, 550460.95),
(11, 20231118, 2, 8,  'TXN5014', 'CUST042',  5, 30187.24, 150936.20),
(12, 20230111, 4, 10, 'TXN5029', 'CUST016', 20, 29770.19, 595403.80);
