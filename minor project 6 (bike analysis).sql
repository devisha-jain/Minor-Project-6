-- ============================================================
-- SQL Minor Project - Option 1: Bike Store Sales & Inventory Analysis
-- Author: DJ
-- Concepts used: INNER JOIN, GROUP BY, aggregate functions, ORDER BY
-- Subqueries and CTEs intentionally NOT used.
-- ============================================================

CREATE DATABASE IF NOT EXISTS BikeStoreProject;
USE BikeStoreProject;

-- ------------------------------------------------------------
-- SCHEMA
-- ------------------------------------------------------------

CREATE TABLE brands (
    brand_id    INT PRIMARY KEY,
    brand_name  VARCHAR(50)
);

CREATE TABLE categories (
    category_id     INT PRIMARY KEY,
    category_name   VARCHAR(50)
);

CREATE TABLE stores (
    store_id    INT PRIMARY KEY,
    store_name  VARCHAR(50),
    city        VARCHAR(50)
);

CREATE TABLE products (
    product_id      INT PRIMARY KEY,
    product_name    VARCHAR(100),
    brand_id        INT,
    category_id     INT,
    list_price      DECIMAL(10,2),
    FOREIGN KEY (brand_id) REFERENCES brands(brand_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE customers (
    customer_id     INT PRIMARY KEY,
    first_name      VARCHAR(50),
    last_name       VARCHAR(50),
    city            VARCHAR(50)
);

CREATE TABLE orders (
    order_id    INT PRIMARY KEY,
    customer_id INT,
    store_id    INT,
    order_date  DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (store_id) REFERENCES stores(store_id)
);

CREATE TABLE order_items (
    order_id    INT,
    item_id     INT,
    product_id  INT,
    quantity    INT,
    list_price  DECIMAL(10,2),
    discount    DECIMAL(4,2) DEFAULT 0,
    PRIMARY KEY (order_id, item_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE stocks (
    store_id    INT,
    product_id  INT,
    quantity    INT,
    PRIMARY KEY (store_id, product_id),
    FOREIGN KEY (store_id) REFERENCES stores(store_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- ------------------------------------------------------------
-- SAMPLE DATA
-- ------------------------------------------------------------

INSERT INTO brands VALUES
(1,'Trek'),(2,'Giant'),(3,'Cannondale'),(4,'Specialized'),(5,'Hero Cycles');

INSERT INTO categories VALUES
(1,'Mountain Bikes'),(2,'Road Bikes'),(3,'Hybrid Bikes'),(4,'Kids Bikes'),(5,'Electric Bikes');

INSERT INTO stores VALUES
(1,'Baner Store','Pune'),
(2,'Koramangala Store','Bengaluru'),
(3,'CP Store','Delhi');

INSERT INTO products (product_id, product_name, brand_id, category_id, list_price) VALUES
(1,'Trek Marlin 7',1,1,45000),
(2,'Trek Domane AL2',1,2,62000),
(3,'Giant Talon 3',2,1,38000),
(4,'Giant Escape 3',2,3,32000),
(5,'Cannondale Trail 5',3,1,41000),
(6,'Cannondale Synapse',3,2,75000),
(7,'Specialized Rockhopper',4,1,55000),
(8,'Specialized Sirrus X',4,3,60000),
(9,'Hero Sprint Kids',5,4,8000),
(10,'Hero Octane Kids',5,4,9500),
(11,'Trek Powerfly (E-Bike)',1,5,120000),
(12,'Giant Fathom E+',2,5,135000),
(13,'Cannondale Quick CX 3',3,3,48000),
(14,'Specialized Diverge',4,2,80000),
(15,'Hero Urban Glide',5,3,15000),
(16,'Trek FX 2',1,3,36000),
(17,'Giant Revolt Gravel',2,2,58000),
(18,'Cannondale Habit',3,1,90000),
(19,'Specialized Turbo Levo',4,5,250000),
(20,'Hero Sprint 26T',5,1,7000);

INSERT INTO customers (customer_id, first_name, last_name, city) VALUES
(1,'Aarav','Sharma','Pune'),
(2,'Vivaan','Iyer','Bengaluru'),
(3,'Aditya','Verma','Delhi'),
(4,'Vihaan','Nair','Pune'),
(5,'Arjun','Reddy','Bengaluru'),
(6,'Sai','Joshi','Delhi'),
(7,'Reyansh','Kulkarni','Pune'),
(8,'Krishna','Menon','Bengaluru'),
(9,'Ishaan','Gupta','Delhi'),
(10,'Kabir','Chauhan','Pune'),
(11,'Ananya','Rao','Bengaluru'),
(12,'Diya','Pillai','Delhi'),
(13,'Myra','Bose','Pune'),
(14,'Aadhya','Nambiar','Bengaluru'),
(15,'Kiara','Mehta','Delhi'),
(16,'Anika','Kapoor','Pune'),
(17,'Navya','Shetty','Bengaluru'),
(18,'Riya','Das','Delhi'),
(19,'Saanvi','Bhat','Pune'),
(20,'Aarohi','Chatterjee','Bengaluru');

INSERT INTO orders (order_id, customer_id, store_id, order_date) VALUES
(1,1,1,'2025-01-05'),
(2,2,2,'2025-01-07'),
(3,3,3,'2025-01-10'),
(4,4,1,'2025-01-12'),
(5,5,2,'2025-01-15'),
(6,6,3,'2025-01-18'),
(7,7,1,'2025-01-20'),
(8,8,2,'2025-01-22'),
(9,9,3,'2025-01-25'),
(10,10,1,'2025-02-01'),
(11,11,2,'2025-02-03'),
(12,12,3,'2025-02-05'),
(13,13,1,'2025-02-08'),
(14,14,2,'2025-02-10'),
(15,15,3,'2025-02-12'),
(16,16,1,'2025-02-15'),
(17,17,2,'2025-02-18'),
(18,18,3,'2025-02-20'),
(19,19,1,'2025-02-22'),
(20,20,2,'2025-02-25');

INSERT INTO order_items (order_id, item_id, product_id, quantity, list_price, discount) VALUES
(1,1,1,1,45000,0.05),
(2,1,3,2,38000,0.00),
(3,1,9,3,8000,0.10),
(4,1,11,1,120000,0.08),
(5,1,4,1,32000,0.00),
(6,1,7,2,55000,0.05),
(7,1,16,1,36000,0.00),
(8,1,19,1,250000,0.10),
(9,1,10,4,9500,0.00),
(10,1,2,1,62000,0.05),
(11,1,5,2,41000,0.00),
(12,1,20,5,7000,0.05),
(13,1,6,1,75000,0.00),
(14,1,12,1,135000,0.10),
(15,1,17,1,58000,0.00),
(16,1,3,1,38000,0.05),
(17,1,9,2,8000,0.00),
(18,1,14,1,80000,0.05),
(19,1,1,2,45000,0.00),
(20,1,15,3,15000,0.05),
(1,2,9,2,8000,0.00),
(3,2,20,1,7000,0.00),
(6,2,10,1,9500,0.05);

INSERT INTO stocks (store_id, product_id, quantity) VALUES
(1,1,5),(1,2,0),(1,3,8),(1,4,0),(1,5,6),
(2,6,4),(2,7,0),(2,8,3),(2,9,10),(2,10,0),
(3,11,2),(3,12,1),(3,13,0),(3,14,5),(3,15,7),
(1,16,0),(2,17,3),(3,18,2),(1,19,1),(2,20,0);

-- ============================================================
-- TASKS
-- ============================================================

-- Task 1: Store Performance -- Total revenue generated by each store
SELECT
    s.store_name AS Store_Name,
    SUM(oi.list_price * oi.quantity * (1 - oi.discount)) AS Total_Revenue
FROM stores s
INNER JOIN orders o ON s.store_id = o.store_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY s.store_name
ORDER BY Total_Revenue DESC;

-- Task 2: Product Popularity -- Top 5 most sold products by quantity
SELECT
    p.product_name AS Product_Name,
    SUM(oi.quantity) AS Total_Quantity_Sold
FROM products p
INNER JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY Total_Quantity_Sold DESC
LIMIT 5;

-- Task 3: Customer Location -- Customers who placed orders with store names
SELECT
    c.first_name AS First_Name,
    c.last_name AS Last_Name,
    c.city AS Customer_City,
    s.store_name AS Store_Name,
    o.order_date AS Order_Date
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN stores s ON o.store_id = s.store_id
ORDER BY c.last_name, o.order_date;

-- Task 4: Brand Insights -- Total number of products per brand
SELECT
    b.brand_name AS Brand_Name,
    COUNT(p.product_id) AS Total_Products
FROM brands b
INNER JOIN products p ON b.brand_id = p.brand_id
GROUP BY b.brand_name
ORDER BY Total_Products DESC;

-- Task 5: Low Stock Alert -- Products with zero quantity in stock
SELECT
    p.product_name AS Product_Name,
    s.store_name AS Store_Name,
    st.quantity AS Quantity_In_Stock
FROM stocks st
INNER JOIN products p ON st.product_id = p.product_id
INNER JOIN stores s ON st.store_id = s.store_id
WHERE st.quantity = 0
ORDER BY s.store_name, p.product_name;

SHOW DATABASES;

USE BikeStoreProject;
SHOW TABLES;

USE BikeStoreProject;
DESCRIBE products;
DESCRIBE orders;
DESCRIBE order_items;

USE BikeStoreProject;
SELECT COUNT(*) AS total_products FROM products;
SELECT COUNT(*) AS total_orders FROM orders;
SELECT COUNT(*) AS total_order_items FROM order_items;

USE BikeStoreProject;
SELECT * FROM products LIMIT 5;

