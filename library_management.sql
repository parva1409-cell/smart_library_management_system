-- ============================================================
-- Smart Library Management System Database Schema & Queries
-- ============================================================

CREATE DATABASE IF NOT EXISTS library_db;
USE library_db;

-- ------------------------------------------------------------
-- Database Schema Setup (Tables & Relationships)
-- ------------------------------------------------------------

DROP TABLE IF EXISTS Transactions;
DROP TABLE IF EXISTS Books;
DROP TABLE IF EXISTS Authors;
DROP TABLE IF EXISTS Members;

-- Authors Table
CREATE TABLE Authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255)
);

-- Books Table
CREATE TABLE Books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author_id INT,
    category VARCHAR(100),
    isbn VARCHAR(20),
    published_date DATE,
    price DECIMAL(10, 2),
    available_copies INT DEFAULT 0,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id) ON DELETE SET NULL
);

-- Members Table
CREATE TABLE Members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    phone_number VARCHAR(20),
    membership_date DATE
);

-- Transactions Table
CREATE TABLE Transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT,
    book_id INT,
    borrow_date DATE NOT NULL,
    return_date DATE,
    fine_amount DECIMAL(10, 2) DEFAULT 0.00,
    FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE
);

-- ------------------------------------------------------------
-- Sample Data Insertion
-- ------------------------------------------------------------

INSERT INTO Authors (name, email) VALUES
('George Orwell', 'george@orwell.com'),
('J.K. Rowling', 'jkrowling@magic.com'),
('Isaac Asimov', 'asimov@sci-fi.com'),
('Agatha Christie', NULL),
('Robert Martin', 'unclebob@clean-code.com');

INSERT INTO Books (title, author_id, category, isbn, published_date, price, available_copies) VALUES
('1984', 1, 'Classic', '9780451524935', '1949-06-08', 15.99, 5),
('Harry Potter and the Philosopher''s Stone', 2, 'Fiction', '9780747532743', '1997-06-26', 25.50, 8),
('Foundation', 3, 'Science', '9780553293357', '1951-06-01', 520.00, 3),
('Clean Code', 5, 'Science', '9780132350884', '2008-08-01', 650.00, 4),
('Data Structures and Algorithms', 5, 'Science', '9780131103627', '2022-01-15', 550.00, 2),
('Murder on the Orient Express', 4, 'Mystery', '9780007119318', '1934-01-01', 12.00, 0);

INSERT INTO Members (name, email, phone_number, membership_date) VALUES
('John Doe', 'john.doe@email.com', '1234567890', '2021-03-15'),
('Alice Smith', NULL, '9876543210', '2023-01-10'),
('Bob Johnson', 'bob.j@gmail.com', '5551234567', '2020-05-20'),
('Charlie Brown', 'charlie@peanuts.com', '4449876543', '2024-02-01');

INSERT INTO Transactions (member_id, book_id, borrow_date, return_date, fine_amount) VALUES
(1, 1, CURRENT_DATE - INTERVAL 70 DAY, CURRENT_DATE - INTERVAL 50 DAY, 0.00),
(1, 3, CURRENT_DATE - INTERVAL 20 DAY, NULL, 0.00),
(2, 2, CURRENT_DATE - INTERVAL 200 DAY, CURRENT_DATE - INTERVAL 180 DAY, 5.00),
(3, 4, CURRENT_DATE - INTERVAL 10 DAY, CURRENT_DATE - INTERVAL 2 DAY, 0.00),
(1, 5, CURRENT_DATE - INTERVAL 5 DAY, NULL, 0.00);

-- ============================================================
-- TASKS & FUNCTIONALITIES
-- ============================================================

-- ------------------------------------------------------------
-- Task 1: Implement CRUD Operations
-- ------------------------------------------------------------

-- Insert new book, author, and member
INSERT INTO Authors (name, email) VALUES ('J.R.R. Tolkien', 'tolkien@middleearth.com');
INSERT INTO Books (title, author_id, category, isbn, published_date, price, available_copies) 
VALUES ('The Hobbit', LAST_INSERT_ID(), 'Classic', '9780261102217', '1937-09-21', 18.00, 6);
INSERT INTO Members (name, email, phone_number, membership_date) 
VALUES ('David Miller', 'david.m@example.com', '1112223333', CURRENT_DATE);

-- Update book availability after borrowing
UPDATE Books SET available_copies = available_copies - 1 WHERE book_id = 1;

-- Delete members who haven't borrowed any books in the last year
DELETE FROM Members 
WHERE member_id NOT IN (
    SELECT DISTINCT member_id FROM Transactions WHERE borrow_date >= CURRENT_DATE - INTERVAL 1 YEAR
);

-- Retrieve all books with available copies
SELECT * FROM Books WHERE available_copies > 0;

-- ------------------------------------------------------------
-- Task 2: Use SQL Clauses (WHERE, HAVING, LIMIT)
-- ------------------------------------------------------------

-- Get books published after 2015
SELECT * FROM Books WHERE published_date > '2015-12-31';

-- Retrieve the top 5 most expensive books
SELECT * FROM Books ORDER BY price DESC LIMIT 5;

-- Find members who joined before 2022
SELECT * FROM Members WHERE membership_date < '2022-01-01';

-- ------------------------------------------------------------
-- Task 3: Apply SQL Operators (AND, OR, NOT)
-- ------------------------------------------------------------

-- Get books where category = 'Science' AND price < 500
SELECT * FROM Books WHERE category = 'Science' AND price < 500;

-- Find all books that are NOT available for borrowing
SELECT * FROM Books WHERE available_copies <= 0;

-- List all members who joined after 2020 OR have borrowed more than 3 books
SELECT m.* 
FROM Members m
LEFT JOIN Transactions t ON m.member_id = t.member_id
WHERE m.membership_date > '2020-12-31'
GROUP BY m.member_id
HAVING COUNT(t.transaction_id) > 3 OR m.membership_date > '2020-12-31';

-- ------------------------------------------------------------
-- Task 4: Sorting & Grouping Data (ORDER BY, GROUP BY)
-- ------------------------------------------------------------

-- List all books sorted by title in alphabetical order
SELECT * FROM Books ORDER BY title ASC;

-- Display the number of books borrowed by each member
SELECT m.member_id, m.name, COUNT(t.transaction_id) AS books_borrowed
FROM Members m
LEFT JOIN Transactions t ON m.member_id = t.member_id
GROUP BY m.member_id, m.name;

-- Group books by category and show the total count
SELECT category, COUNT(*) AS total_books FROM Books GROUP BY category;

-- ------------------------------------------------------------
-- Task 5: Use Aggregate Functions (SUM, AVG, MAX, MIN, COUNT)
-- ------------------------------------------------------------

-- Find the total number of books in each category
SELECT category, SUM(available_copies) AS total_copies FROM Books GROUP BY category;

-- Calculate the average price of books in the library
SELECT AVG(price) AS average_book_price FROM Books;

-- Identify the most borrowed book
SELECT b.book_id, b.title, COUNT(t.transaction_id) AS borrow_count
FROM Books b
JOIN Transactions t ON b.book_id = t.book_id
GROUP BY b.book_id, b.title
ORDER BY borrow_count DESC LIMIT 1;

-- Calculate the total fines collected
SELECT SUM(fine_amount) AS total_fines_collected FROM Transactions;

-- ------------------------------------------------------------
-- Task 6: Establish Primary & Foreign Key Relationships
-- ------------------------------------------------------------
-- Foreign key relationships are defined during table creation. Verification query:
SELECT TABLE_NAME, COLUMN_NAME, CONSTRAINT_NAME, REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'library_db' AND REFERENCED_TABLE_NAME IS NOT NULL;

-- ------------------------------------------------------------
-- Task 7: Implement Joins
-- ------------------------------------------------------------

-- Retrieve a list of books along with their respective author names using INNER JOIN
SELECT b.title, a.name AS author_name 
FROM Books b 
INNER JOIN Authors a ON b.author_id = a.author_id;

-- Get details of members who have borrowed books using LEFT JOIN
SELECT DISTINCT m.* 
FROM Members m 
LEFT JOIN Transactions t ON m.member_id = t.member_id 
WHERE t.transaction_id IS NOT NULL;

-- Find books that haven't been borrowed using RIGHT JOIN
SELECT b.title 
FROM Transactions t 
RIGHT JOIN Books b ON t.book_id = b.book_id 
WHERE t.transaction_id IS NULL;

-- Show members who have never borrowed a book using FULL OUTER JOIN equivalent in MySQL
SELECT m.member_id, m.name 
FROM Members m 
LEFT JOIN Transactions t ON m.member_id = t.member_id 
WHERE t.transaction_id IS NULL;

-- ------------------------------------------------------------
-- Task 8: Use Subqueries
-- ------------------------------------------------------------

-- Find books that were borrowed by members who registered after 2022
SELECT DISTINCT b.title 
FROM Books b 
WHERE b.book_id IN (
    SELECT t.book_id 
    FROM Transactions t 
    JOIN Members m ON t.member_id = m.member_id 
    WHERE m.membership_date > '2022-12-31'
);

-- Identify the most borrowed book using a subquery
SELECT title FROM Books WHERE book_id = (
    SELECT book_id FROM Transactions GROUP BY book_id ORDER BY COUNT(*) DESC LIMIT 1
);

-- Get members who have never borrowed a book
SELECT * FROM Members WHERE member_id NOT IN (SELECT DISTINCT member_id FROM Transactions);

-- ------------------------------------------------------------
-- Task 9: Implement Date & Time Functions
-- ------------------------------------------------------------

-- Extract the year from published_date to count books by publication year
SELECT YEAR(published_date) AS pub_year, COUNT(*) AS book_count 
FROM Books 
GROUP BY YEAR(published_date);

-- Find difference in days between borrow_date and return_date to calculate late return fines
SELECT transaction_id, DATEDIFF(COALESCE(return_date, CURRENT_DATE), borrow_date) AS days_borrowed,
       CASE 
           WHEN DATEDIFF(COALESCE(return_date, CURRENT_DATE), borrow_date) > 14 
           THEN (DATEDIFF(COALESCE(return_date, CURRENT_DATE), borrow_date) - 14) * 1.50
           ELSE 0.00
       END AS calculated_fine
FROM Transactions;

-- Format borrow_date as DD-MM-YYYY
SELECT transaction_id, DATE_FORMAT(borrow_date, '%d-%m-%Y') AS formatted_borrow_date FROM Transactions;

-- ------------------------------------------------------------
-- Task 10: Use String Manipulation Functions
-- ------------------------------------------------------------

-- Convert all book titles to uppercase
SELECT UPPER(title) AS uppercase_title FROM Books;

-- Trim whitespace from author names
SELECT TRIM(name) AS clean_author_name FROM Authors;

-- Replace missing email values with "Not Provided"
SELECT name, COALESCE(email, 'Not Provided') AS email FROM Members;

-- ------------------------------------------------------------
-- Task 11: Implement Window Functions
-- ------------------------------------------------------------

-- Rank books based on the number of times they have been borrowed
SELECT b.title, COUNT(t.transaction_id) AS borrow_count,
       RANK() OVER (ORDER BY COUNT(t.transaction_id) DESC) AS book_rank
FROM Books b
LEFT JOIN Transactions t ON b.book_id = t.book_id
GROUP BY b.book_id, b.title;

-- Show the cumulative number of books borrowed per member
SELECT m.name, t.borrow_date,
       COUNT(t.transaction_id) OVER (PARTITION BY m.member_id ORDER BY t.borrow_date) AS cumulative_borrowed
FROM Members m
JOIN Transactions t ON m.member_id = t.member_id;

-- Display the moving average of books borrowed in the last 3 months
WITH MonthlyBorrows AS (
    SELECT DATE_FORMAT(borrow_date, '%Y-%m-01') AS borrow_month, COUNT(*) AS total_borrows
    FROM Transactions
    GROUP BY DATE_FORMAT(borrow_date, '%Y-%m-01')
)
SELECT borrow_month, total_borrows,
       AVG(total_borrows) OVER (ORDER BY borrow_month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_3_months
FROM MonthlyBorrows;

-- ------------------------------------------------------------
-- Task 12: Apply SQL CASE Expressions
-- ------------------------------------------------------------

-- Assign a Membership_Status column
SELECT m.name,
       CASE 
           WHEN EXISTS (
               SELECT 1 FROM Transactions t 
               WHERE t.member_id = m.member_id 
               AND t.borrow_date >= CURRENT_DATE - INTERVAL 6 MONTH
           ) THEN 'Active'
           ELSE 'Inactive'
       END AS Membership_Status
FROM Members m;

-- Categorize books
SELECT title, published_date,
       CASE 
           WHEN YEAR(published_date) > 2020 THEN 'New Arrival'
           WHEN YEAR(published_date) < 2000 THEN 'Classic'
           ELSE 'Regular'
       END AS Category_Type
FROM Books;