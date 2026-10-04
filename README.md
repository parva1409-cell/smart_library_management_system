# 📚 Smart Library Management System

A **MySQL-based Smart Library Management System** designed to manage books, authors, members, and library transactions efficiently.

## 📌 Overview

The **Smart Library Management System** is a relational database project developed using **MySQL**. It helps manage important library operations such as:

- 📖 Book management
- ✍️ Author information
- 👥 Member records
- 🔄 Book borrowing and returning
- 💰 Fine management
- 📊 Data analysis using SQL queries

The project demonstrates different SQL concepts including **CRUD operations, joins, subqueries, aggregate functions, date functions, string functions, window functions, and CASE expressions**.

---

## 🏗️ Database Structure

The database contains **4 main tables** connected using primary and foreign key relationships.

### ✍️ 1. Authors

Stores information about book authors.

| Column | Description |
|---|---|
| `author_id` | Primary Key, Auto Increment |
| `name` | Author name |
| `email` | Author email |

### 📖 2. Books

Stores information about books available in the library.

| Column | Description |
|---|---|
| `book_id` | Primary Key, Auto Increment |
| `title` | Book title |
| `author_id` | Foreign Key referencing `Authors` |
| `category` | Book category |
| `isbn` | ISBN number |
| `published_date` | Publication date |
| `price` | Book price |
| `available_copies` | Available book copies |

### 👥 3. Members

Stores library member registration and contact information.

| Column | Description |
|---|---|
| `member_id` | Primary Key, Auto Increment |
| `name` | Member name |
| `email` | Member email |
| `phone_number` | Contact number |
| `membership_date` | Membership registration date |

### 🔄 4. Transactions

Records book borrowing and returning activities.

| Column | Description |
|---|---|
| `transaction_id` | Primary Key, Auto Increment |
| `member_id` | Foreign Key referencing `Members` |
| `book_id` | Foreign Key referencing `Books` |
| `borrow_date` | Date when book was borrowed |
| `return_date` | Date when book was returned |
| `fine_amount` | Fine amount |

---

## 🛠️ SQL Concepts Implemented

The `library_management.sql` file demonstrates the following SQL functionalities:

### 1️⃣ CRUD Operations
- `INSERT` – Add records
- `UPDATE` – Update existing records
- `DELETE` – Remove records
- `SELECT` – Retrieve records

### 2️⃣ Filtering
Uses:
- `WHERE`
- `HAVING`
- `LIMIT`

### 3️⃣ Logical Operators
Uses:
- `AND`
- `OR`
- `NOT`

### 4️⃣ Grouping & Sorting
Uses:
- `GROUP BY`
- `ORDER BY`

### 5️⃣ Aggregate Functions
Uses:
- `SUM()`
- `AVG()`
- `COUNT()`
- `MAX()`
- `MIN()`

### 6️⃣ Constraints
Implements:
- 🔑 `PRIMARY KEY`
- 🔗 `FOREIGN KEY`

These constraints help maintain data integrity between related tables.

### 7️⃣ SQL Joins
The project demonstrates:
- `INNER JOIN`
- `LEFT JOIN`
- `RIGHT JOIN`
- Full outer join logic

### 8️⃣ Subqueries
Nested queries are used for dynamic filtering and data analysis.

### 9️⃣ Date & Time Functions
Used for:
- Extracting publication years
- Calculating overdue days
- Formatting dates

### 🔟 String Functions
Uses:
- `UPPER()`
- `TRIM()`
- `COALESCE()`

### 1️⃣1️⃣ Window Functions
The project demonstrates:
- `RANK()`
- Running totals
- Rolling 3-month moving averages

### 1️⃣2️⃣ CASE Expressions
Used to categorize:
- 👤 Member activity — `Active` / `Inactive`
- 📚 Book publication status — `Classic` / `New Arrival` / `Regular`

---

## 🚀 How to Run

Follow these steps to run the project:

### Step 1️⃣ — Clone the Repository

Clone or download this repository to your computer.

### Step 2️⃣ — Open MySQL

Open **MySQL Workbench** or another MySQL-compatible SQL editor.

### Step 3️⃣ — Connect to MySQL Server

Connect to your local MySQL server.

### Step 4️⃣ — Open the SQL File

Open:

```text
library_management.sql
```

### Step 5️⃣ — Execute the Script

Run the complete SQL script.

The script will:

- 🗄️ Create the database
- 📋 Create the required tables
- 📝 Insert sample records
- 🔗 Establish table relationships
- 📊 Execute different SQL queries

---

## 📁 Project Structure

```text
Smart-Library-Management-System/
│
├── 📄 library_management.sql
└── 📄 README.md
```

---

## 🎯 Project Objectives

The main objectives of this project are:

- 📚 Efficiently manage library records
- 🔗 Understand relational database design
- 🧑‍💻 Practice MySQL and SQL queries
- 📊 Perform data analysis using SQL
- 🔐 Maintain data integrity using constraints
- 🚀 Apply advanced SQL concepts in a practical project

---

## 🧰 Technologies Used

- 🐬 **MySQL**
- 🛠️ **MySQL Workbench**
- 💻 **SQL**

---
