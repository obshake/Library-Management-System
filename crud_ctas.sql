-- File: crud_ctas.sql

-- Inserted sample records into the books table.

INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

-- Retrieved and displayed data from various tables.

SELECT * FROM books;

-- Updated records in the employees table.

UPDATE members
SET member_address = '125 Oak St'
WHERE member_id = 'C103';

-- Removed records from the members table as needed.

DELETE FROM issued_status
WHERE issued_id = 'IS121';

-- CTAS (Create Table As Select)

CREATE TABLE book_issued_cnt AS
SELECT b.isbn, b.book_title, COUNT(ist.issued_id) AS issue_count
FROM issued_status AS ist
JOIN books AS b
ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title;


