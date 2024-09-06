![Library Management System Sql Project](https://github.com/obshake/Library-Management-System/blob/main/lms_header.jpg)

# Library Management System using SQL

## Overview
This project demonstrates a Library Management System implemented using SQL. It covers database creation, management, and querying. The primary goal is to showcase skills in database design, CRUD operations, and advanced SQL queries.

## Project Title
**Library Management System**

## Database
**library_db**

## Objectives
1. **Database Setup**:
   - Create and populate the database with tables for branches, employees, members, books, issued status, and return status.

2. **CRUD Operations**:
   - Perform Create, Read, Update, and Delete operations on the data.

3. **CTAS (Create Table As Select)**:
   - Utilize CTAS to create new tables based on query results.

4. **Advanced SQL Queries**:
   - Develop complex queries to analyze and retrieve specific data.
  
# Database Structure

## Entities and Relationships

The project database consists of the following main entities:

1. **Branch**: Represents different library branches and their respective managers.
2. **Employees**: Library employees, associated with branches.
3. **Members**: Registered members who borrow books.
4. **Books**: Books available for borrowing.
5. **Issued Status**: Tracks books issued to members.
6. **Return Status**: Tracks book returns and their conditions.

## Entity-Relationship Diagram (ERD)

The ERD visualizes the relationships between the entities in the library management system. 

![ERD Diagram](https://github.com/obshake/Library-Management-System/blob/main/erd_diagram.png)

## Project Structure

### 1. Database Setup

The first step is to create the database and define the schema. Each table is designed with appropriate columns and constraints to ensure data integrity.

**Database Creation**:
```sql
CREATE DATABASE library_db;
```
**Tables Creation**
```sql
-- Creating the Branch table
DROP TABLE IF EXISTS branch;
CREATE TABLE branch 
(
    branch_id VARCHAR(10) PRIMARY KEY,
    manager_id VARCHAR(10),
    branch_address VARCHAR(55),
    contact_no VARCHAR(15)
);

-- Creating the Employees table
DROP TABLE IF EXISTS employees;
CREATE TABLE employees
(
    emp_id VARCHAR(10) PRIMARY KEY,
    emp_name VARCHAR(25),
    position VARCHAR(15),
    salary FLOAT,
    branch_id VARCHAR(10) -- Foreign Key to branch table
);

-- Creating the Books table
DROP TABLE IF EXISTS books;
CREATE TABLE books
(
    isbn VARCHAR(20) PRIMARY KEY,
    book_title VARCHAR(75),
    category VARCHAR(20),
    rental_price FLOAT,
    status VARCHAR(15), -- Tracks if book is available or issued
    author VARCHAR(35),
    publisher VARCHAR(60)
);

-- Creating the Members table
DROP TABLE IF EXISTS members;
CREATE TABLE members
(
    member_id VARCHAR(10) PRIMARY KEY,
    member_name VARCHAR(25),
    member_address VARCHAR(75),
    reg_date DATE -- Date of membership registration
);

-- Creating the Issued Status table (to track book issues)
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status
(
    issued_id VARCHAR(10) PRIMARY KEY,
    issued_member_id VARCHAR(10), -- Foreign Key to members table
    issued_book_name VARCHAR(75),
    issued_date DATE,
    issued_book_isbn VARCHAR(25), -- Foreign Key to books table
    issued_emp_id VARCHAR(15) -- Foreign Key to employees table
);

-- Creating the Return Status table (to track book returns)
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status
(
    return_id VARCHAR(10) PRIMARY KEY,
    issued_id VARCHAR(10), -- Foreign Key to issued_status table
    return_book_name VARCHAR(75),
    return_date DATE,
    return_book_isbn VARCHAR(20),
    book_quality VARCHAR(15) DEFAULT 'Good' -- Condition of the returned book
);
```
**Adding Constraints**
```sql
-- Adding Foreign Keys
ALTER TABLE issued_status
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES members(member_id);

ALTER TABLE issued_status
ADD CONSTRAINT fk_books
FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn);

ALTER TABLE issued_status
ADD CONSTRAINT fk_employees
FOREIGN KEY (issued_emp_id)
REFERENCES employees(emp_id);

ALTER TABLE employees
ADD CONSTRAINT fk_branch
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id);

ALTER TABLE return_status
ADD CONSTRAINT fk_return
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id);
```
### 2. Adding Data to Tables

To populate the tables with sample data, you can use the following SQL commands. Adjust the file paths as needed:

```sql
-- Importing data into the Books table
COPY books
FROM 'D:/AssignMents/Sql Projects/Library Managemnet/DataSet/books.csv'
DELIMITER ','
CSV HEADER;

-- Importing data into the Branch table
COPY branch
FROM 'D:/AssignMents/Sql Projects/Library Managemnet/DataSet/branch.csv'
DELIMITER ','
CSV HEADER;

-- Importing data into the Employees table
COPY employees
FROM 'D:/AssignMents/Sql Projects/Library Managemnet/DataSet/employees.csv'
DELIMITER ','
CSV HEADER;

-- Importing data into the Members table
COPY members
FROM 'D:/AssignMents/Sql Projects/Library Managemnet/DataSet/members.csv'
DELIMITER ','
CSV HEADER;

-- Importing data into the Issued Status table
COPY issued_status
FROM 'D:/AssignMents/Sql Projects/Library Managemnet/DataSet/issued_status.csv'
DELIMITER ','
CSV HEADER;

-- Importing data into the Return Status table
COPY return_status
FROM 'D:/AssignMents/Sql Projects/Library Managemnet/DataSet/return_status.csv'
DELIMITER ','
CSV HEADER;

-- Adding book_quality column to return_status table with some random values
ALTER TABLE return_status
ADD COLUMN book_quality VARCHAR(15) DEFAULT ('Good');

UPDATE return_status
SET book_quality = 'Damaged'
WHERE issued_id 
    IN ('IS112', 'IS117', 'IS118');
```
### 3.CRUD Operations
**Create:** Inserted sample records into the books table.
```sql
INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
```
**Read:** Retrieved and displayed data from various tables.
```sql
SELECT * FROM books;
```
**Update:** Updated records in the employees table.
```sql
UPDATE members
SET member_address = '125 Oak St'
WHERE member_id = 'C103';
```
**Delete:** Removed records from the members table as needed.
```sql
DELETE FROM issued_status
WHERE issued_id = 'IS121';
```
### 4.CTAS (Create Table As Select)
```sql
CREATE TABLE book_issued_cnt AS
SELECT b.isbn, b.book_title, COUNT(ist.issued_id) AS issue_count
FROM issued_status AS ist
JOIN books AS b
ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title;
```
### 5.Data Analysis & Findings
**Retrieve All Books in a Specific Category:**
```sql
SELECT *
FROM books
WHERE category = 'Classic';
```

**Find total rental income by category**
```sql
SELECT b.category, SUM(b.rental_price * bic.issue_cnt) AS total_income
FROM book_issued_cnt AS bic
JOIN books AS b
ON b.isbn = bic.isbn
GROUP BY b.category;
```
**Members Who have issued More than one book**
```sql
SELECT issued_member_id, COUNT(*) AS books_count
FROM issued_status
GROUP BY issued_member_id
HAVING COUNT(*) > 1;
```
**List members who registered in the last 180 days**
```sql
SELECT *
FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';
```

**List employees with their branch manager's name**
```sql
SELECT e1.emp_id, e1.emp_name, e1.position, e1.salary, b.*, e2.emp_name AS manager
FROM employees AS e1
JOIN branch AS b ON e1.branch_id = b.branch_id
JOIN employees AS e2 ON e2.emp_id = b.manager_id
WHERE e1.emp_id != b.manager_id;
```
**Retrieve the list of books not yet returned**
```sql
SELECT *
FROM issued_status
WHERE issued_id NOT IN (SELECT issued_id FROM return_status);
```
**Identify members with overdue books**
```sql
SELECT m.member_id, m.member_name, b.isbn, b.book_title, ist.issued_id, ist.issued_date, 
(CURRENT_DATE - ist.issued_date) AS days_overdue
FROM issued_status AS ist
JOIN members AS m ON m.member_id = ist.issued_member_id
JOIN books AS b ON ist.issued_book_isbn = b.isbn
LEFT JOIN return_status AS r ON r.issued_id = ist.issued_id
WHERE r.return_date IS NULL AND (CURRENT_DATE - ist.issued_date) > 30
ORDER BY m.member_id;
```
**List employees with their branch manager's name**
```sql
SELECT e1.emp_id, e1.emp_name, e1.position, e1.salary, b.*, e2.emp_name AS manager
FROM employees AS e1
JOIN branch AS b ON e1.branch_id = b.branch_id
JOIN employees AS e2 ON e2.emp_id = b.manager_id
WHERE e1.emp_id != b.manager_id;
```
**Branch Performance Report**
```sql
SELECT br.branch_id, br.manager_id, COUNT(issued_id) AS books_issued, SUM(b.rental_price) AS total_revenue
FROM issued_status AS ist
LEFT JOIN books AS b
ON b.isbn = ist.issued_book_isbn
LEFT JOIN employees AS e
ON ist.issued_emp_id = e.emp_id
LEFT JOIN branch AS br
ON e.branch_id = br.branch_id
GROUP BY br.branch_id;
```
**List of Active Members(Members who have atleast one book in last 5 months)**
```sql
SELECT ist.issued_member_id
FROM issued_status AS ist
GROUP BY ist.issued_member_id
HAVING MAX(issued_date) + INTERVAL '5months' <= CURRENT_DATE;
```
**List of members who never rented any book**
```sql
SELECT *
FROM members
WHERE member_id NOT IN (SELECT issued_member_id FROM issued_status);
```
**Find Employees with Most books issued**
```sql
SELECT ist.issued_emp_id, COUNT(*) AS books_issued
FROM issued_status AS ist
GROUP BY ist.issued_emp_id
HAVING COUNT(*) >=3
ORDER BY books_issued DESC;
```
**Employees with the highest salary in each branch**
```sql
SELECT emp_name, salary, branch_id
FROM employees
WHERE (branch_id, salary) IN 
(SELECT branch_id, MAX(salary) FROM employees GROUP BY branch_id);
```

### Advance sql Queries
**Update Book Status on Return**
This query automatically creates new return_id with current date as return_date with user provided inputs(issued_id, book_quality) will update book status in books table to yes when a book is returned.
```sql
CREATE OR REPLACE PROCEDURE add_return_records(p_issued_id VARCHAR(10), p_book_quality VARCHAR(15))
LANGUAGE plpgsql
AS $$

--Declaring Variables
DECLARE
v_isbn VARCHAR(25);
v_returnId VARCHAR(10);
v_bookName VARCHAR(75);
v_maxId INT;

BEGIN

--Generating New Return Id

SELECT COALESCE(MAX(CAST(SUBSTRING(return_id,3) AS INT)),0) INTO v_maxId
FROM return_status;

v_returnId = 'RS' || (v_maxId + 1);

-- Fetching issued book isbn and name

SELECT issued_book_isbn INTO v_isbn
FROM issued_status
WHERE issued_id = p_issued_id;

SELECT book_title INTO v_bookName
FROM books
WHERE isbn = v_isbn;

--Inserting Values into return table

INSERT INTO return_status(return_id, issued_id, return_date, book_quality)
VALUES
(v_returnId, p_issued_id, CURRENT_DATE, p_book_quality);

--Updating books status

UPDATE books
SET status ='yes'
WHERE isbn = v_isbn;

--Display a notice message after successfully returning the book

RAISE NOTICE 'Thank You for Returning %', v_bookName;

END;
$$;
-- Entering a New record
call add_return_records ('IS130', 'Good');
```
**Update Book Status on Issue**
This query automatically creates new issued_id and current date as issued_date with user provided inputs(isbn, member_id, emp_id) will update book status in books table to no when a book is issued.
```sql
CREATE OR REPLACE PROCEDURE add_issued_records(p_isbn VARCHAR(25), p_member_id VARCHAR(10), p_emp_id VARCHAR(15))
LANGUAGE plpgsql
AS $$

DECLARE
v_new_issued_id VARCHAR(10);
v_max_issued_id INT;
v_book_name VARCHAR(75);


BEGIN

-- Selecting issue id
SELECT COALESCE(MAX(CAST(SUBSTRING(issued_id,3)AS INT)),0) INTO v_max_issued_id
FROM issued_status;

v_new_issued_id = 'IS' || (v_max_issued_id + 1);

--selecting book name

SELECT book_title INTO v_book_name
FROM books
WHERE isbn = p_isbn;

INSERT INTO issued_status(issued_id,issued_member_id,issued_book_name,issued_date,issued_book_isbn,issued_emp_id)
VALUES(v_new_issued_id, p_member_id, v_book_name, CURRENT_DATE, p_isbn, p_emp_id);

UPDATE books
SET status = 'no'
WHERE isbn = p_isbn;


END;
$$;
-- Issuing a book
CALL add_issued_records('978-0-7432-4722-4','C118', 'E109' )
```
