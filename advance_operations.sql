-- Filename : advance_operations.sql

-- Update Book Status on Return
-- Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).


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

SELECT COALESCE(MAX(CAST(SUBSTRING(return_id,3) AS INT)),0)
INTO v_maxId
FROM return_status;

v_returnId = 'RS' || (v_maxId + 1);

-- Fetching issued book isbn and name

SELECT issued_book_isbn
INTO v_isbn
FROM issued_status
WHERE issued_id = p_issued_id;

SELECT book_title
INTO v_bookName
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

-- Adding a new Return

call add_return_records ('IS130', 'Good');


-- Update Book Status on Issue
-- Write a query to update the status of books in the books table to "no" when they are issued (based on entries in the issued_status table).

CREATE OR REPLACE PROCEDURE add_issued_records(p_isbn VARCHAR(25), p_member_id VARCHAR(10), p_emp_id VARCHAR(15))
LANGUAGE plpgsql
AS $$

DECLARE
v_new_issued_id VARCHAR(10);
v_max_issued_id INT;
v_book_name VARCHAR(75);


BEGIN

-- Selecting issue id
SELECT COALESCE(MAX(CAST(SUBSTRING(issued_id,3)AS INT)),0)
INTO v_max_issued_id
FROM issued_status;

v_new_issued_id = 'IS' || (v_max_issued_id + 1);

--selecting book name

SELECT book_title
INTO v_book_name
FROM books
WHERE isbn = p_isbn;

INSERT INTO issued_status(issued_id,issued_member_id,issued_book_name,issued_date,issued_book_isbn,issued_emp_id)
VALUES(v_new_issued_id, p_member_id, v_book_name, CURRENT_DATE, p_isbn, p_emp_id);

UPDATE books
SET status = 'no'
WHERE isbn = p_isbn;


END;
$$;

--issuing book

CALL add_issued_records('978-0-7432-4722-4','C118', 'E109' );

