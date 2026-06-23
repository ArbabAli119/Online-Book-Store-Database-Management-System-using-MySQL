CREATE DATABASE OnlineBookstore;
USE OnlineBookstore;

DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Books;

CREATE TABLE Books (
    Book_ID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price DECIMAL(10,2),
    Stock INT
);

CREATE TABLE Customers (
    Customer_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);

CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);


-- BASIC QUERIES
-- Import Directly Via Table Data Import WizardBooks

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


-- 1) Retrieve All book In the "Fiction" Genre;
SELECT * FROM Books
WHERE Genre = 'Fiction';

-- 2) Find The Book Published After 1950 

SELECT * FROM Books
WHERE Published_Year > 1950;

-- 3) List All The Customer From Canada

SELECT * FROM Customers
WHERE Country = 'Canada';

-- 4) Show order placed in November 2023

SELECT * FROM Orders
WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30';

-- PUBLISHED YEAR BETWEEN 1990 TO 2000 ASC

SELECT * FROM Books
WHERE Published_Year BETWEEN 1990 AND 2000
ORDER BY Published_Year ;

-- 5) TOTAL STOCK OF BOOK AVILABLE

SELECT
SUM(Stock) AS Total_Stock
FROM Books;

-- 6) DETAILS OF MOST EXPENSIVE BOOK

SELECT * FROM Books
ORDER BY Price DESC 
LIMIT 1;

-- 7) SHOW ALL THE CUSTOMER WHO ORDER MORE THAN 1 BOOK

SELECT * FROM Orders
WHERE Quantity > 5;

-- 8) ALL THE ORDER WHERE TOTAL AMOUNT EXCEED 20

SELECT * FROM Orders
WHERE Total_Amount > 100;

-- 9) LIST ALL THE GENRES Available In Books Table

 SELECT DISTINCT Genre FROM Books;
 
 -- 10) FIND THE BOOK WITH LOWEST STOCK
 
 SELECT * FROM Books
ORDER BY Stock 
LIMIT 5;


SELECT *
FROM Books
WHERE Stock = (
    SELECT MIN(Stock)
    FROM Books
);

-- 11) Total Revenue Generated from All orders

SELECT SUM(Total_Amount) AS Revenue FROM Orders;

-- ADVANCE QUERIES
-- 12) TOTAL NO OF KS SOLD BY EACH GENRE

SELECT B.Genre, SUM(O.Quantity) AS TOTAL_SOLD 
FROM Orders O 
JOIN Books B ON O.Book_ID = B.Book_ID
GROUP BY B.Genre;

-- 13) Find The Average Price of book in the fantasy

SELECT AVG(Price) AS Average_Price
FROM Books
WHERE Genre = 'Fantasy';

-- 14) Customer Who passed the At least 2 Order 

SELECT  Customer_ID , COUNT(Order_ID) AS Order_Count
FROM Orders
GROUP BY Customer_ID
HAVING COUNT(Order_ID) >= 2;

-- 15) With Name

SELECT  O.Customer_ID , C.Name, COUNT(O.Order_ID) AS Order_Count
FROM Orders O
JOIN Customers C ON  O.Customer_ID = C.Customer_ID
GROUP BY O.Customer_ID
HAVING COUNT(Order_ID) >= 2;

-- 16) Find the Most Frequently Order book

 SELECT O.Book_ID,
       B.Title,
       COUNT(O.Order_ID) AS Order_Count
FROM Orders O
JOIN Books B
    ON O.Book_ID = B.Book_ID
GROUP BY O.Book_ID, B.Title
ORDER BY Order_Count DESC
LIMIT 1;

-- 17) SHOW THE TOP 3 EXPENSIVE BOOK FROM FANTACY GENRE
SELECT * FROM Books
WHERE Genre = 'fantasy'
ORDER BY Price DESC
LIMIT 3;

-- 18) RETRIEVE THE TOTAL QUANTITY OF BOOK SOLD BY EACH AUTHOR 
SELECT B.Author , SUM(O.Quantity) AS Total_Sold
FROM Orders O
JOIN Books B ON O.Book_ID = B.Book_ID
GROUP BY B.Author
ORDER BY Total_Sold DESC
LIMIT 5;

-- 19) List The City Where Cstomer who spend over $200 
 
SELECT DISTINCT C.City , Total_Amount 
FROM Orders O
JOIN Customers C ON O.Customer_ID = C.Customer_ID
WHERE O.Total_Amount > 200;

-- 20) FIND THE CUSTOMER WHO SPEND MOST 

SELECT C.Customer_ID, C.Name, SUM(O.Total_Amount) AS Total_Spend 
FROM Orders O 
JOIN Customers C ON O.Customer_ID = C.Customer_ID
GROUP BY C.Customer_ID, C.Name
ORDER BY Total_Spend DESC
LIMIT 1;

-- 21) STOCK REMAINING AFTER FULFILLING ALL ORDERS

SELECT B.Book_ID,
       B.Title,
       B.Stock,
       COALESCE(SUM(O.Quantity), 0) AS Total_Ordered,
       B.Stock - COALESCE(SUM(O.Quantity), 0) AS Remaining_Stock
FROM Books B
LEFT JOIN Orders O
       ON B.Book_ID = O.Book_ID
GROUP BY B.Book_ID
ORDER BY B.Book_ID;
















