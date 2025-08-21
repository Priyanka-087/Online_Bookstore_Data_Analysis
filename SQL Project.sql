--create table
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
	Book_ID SERIAL PRIMARY KEY,
	Title VARCHAR(100),
	Author VARCHAR(100),
	Genre VARCHAR(100),
	Published_Year INT,
	Price NUMERIC(10,2),
	Stock INT
);

DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers (
	 Customer_ID SERIAL PRIMARY KEY,
	 Name VARCHAR(100),
	 Email VARCHAR(100),
	 Phone VARCHAR(15),
	 City VARCHAR(50),
	 Country VARCHAR(150)
);

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
	Order_ID SERIAL PRIMARY KEY,
	Customer_ID INT REFERENCES Customers(Customer_ID),
	Book_ID INT REFERENCES Books(Book_ID),
	Order_Date DATE,
	Quantity INT,
	Total_Amount NUMERIC(10,2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- Import Data into Books Table
COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock) 
FROM 'C:\Users\priya\OneDrive\Desktop\Data Analyst\SQL\SQL Project\ST - SQL ALL PRACTICE FILES\All Excel Practice Files\Books.csv' 
CSV HEADER;

-- Import Data into Customers Table
COPY Customers(Customer_ID, Name, Email, Phone, City, Country) 
FROM 'C:\Users\priya\OneDrive\Desktop\Data Analyst\SQL\SQL Project\ST - SQL ALL PRACTICE FILES\All Excel Practice Files\Customers.csv' 
CSV HEADER;

-- Import Data into Orders Table
COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount) 
FROM 'C:\Users\priya\OneDrive\Desktop\Data Analyst\SQL\SQL Project\ST - SQL ALL PRACTICE FILES\All Excel Practice Files\Orders.csv' 
CSV HEADER;




--Q1. Retieve all books in the "fiction" genre.
SELECT * FROM Books 
WHERE genre = 'Fiction';

--Q2. Find books published after the year 1950.
SELECT * FROM Books
WHERE published_year > 1950;

--Q3. List all customers from Canada.
SELECT * FROM Customers
WHERE country = 'Canada';

--Q4. Show orders placed in November 2023.
SELECT * FROM Orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

--Q5. Retrieve total stock of books available.
SELECT SUM(stock) AS total_stock FROM Books;

--Q6. Find the details of most expensive book.
SELECT * FROM Books
ORDER BY price DESC
LIMIT 1;

--Q7. Show all cutomers who ordered more than 1 quantity of book.
SELECT * FROM Orders 
WHERE quantity > 1;

--Q8. Retrieve all orders where the total amount exceeds $20.
SELECT * FROM Orders 
WHERE total_amount > 20;

--Q9. List all genre available in the book table.
SELECT DISTINCT genre FROM Books;

--Q10. Find the book with the lowest stock.
SELECT * FROM Books
ORDER BY stock ASC
LIMIT 1;

--Q11. Calculate total revenue generated from all orders.
SELECT SUM(total_amount) AS total_revenue FROM Orders;



--**__Advanced_Questions__**--

--Q1. Retrieve the total number of books sold for each genre.
SELECT b.genre, SUM(o.quantity)
FROM Books b
JOIN Orders o
ON b.book_id = o.book_id
GROUP BY b.genre;

--Q2. Find the average price of books in the 'Fantasy' genre.
SELECT AVG(price) AS avg_priceFantasy FROM Books
WHERE genre = 'Fantasy';

--Q3. List customers who have placed at least 2 orders.
SELECT o.customer_id, c.name, COUNT(o.order_id) AS order_count
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT(order_id) >= 2;

--Q4. Find the most frequently ordered book.
SELECT o.book_id, b.title, COUNT(o.order_id) AS order_count
FROM Orders o
JOIN Books b
ON b.book_id = o.book_id
GROUP BY o.book_id, b.title 
ORDER BY order_count DESC 
LIMIT 1;

--Q5. Show the top 3 most expensive books of 'Fantasy' genre.
SELECT * FROM Books
WHERE genre = 'Fantasy'
ORDER BY price DESC
LIMIT 3;

--Q6. Retrieve the total quantity of books sold by each Author.
SELECT b.author, SUM(o.quantity) AS  total_bookSold
FROM Orders o
JOIN Books b
ON b.book_id = o.book_id 
GROUP BY b.author;

--Q7. List the cities where customers who spent over $30 are located.
SELECT DISTINCT c.city, total_amount
FROM orders o
JOIN customers c
ON c.customer_id = o.customer_id
WHERE o.total_amount > 30;

--Q8. Find the customer who spent most on oders.
SELECT c.customer_id, c.name, SUM(o.total_amount) AS total_spent
FROM orders o
JOIN customers c
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC
LIMIT 1;

--Q9. Calculate the stock remaining after fulfilling all orders.
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity), 0) AS order_quantity,
	b.stock - COALESCE(SUM(o.quantity), 0) AS remaining_stock
FROM books b
LEFT JOIN orders o
ON b.book_id = o.book_id
GROUP BY b.book_id
ORDER BY b.book_id;