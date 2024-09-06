-- File: adding_data.sql

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
