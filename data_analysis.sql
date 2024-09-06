-- File: data_analysis.sql

-- Retrieve all books in the "Classic" category
SELECT *
FROM books
WHERE category = 'Classic';

-- Find total rental income by category
SELECT b.category, SUM(b.rental_price * bic.issue_cnt) AS total_income
FROM book_issued_cnt AS bic
JOIN books AS b
ON b.isbn = bic.isbn
GROUP BY b.category;

-- List members who have issued more than one book
SELECT issued_member_id, COUNT(*) AS books_count
FROM issued_status
GROUP BY issued_member_id
HAVING COUNT(*) > 1;

-- List members who registered in the last 180 days
SELECT *
FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';

-- Retrieve the list of books not yet returned
SELECT *
FROM issued_status
WHERE issued_id NOT IN (SELECT issued_id FROM return_status);

-- Identify members with overdue books
SELECT m.member_id, m.member_name, b.isbn, b.book_title, ist.issued_id, ist.issued_date, 
(CURRENT_DATE - ist.issued_date) AS days_overdue
FROM issued_status AS ist
JOIN members AS m ON m.member_id = ist.issued_member_id
JOIN books AS b ON ist.issued_book_isbn = b.isbn
LEFT JOIN return_status AS r ON r.issued_id = ist.issued_id
WHERE r.return_date IS NULL AND (CURRENT_DATE - ist.issued_date) > 30
ORDER BY m.member_id;

-- List employees with their branch manager's name
SELECT e1.emp_id, e1.emp_name, e1.position, e1.salary, b.*, e2.emp_name AS manager
FROM employees AS e1
JOIN branch AS b ON e1.branch_id = b.branch_id
JOIN employees AS e2 ON e2.emp_id = b.manager_id
WHERE e1.emp_id != b.manager_id;

-- Branch Performance Report
SELECT br.branch_id, br.manager_id, COUNT(issued_id) AS books_issued, SUM(b.rental_price) AS total_revenue
FROM issued_status AS ist
LEFT JOIN books AS b
ON b.isbn = ist.issued_book_isbn
LEFT JOIN employees AS e
ON ist.issued_emp_id = e.emp_id
LEFT JOIN branch AS br
ON e.branch_id = br.branch_id
GROUP BY br.branch_id;

-- List of Active Members(Members who have atleast one book in last 5 months)
SELECT ist.issued_member_id
FROM issued_status AS ist
GROUP BY ist.issued_member_id
HAVING MAX(issued_date) + INTERVAL '5months' <= CURRENT_DATE;

-- List of members who never rented any book
SELECT *
FROM members
WHERE member_id NOT IN (SELECT issued_member_id FROM issued_status);

-- Find Employees with Most books issued
SELECT ist.issued_emp_id, COUNT(*) AS books_issued
FROM issued_status AS ist
GROUP BY ist.issued_emp_id
HAVING COUNT(*) >=3
ORDER BY books_issued DESC;

-- Employees with the highest salary in each branch
SELECT emp_name, salary, branch_id
FROM employees
WHERE (branch_id, salary) IN 
(SELECT branch_id, MAX(salary) FROM employees GROUP BY branch_id);