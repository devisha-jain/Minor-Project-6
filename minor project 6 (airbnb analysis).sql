-- ============================================================
-- SQL Minor Project - Option 2: Airbnb Hospitality & Booking Trends
-- Author: DJ
-- Concepts used: JOIN (fact/dimension), GROUP BY, WHERE, ORDER BY
-- Subqueries and CTEs intentionally NOT used.
-- ============================================================

CREATE DATABASE IF NOT EXISTS AirbnbProject1;
USE AirbnbProject1;

-- ------------------------------------------------------------
-- SCHEMA (Dimension tables: hosts, properties, guests | Fact table: bookings)
-- ------------------------------------------------------------

CREATE TABLE hosts (
    host_id         INT PRIMARY KEY,
    host_name       VARCHAR(50),
    is_superhost    VARCHAR(3)      -- 'Yes' / 'No'
);

CREATE TABLE properties (
    property_id     INT PRIMARY KEY,
    host_id         INT,
    property_type   VARCHAR(50),    -- Entire Home, Private Room, Shared Room, Villa
    city            VARCHAR(50),
    FOREIGN KEY (host_id) REFERENCES hosts(host_id)
);

CREATE TABLE guests (
    guest_id        INT PRIMARY KEY,
    guest_name      VARCHAR(50),
    age             INT,
    nationality     VARCHAR(50)
);

CREATE TABLE bookings (
    booking_id      INT PRIMARY KEY,
    property_id     INT,
    guest_id        INT,
    booking_date    DATE,
    nights          INT,
    price_per_night DECIMAL(10,2),
    rating          DECIMAL(2,1),   -- guest rating for that stay, 1.0 - 5.0
    FOREIGN KEY (property_id) REFERENCES properties(property_id),
    FOREIGN KEY (guest_id) REFERENCES guests(guest_id)
);

-- ------------------------------------------------------------
-- SAMPLE DATA
-- ------------------------------------------------------------

INSERT INTO hosts (host_id, host_name, is_superhost) VALUES
(1,'Rohan Mehta','Yes'),
(2,'Priya Nair','No'),
(3,'Karan Malhotra','Yes'),
(4,'Sneha Kulkarni','No'),
(5,'Arjun Rao','Yes'),
(6,'Divya Menon','No');

INSERT INTO properties (property_id, host_id, property_type, city) VALUES
(1,1,'Entire Home','Goa'),
(2,1,'Villa','Goa'),
(3,2,'Private Room','Jaipur'),
(4,2,'Shared Room','Jaipur'),
(5,3,'Entire Home','Manali'),
(6,3,'Villa','Manali'),
(7,4,'Private Room','Udaipur'),
(8,5,'Entire Home','Rishikesh'),
(9,5,'Villa','Rishikesh'),
(10,6,'Shared Room','Kochi'),
(11,6,'Private Room','Kochi'),
(12,1,'Entire Home','Goa'),
(13,3,'Entire Home','Manali'),
(14,4,'Villa','Udaipur'),
(15,5,'Private Room','Rishikesh');

INSERT INTO guests (guest_id, guest_name, age, nationality) VALUES
(1,'John Smith',29,'USA'),
(2,'Emma Wilson',34,'UK'),
(3,'Liu Wei',26,'China'),
(4,'Ahmed Khan',41,'UAE'),
(5,'Sara Müller',31,'Germany'),
(6,'Rahul Verma',24,'India'),
(7,'Yuki Tanaka',38,'Japan'),
(8,'Sophie Dubois',45,'France'),
(9,'Carlos Silva',22,'Brazil'),
(10,'Anjali Singh',33,'India'),
(11,'Mark Taylor',52,'Australia'),
(12,'Nina Petrova',27,'Russia'),
(13,'Ravi Kumar',19,'India'),
(14,'Olivia Brown',36,'Canada'),
(15,'Diego Fernandez',48,'Spain'),
(16,'Priyanka Das',30,'India'),
(17,'James Lee',23,'South Korea'),
(18,'Fatima Noor',40,'UAE'),
(19,'Chloe Martin',28,'France'),
(20,'Aditi Rao',35,'India');

INSERT INTO bookings (booking_id, property_id, guest_id, booking_date, nights, price_per_night, rating) VALUES
(1,1,1,'2025-03-01',3,6500,4.8),
(2,2,2,'2025-03-03',5,9000,4.6),
(3,3,3,'2025-03-05',2,2500,4.2),
(4,4,4,'2025-03-06',1,1500,3.9),
(5,5,5,'2025-03-08',4,7000,4.9),
(6,6,6,'2025-03-10',6,11000,4.7),
(7,7,7,'2025-03-12',2,2800,4.0),
(8,8,8,'2025-03-14',3,6000,4.5),
(9,9,9,'2025-03-15',5,9500,4.8),
(10,10,10,'2025-03-17',1,1200,3.7),
(11,11,11,'2025-03-18',2,2600,4.1),
(12,12,12,'2025-03-20',4,7200,4.6),
(13,13,13,'2025-03-21',3,6800,4.9),
(14,14,14,'2025-03-23',5,9800,4.7),
(15,15,15,'2025-03-25',2,3000,4.4),
(16,1,16,'2025-04-01',3,6500,5.0),
(17,5,17,'2025-04-03',2,7000,4.8),
(18,8,18,'2025-04-05',4,6000,4.3),
(19,9,19,'2025-04-07',3,9500,4.9),
(20,2,20,'2025-04-09',5,9000,4.5),
(21,6,1,'2025-04-11',2,11000,4.6),
(22,13,2,'2025-04-13',3,6800,4.7),
(23,3,6,'2025-04-15',1,2500,3.8),
(24,10,10,'2025-04-17',2,1200,3.5),
(25,14,14,'2025-04-19',4,9800,4.6);

-- ============================================================
-- TASKS
-- ============================================================

-- Task 1: Host Success -- Superhosts and total bookings received
SELECT
    h.host_name AS Host_Name,
    h.is_superhost AS Is_Superhost,
    COUNT(b.booking_id) AS Total_Bookings
FROM hosts h
INNER JOIN properties p ON h.host_id = p.host_id
INNER JOIN bookings b ON p.property_id = b.property_id
WHERE h.is_superhost = 'Yes'
GROUP BY h.host_name, h.is_superhost
ORDER BY Total_Bookings DESC;

-- Task 2: Property Revenue -- Revenue by property type
SELECT
    p.property_type AS Property_Type,
    SUM(b.nights * b.price_per_night) AS Total_Revenue
FROM properties p
INNER JOIN bookings b ON p.property_id = b.property_id
GROUP BY p.property_type
ORDER BY Total_Revenue DESC;

-- Task 3: Guest Demographics -- Average booking price by age group
SELECT
    CASE
        WHEN g.age < 25 THEN 'Under 25'
        WHEN g.age BETWEEN 25 AND 34 THEN '25-34'
        WHEN g.age BETWEEN 35 AND 44 THEN '35-44'
        ELSE '45 and above'
    END AS Age_Group,
    AVG(b.price_per_night) AS Avg_Booking_Price
FROM guests g
INNER JOIN bookings b ON g.guest_id = b.guest_id
GROUP BY Age_Group
ORDER BY Avg_Booking_Price DESC;

-- Task 4: Booking Origins -- Total bookings by nationality
SELECT
    g.nationality AS Nationality,
    COUNT(b.booking_id) AS Total_Bookings
FROM guests g
INNER JOIN bookings b ON g.guest_id = b.guest_id
GROUP BY g.nationality
ORDER BY Total_Bookings DESC;

-- Task 5: Rating Analysis -- Properties with average rating above 4.5
SELECT
    p.property_id AS Property_ID,
    p.property_type AS Property_Type,
    p.city AS City,
    AVG(b.rating) AS Average_Rating
FROM properties p
INNER JOIN bookings b ON p.property_id = b.property_id
GROUP BY p.property_id, p.property_type, p.city
HAVING AVG(b.rating) > 4.5
ORDER BY Average_Rating DESC;

USE AirbnbProject1;
SHOW TABLES;

USE AirbnbProject1;
DESCRIBE bookings;
DESCRIBE properties;

USE AirbnbProject1;
SELECT COUNT(*) AS total_bookings FROM bookings;
SELECT COUNT(*) AS total_properties FROM properties;

USE AirbnbProject1;
SELECT * FROM bookings LIMIT 5;



