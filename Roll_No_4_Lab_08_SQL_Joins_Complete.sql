-- ============================================================
-- DATABASE SYSTEMS
-- SQL JOINS LAB
-- Lab 08 + Lab 09 according to the provided lab sequence
-- Complete solution with comments before EVERY task
-- ============================================================

-- ============================================================
-- LAB 08 — JOINS PART 01
-- INNER JOIN, LEFT JOIN, RIGHT JOIN
-- ============================================================

-- ============================================================
-- SETUP: COMPANY DATABASE
-- ============================================================

CREATE DATABASE IF NOT EXISTS Company_Database_joins_lab;
USE Company_Database_joins_lab;

DROP TABLE IF EXISTS Assignment, Project, Employee, Department;

CREATE TABLE Department (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(40) NOT NULL,
    Location VARCHAR(30),
    Budget DECIMAL(12,2)
);

CREATE TABLE Employee (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50) NOT NULL,
    Gender CHAR(1),
    Salary DECIMAL(10,2),
    HireDate DATE,
    City VARCHAR(30),
    ManagerID INT,
    DeptID INT,
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID),
    FOREIGN KEY (ManagerID) REFERENCES Employee(EmpID)
);

CREATE TABLE Project (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(50) NOT NULL,
    StartDate DATE,
    EndDate DATE,
    DeptID INT,
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
);

CREATE TABLE Assignment (
    EmpID INT,
    ProjectID INT,
    HoursPerWeek INT,
    PRIMARY KEY (EmpID, ProjectID),
    FOREIGN KEY (EmpID) REFERENCES Employee(EmpID),
    FOREIGN KEY (ProjectID) REFERENCES Project(ProjectID)
);

-- Sample data: Departments
INSERT INTO Department VALUES
(10, 'Engineering', 'Lahore', 5000000),
(20, 'Marketing', 'Karachi', 2000000),
(30, 'Finance', 'Islamabad', 3000000),
(40, 'Research', 'Lahore', 4000000),
(50, 'Sales', 'Karachi', NULL);

-- Sample data: Employees
INSERT INTO Employee VALUES
(101,'Ali Khan', 'M', 120000,'2018-03-15','Lahore', NULL, 10),
(102,'Sara Iqbal', 'F', 95000,'2019-06-01','Lahore', 101, 10),
(103,'Hamza Raza', 'M', 85000,'2020-01-20','Karachi', 101, 10),
(104,'Ayesha Noor', 'F', 110000,'2017-11-10','Karachi', NULL, 20),
(105,'Bilal Ahmed', 'M', 70000,'2021-04-05','Karachi', 104, 20),
(106,'Fatima Sheikh','F', 90000,'2019-09-12','Islamabad', NULL, 30),
(107,'Usman Tariq', 'M', 78000,'2022-02-18','Islamabad', 106, 30),
(108,'Maira Javed', 'F', 115000,'2016-07-22','Lahore', NULL, 40),
(109,'Zain Abbas', 'M', 60000,'2023-01-09','Lahore', 108, 40),
(110,'Nida Yousaf', 'F', 72000,'2022-08-30',NULL, 108, 40);

-- Sample data: Projects
INSERT INTO Project VALUES
(1001,'Website Revamp', '2024-01-10','2024-06-30', 10),
(1002,'Mobile App', '2024-03-01','2024-12-31', 10),
(1003,'Brand Campaign', '2024-02-15','2024-05-15', 20),
(1004,'Audit System', '2024-04-01',NULL, 30),
(1005,'AI Research', '2024-05-01','2025-04-30', 40),
(1006,'Internal Tool', '2024-06-01','2024-09-30', NULL);

-- Sample data: Assignments
INSERT INTO Assignment VALUES
(101, 1001, 10),
(102, 1001, 20),
(102, 1002, 15),
(103, 1002, 30),
(104, 1003, 25),
(105, 1003, 40),
(106, 1004, 35),
(108, 1005, 20),
(109, 1005, 30);

-- ============================================================
-- PART A — INNER, LEFT, RIGHT JOINS
-- ============================================================

-- Task A1: List every employee with department name and location.
SELECT e.EmpID, e.EmpName, d.DeptName, d.Location
FROM Employee e
INNER JOIN Department d ON e.DeptID = d.DeptID;

-- Task A2: Include employees whose DeptID is NULL, if any.
SELECT e.EmpID, e.EmpName, d.DeptName, d.Location
FROM Employee e
LEFT JOIN Department d ON e.DeptID = d.DeptID;

-- Task A3: List every department with employee names.
-- Departments with no employees must still appear.
SELECT d.DeptID, d.DeptName, e.EmpName
FROM Department d
LEFT JOIN Employee e ON d.DeptID = e.DeptID
ORDER BY d.DeptID;

-- Task A4: List every project with department name and location.
-- Include projects that have no department.
SELECT p.ProjectID, p.ProjectName, d.DeptName, d.Location
FROM Project p
LEFT JOIN Department d ON p.DeptID = d.DeptID;

-- Task A5: Find employees who are not assigned to any project.
SELECT e.EmpID, e.EmpName
FROM Employee e
LEFT JOIN Assignment a ON e.EmpID = a.EmpID
WHERE a.EmpID IS NULL;

-- Task A6: List every project that currently has no assignments.
SELECT p.ProjectID, p.ProjectName
FROM Project p
LEFT JOIN Assignment a ON p.ProjectID = a.ProjectID
WHERE a.ProjectID IS NULL;

-- Task A7: Engineering employees with salary, sorted descending.
SELECT e.EmpID, e.EmpName, e.Salary, d.DeptName
FROM Employee e
INNER JOIN Department d ON e.DeptID = d.DeptID
WHERE d.DeptName = 'Engineering'
ORDER BY e.Salary DESC;

-- Task A8: List employees in Lahore-based departments.
SELECT e.EmpName, d.DeptName
FROM Employee e
INNER JOIN Department d ON e.DeptID = d.DeptID
WHERE d.Location = 'Lahore';

-- Task A9: Every department and employee count.
-- LEFT JOIN keeps departments having zero employees.
SELECT d.DeptID, d.DeptName, COUNT(e.EmpID) AS EmployeeCount
FROM Department d
LEFT JOIN Employee e ON d.DeptID = e.DeptID
GROUP BY d.DeptID, d.DeptName
ORDER BY d.DeptID;

-- Task A10: FULL OUTER JOIN of Employee and Department using UNION.
-- MySQL does not directly support FULL OUTER JOIN.
SELECT e.EmpID, e.EmpName, d.DeptID, d.DeptName
FROM Employee e
LEFT JOIN Department d ON e.DeptID = d.DeptID
UNION
SELECT e.EmpID, e.EmpName, d.DeptID, d.DeptName
FROM Employee e
RIGHT JOIN Department d ON e.DeptID = d.DeptID;



-- ============================================================
-- ASSESSMENT — LIBRARY DATABASE
-- ============================================================

CREATE DATABASE IF NOT EXISTS library_lab;
USE library_lab;

DROP TABLE IF EXISTS Loan, Book, Member, Author;

CREATE TABLE Author (
    AuthorID INT PRIMARY KEY,
    AuthorName VARCHAR(60) NOT NULL,
    Country VARCHAR(30)
);

CREATE TABLE Book (
    BookID INT PRIMARY KEY,
    Title VARCHAR(80) NOT NULL,
    Genre VARCHAR(30),
    Price DECIMAL(8,2),
    AuthorID INT,
    PublishedYear INT,
    FOREIGN KEY (AuthorID) REFERENCES Author(AuthorID)
);

CREATE TABLE Member (
    MemberID INT PRIMARY KEY,
    MemberName VARCHAR(60) NOT NULL,
    City VARCHAR(30),
    JoinDate DATE
);

CREATE TABLE Loan (
    LoanID INT PRIMARY KEY,
    MemberID INT,
    BookID INT,
    LoanDate DATE,
    ReturnDate DATE,
    FOREIGN KEY (MemberID) REFERENCES Member(MemberID),
    FOREIGN KEY (BookID) REFERENCES Book(BookID)
);

-- Assessment sample data: Authors
INSERT INTO Author VALUES
(1,'Jane Austen', 'UK'),
(2,'Chinua Achebe', 'Nigeria'),
(3,'Haruki Murakami', 'Japan'),
(4,'Bapsi Sidhwa', 'Pakistan'),
(5,'Mohsin Hamid', 'Pakistan'),
(6,'Anonymous Writer', NULL);

-- Assessment sample data: Books
INSERT INTO Book VALUES
(101,'Pride and Prejudice','Fiction',850.00,1,1813),
(102,'Emma','Fiction',900.00,1,1815),
(103,'Things Fall Apart','Fiction',1100.00,2,1958),
(104,'Norwegian Wood','Fiction',1500.00,3,1987),
(105,'Kafka on the Shore','Fiction',1700.00,3,2002),
(106,'Ice-Candy-Man','Fiction',1200.00,4,1988),
(107,'The Reluctant Fundamentalist','Fiction',1300.00,5,2007),
(108,'Exit West','Fiction',1450.00,5,2017),
(109,'Mystery Title','Mystery',950.00,NULL,2020);

-- Assessment sample data: Members
INSERT INTO Member VALUES
(201,'Ahmad Raza', 'Lahore', '2023-01-15'),
(202,'Sara Imran', 'Karachi', '2023-03-20'),
(203,'Bilal Khan', 'Lahore', '2024-02-10'),
(204,'Fatima Ali', 'Islamabad', '2022-09-05'),
(205,'Hira Yousaf', NULL, '2024-05-01');

-- Assessment sample data: Loans
INSERT INTO Loan VALUES
(1, 201, 101, '2024-03-01', '2024-03-15'),
(2, 201, 104, '2024-04-10', NULL),
(3, 202, 103, '2024-02-20', '2024-03-05'),
(4, 202, 107, '2024-05-01', NULL),
(5, 203, 105, '2024-04-25', '2024-05-15'),
(6, 204, 102, '2024-01-10', '2024-01-30'),
(7, 204, 108, '2024-06-01', NULL);

-- Q1: Show every book with author's name and country.
SELECT b.BookID, b.Title, a.AuthorName, a.Country
FROM Book b
INNER JOIN Author a ON b.AuthorID = a.AuthorID;

-- Q2: Show every author with their books.
-- Authors with no books must still appear.
SELECT a.AuthorID, a.AuthorName, b.Title
FROM Author a
LEFT JOIN Book b ON a.AuthorID = b.AuthorID
ORDER BY a.AuthorID;

-- Q3: Members who have never borrowed any book.
SELECT m.MemberID, m.MemberName
FROM Member m
LEFT JOIN Loan l ON m.MemberID = l.MemberID
WHERE l.MemberID IS NULL;

-- Q4: Every loan with member name, book title and author name.
SELECT l.LoanID,
       m.MemberName,
       b.Title,
       a.AuthorName
FROM Loan l
INNER JOIN Member m ON l.MemberID = m.MemberID
INNER JOIN Book b ON l.BookID = b.BookID
LEFT JOIN Author a ON b.AuthorID = a.AuthorID;

-- Q5: Currently borrowed books.
-- ReturnDate IS NULL means the book has not yet been returned.
SELECT b.Title,
       m.MemberName,
       m.City,
       l.LoanDate
FROM Loan l
INNER JOIN Member m ON l.MemberID = m.MemberID
INNER JOIN Book b ON l.BookID = b.BookID
WHERE l.ReturnDate IS NULL;

-- Q6: Pakistani authors and their books.
-- LEFT JOIN preserves Pakistani authors who have no books.
SELECT a.AuthorName, b.Title
FROM Author a
LEFT JOIN Book b ON a.AuthorID = b.AuthorID
WHERE a.Country = 'Pakistan';

-- Q7: Every book with names of members who borrowed it.
-- Include books never borrowed.
SELECT b.BookID, b.Title, m.MemberName
FROM Book b
LEFT JOIN Loan l ON b.BookID = l.BookID
LEFT JOIN Member m ON l.MemberID = m.MemberID
ORDER BY b.BookID;

-- Q8: Authors whose books have never been borrowed.
-- LEFT JOIN through Book and Loan, then keep no-loan authors.
SELECT a.AuthorID, a.AuthorName
FROM Author a
INNER JOIN Book b ON a.AuthorID = b.AuthorID
LEFT JOIN Loan l ON b.BookID = l.BookID
GROUP BY a.AuthorID, a.AuthorName
HAVING COUNT(l.LoanID) = 0;

-- Q9: FULL OUTER JOIN of Author and Book using UNION.
-- MySQL does not directly support FULL OUTER JOIN.
SELECT a.AuthorID, a.AuthorName, b.BookID, b.Title
FROM Author a
LEFT JOIN Book b ON a.AuthorID = b.AuthorID
UNION
SELECT a.AuthorID, a.AuthorName, b.BookID, b.Title
FROM Author a
RIGHT JOIN Book b ON a.AuthorID = b.AuthorID;

-- Q10: Members who borrowed books written by Pakistani authors.
SELECT m.MemberName,
       b.Title,
       a.AuthorName
FROM Loan l
INNER JOIN Member m ON l.MemberID = m.MemberID
INNER JOIN Book b ON l.BookID = b.BookID
INNER JOIN Author a ON b.AuthorID = a.AuthorID
WHERE a.Country = 'Pakistan';

-- ============================================================
-- END OF SQL JOINS LAB
-- ============================================================
