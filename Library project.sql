CREATE TABLE books_table (
	isbn VARCHAR (29) PRIMARY KEY,
	book_title	VARCHAR (209),
	category VARCHAR (29),
	rental_price FLOAT,
	status	VARCHAR (20),
	author	VARCHAR (80),
	publisher VARCHAR (80)
);

CREATE TABLE branch_table(
	branch_id VARCHAR (15) PRIMARY KEY,
	manager_id	VARCHAR (15),
	branch_address	VARCHAR (25),
	contact_no VARCHAR (15)

);

CREATE TABLE employee_table (
	emp_id	VARCHAR PRIMARY KEY (15),
	emp_name VARCHAR (25),
	positions VARCHAR (15),
	salary	INT,
	branch_id VARCHAR (15) --FK
);

CREATE TABLE issued_status (
	issued_id VARCHAR (10) PRIMARY KEY,
	issued_member_id	VARCHAR (10), --FK
	issued_book_name	VARCHAR (100),
	issued_date	DATE,
	issued_book_isbn	VARCHAR (35), --FK
	issued_emp_id VARCHAR (35) --FK

);

CREATE TABLE members_table (
	member_id VARCHAR (10) PRIMARY KEY,
	member_name	VARCHAR(50),
	member_address	VARCHAR(100),
	reg_date DATE
);


CREATE TABLE return_table(
	return_id VARCHAR (10) PRIMARY KEY,
	issued_id	VARCHAR (20), --FK
	return_book_name VARCHAR (80),
	return_date	DATE,
	return_book_isbn VARCHAR (35) --FK
);

--DEFINE FOREIGN KEY TO CREATE A RELATIONSHIP AMONGST THE TABLES
ALTER TABLE issued_status
ADD CONSTRAINT foreign_key_members
FOREIGN KEY (issued_member_id)
REFERENCES members_table (member_id);

ALTER TABLE issued_status
ADD CONSTRAINT foreign_key_books
FOREIGN KEY (issued_book_isbn)
REFERENCES books_table (isbn);

ALTER TABLE issued_status
ADD CONSTRAINT foreign_key_employee_table
FOREIGN KEY (issued_emp_id)
REFERENCES employee_table (emp_id);

ALTER TABLE employee_table
ADD CONSTRAINT foreign_key_branch_table
FOREIGN KEY (branch_id)
REFERENCES branch_table( branch_id);

ALTER TABLE return_table
ADD CONSTRAINT foreign_key_issued_status
FOREIGN KEY (issued_id)
REFERENCES issued_status (issued_id);

--PROJECT TASKS
--Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')
INSERT INTO books_table(isbn, book_title, category, rental_price, status, author, publisher)
VALUES
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');



-- Task 2: Update an Existing Member's Address
UPDATE members_table
SET member_address = '125 Main St'
WHERE member_id = 'C101';



-- Task 3: Delete a Record from the Issued Status Table 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

SELECT * FROM issued_status
WHERE issued_id = 'IS121';

DELETE FROM issued_status
WHERE issued_id = 'IS121'


-- Task 4: Retrieve All Books Issued by a Specific Employee 
-- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT * FROM issued_status
WHERE issued_emp_id = 'E101';


-- Task 5: List Members Who Have Issued More Than One Book 
-- Objective: Use GROUP BY to find members who have issued more than one book.

SELECT 
    iss.issued_emp_id,
     e.emp_name
FROM 
	issued_status iss
JOIN
	employee_table e
	ON e.emp_id = iss.issued_emp_id
GROUP BY 
	 iss.issued_emp_id,
     e.emp_name
HAVING COUNT(iss.issued_id) > 1;


-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results 
-- each book and total book_issued_cnt**

CREATE TABLE book_cnts
AS    
SELECT 
    b.isbn,
    b.book_title,
    COUNT(iss.issued_id) as no_issued
FROM 
	books_table b
JOIN
	issued_status as iss
	ON iss.issued_book_isbn = b.isbn
GROUP BY 
	b.isbn,
	b.book_title;

--verify summary table
SELECT * FROM
book_cnts;



-- Task 7. Retrieve All Books in a Specific Category:

SELECT * FROM 
	books_table
WHERE 
	category = 'Classic';

    
-- Task 8: Find Total Rental Income by Category:

SELECT
    b.category,
    SUM(b.rental_price),
    COUNT(*)
FROM books_table b
JOIN
issued_status as iss
ON iss.issued_book_isbn = b.isbn
GROUP BY 
	b.category;


-- List Members Who Registered in the Last 180 Days:

SELECT * FROM members_table
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days'   
    

INSERT INTO members(member_id, member_name, member_address, reg_date)
VALUES
('C118', 'sam', '145 Main St', '2024-06-01'),
('C119', 'john', '133 Main St', '2024-05-01');



-- task 10 List Employees with Their Branch Manager's Name and their branch details:

SELECT 
    e.*,
    b.manager_id,
    e2.emp_name as manager
FROM employee_table e
JOIN  
branch_table  b
ON b.branch_id = e.branch_id
JOIN
employee_table as e2
ON b.manager_id = e2.emp_id;


-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold 7USD:

CREATE TABLE books_price_greater_than_seven
AS    
SELECT * FROM books_table
WHERE rental_price > 7;
-- TO VERIFY TH CREATED TABLE
SELECT * FROM 
books_price_greater_than_seven;


-- Task 12: Retrieve the List of Books Not Yet Returned

SELECT 
    DISTINCT iss.issued_book_name
FROM 
	issued_status iss
	LEFT JOIN
	return_table r
	ON iss.issued_id = r.issued_id
WHERE 
	r.return_id IS NULL;

    
























