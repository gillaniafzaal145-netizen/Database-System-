-- ============================================================
-- DATABASE SYSTEMS
-- LAB 04 — NORMALIZATION: OVERVIEW AND 1NF
-- LAB 05 — CONVERSION TO 2NF AND 3NF
-- Based ONLY on the provided Database Normalization Lab Manual
-- ============================================================
--
-- This file is organized so a student can perform the lab tasks
-- individually in MySQL.
--
-- ============================================================
-- PART A: LAB 04 — NORMALIZATION: OVERVIEW AND 1NF
-- ============================================================

CREATE DATABASE IF NOT EXISTS BookStore_normalization_lab;
USE BookStore_normalization_lab;


-- ============================================================
-- PART B: LAB 05 — CONVERSION TO 2NF AND 3NF
-- ============================================================

-- ============================================================
-- TASK 3 — BOOKSTORE: CONVERT TO 2NF
-- ============================================================
--
-- Primary key in 1NF:
-- (OrderID, BookID)
--
-- Partial dependencies:
--
-- OrderID -> OrderDate, CustID, CustName, CustEmail
-- These attributes depend only on OrderID.
--
-- BookID -> BookTitle, Publisher, UnitPrice
-- These attributes depend only on BookID.
--
-- Qty depends on the whole composite key:
-- (OrderID, BookID) -> Qty
--
-- Therefore, separate Order, Book and OrderItem.

DROP TABLE IF EXISTS OrderItem_2NF;
DROP TABLE IF EXISTS Book_2NF;
DROP TABLE IF EXISTS Customer_2NF;

CREATE TABLE Customer_2NF (
    CustID VARCHAR(10) PRIMARY KEY,
    CustName VARCHAR(50),
    CustEmail VARCHAR(100)
);

CREATE TABLE Book_2NF (
    BookID VARCHAR(10) PRIMARY KEY,
    BookTitle VARCHAR(100),
    Publisher VARCHAR(50),
    UnitPrice DECIMAL(10,2)
);

CREATE TABLE Order_2NF (
    OrderID VARCHAR(10) PRIMARY KEY,
    OrderDate DATE,
    CustID VARCHAR(10),
    CustName VARCHAR(50),
    CustEmail VARCHAR(100),
    FOREIGN KEY (CustID) REFERENCES Customer_2NF(CustID)
);

CREATE TABLE OrderItem_2NF (
    OrderID VARCHAR(10),
    BookID VARCHAR(10),
    Qty INT,
    PRIMARY KEY (OrderID, BookID),
    FOREIGN KEY (OrderID) REFERENCES Order_2NF(OrderID),
    FOREIGN KEY (BookID) REFERENCES Book_2NF(BookID)
);

-- Populate 2NF tables.

INSERT INTO Customer_2NF VALUES
('C-11','Bilal','bilal@x.com'),
('C-12','Areeba','areeba@x.com');

INSERT INTO Book_2NF VALUES
('B-1','SQL Basics','Pearson',1200),
('B-2','Python 101','OReilly',1500),
('B-3','Networks','Pearson',1800);

INSERT INTO Order_2NF
(OrderID, OrderDate, CustID, CustName, CustEmail)
VALUES
('O-501','2026-04-02','C-11','Bilal','bilal@x.com'),
('O-502','2026-04-03','C-12','Areeba','areeba@x.com'),
('O-503','2026-04-05','C-11','Bilal','bilal@x.com');

INSERT INTO OrderItem_2NF VALUES
('O-501','B-1',1),
('O-501','B-2',2),
('O-502','B-1',3),
('O-503','B-3',1),
('O-503','B-2',1);

SELECT * FROM Customer_2NF;
SELECT * FROM Book_2NF;
SELECT * FROM Order_2NF;
SELECT * FROM OrderItem_2NF;


-- ============================================================
-- TASK 4 — BOOKSTORE: CONVERT TO 3NF
-- ============================================================
--
-- Transitive dependency remaining in the 2NF Order table:
--
-- OrderID -> CustID
-- CustID -> CustName, CustEmail
-- Therefore:
-- OrderID -> CustName, CustEmail (transitively)
--
-- To remove this transitive dependency, customer information is
-- stored only in Customer_3NF and Order_3NF keeps CustID as FK.
--
-- The supplied scenario also states that each book has exactly one
-- publisher. Publisher information can therefore be separated into
-- its own table so book data refers to the publisher.

DROP TABLE IF EXISTS OrderItem_3NF;
DROP TABLE IF EXISTS Order_3NF;
DROP TABLE IF EXISTS Book_3NF;
DROP TABLE IF EXISTS Publisher_3NF;
DROP TABLE IF EXISTS Customer_3NF;

CREATE TABLE Customer_3NF (
    CustID VARCHAR(10) PRIMARY KEY,
    CustName VARCHAR(50),
    CustEmail VARCHAR(100)
);

CREATE TABLE Publisher_3NF (
    PublisherID INT PRIMARY KEY,
    PublisherName VARCHAR(50) UNIQUE
);

CREATE TABLE Book_3NF (
    BookID VARCHAR(10) PRIMARY KEY,
    BookTitle VARCHAR(100),
    PublisherID INT,
    UnitPrice DECIMAL(10,2),
    FOREIGN KEY (PublisherID) REFERENCES Publisher_3NF(PublisherID)
);

CREATE TABLE Order_3NF (
    OrderID VARCHAR(10) PRIMARY KEY,
    OrderDate DATE,
    CustID VARCHAR(10),
    FOREIGN KEY (CustID) REFERENCES Customer_3NF(CustID)
);

CREATE TABLE OrderItem_3NF (
    OrderID VARCHAR(10),
    BookID VARCHAR(10),
    Qty INT,
    PRIMARY KEY (OrderID, BookID),
    FOREIGN KEY (OrderID) REFERENCES Order_3NF(OrderID),
    FOREIGN KEY (BookID) REFERENCES Book_3NF(BookID)
);

-- Populate 3NF tables.

INSERT INTO Customer_3NF VALUES
('C-11','Bilal','bilal@x.com'),
('C-12','Areeba','areeba@x.com');

INSERT INTO Publisher_3NF VALUES
(1,'Pearson'),
(2,'OReilly');

INSERT INTO Book_3NF
(BookID, BookTitle, PublisherID, UnitPrice)
VALUES
('B-1','SQL Basics',1,1200),
('B-2','Python 101',2,1500),
('B-3','Networks',1,1800);

INSERT INTO Order_3NF
(OrderID, OrderDate, CustID)
VALUES
('O-501','2026-04-02','C-11'),
('O-502','2026-04-03','C-12'),
('O-503','2026-04-05','C-11');

INSERT INTO OrderItem_3NF VALUES
('O-501','B-1',1),
('O-501','B-2',2),
('O-502','B-1',3),
('O-503','B-3',1),
('O-503','B-2',1);


-- ============================================================
-- TASK 5 — BOOKSTORE VERIFICATION QUERIES
-- ============================================================

-- Recreate the original report: one row per book purchased.

SELECT
    o.OrderID,
    o.OrderDate,
    c.CustID,
    c.CustName,
    c.CustEmail,
    b.BookID,
    b.BookTitle,
    p.PublisherName AS Publisher,
    b.UnitPrice,
    oi.Qty
FROM Order_3NF o
JOIN Customer_3NF c
    ON o.CustID = c.CustID
JOIN OrderItem_3NF oi
    ON o.OrderID = oi.OrderID
JOIN Book_3NF b
    ON oi.BookID = b.BookID
JOIN Publisher_3NF p
    ON b.PublisherID = p.PublisherID
ORDER BY o.OrderID, b.BookID;


-- Every customer's total spend.

SELECT
    c.CustID,
    c.CustName,
    SUM(b.UnitPrice * oi.Qty) AS TotalSpend
FROM Customer_3NF c
JOIN Order_3NF o
    ON c.CustID = o.CustID
JOIN OrderItem_3NF oi
    ON o.OrderID = oi.OrderID
JOIN Book_3NF b
    ON oi.BookID = b.BookID
GROUP BY c.CustID, c.CustName
ORDER BY c.CustID;


-- ============================================================
-- TASK 6 — BOOKSTORE REFLECTION
-- ============================================================
--
-- The final 3NF design stores each customer's information once,
-- so changing a customer's name or email requires one update.
-- Book information is stored separately from order items, so a new
-- book can be recorded without creating an order. OrderItem stores
-- only the relationship between an order and a book and its quantity,
-- which prevents repeated order and book facts. Deleting an order
-- therefore does not require deleting the customer's master data or
-- the book's master data. Foreign keys also maintain referential
-- integrity between the decomposed tables.


-- ============================================================
-- PART C: ASSESSMENT PROBLEM — HOSPITAL PATIENT VISITS
-- ============================================================
-- This section is included because the supplied lab manual requires
-- the graded assessment to be solved individually in MySQL.

CREATE DATABASE IF NOT EXISTS Hospital_normalization_lab;
USE Hospital_normalization_lab;

-- ============================================================
-- DELIVERABLE 3 — HOSPITAL 2NF
-- ============================================================
--
-- Important observation:
-- The candidate/primary key is VisitID, which is a single attribute.
-- Therefore there can be NO partial dependency on part of the key.
-- The 1NF relation is consequently already in 2NF.
--
-- For the required 2NF implementation, we retain the 1NF structure
-- and document that no partial dependency needs decomposition.
--
-- The later decomposition is performed for the transitive dependencies
-- required for 3NF.

DROP TABLE IF EXISTS HospitalVisit_2NF;

CREATE TABLE HospitalVisit_2NF (
    VisitID VARCHAR(10) PRIMARY KEY,
    VisitDate DATE,
    PatientID VARCHAR(10),
    PatientName VARCHAR(50),
    PatientPhone VARCHAR(20),
    DoctorID VARCHAR(10),
    DoctorName VARCHAR(50),
    Specialty VARCHAR(50),
    DeptName VARCHAR(50),
    DeptHead VARCHAR(50),
    Diagnosis VARCHAR(100),
    Fee DECIMAL(10,2)
);

INSERT INTO HospitalVisit_2NF
SELECT * FROM HospitalVisit_1NF;

SELECT * FROM HospitalVisit_2NF;


-- ============================================================
-- DELIVERABLE 4 — HOSPITAL 3NF
-- ============================================================
--
-- Transitive dependencies:
--
-- VisitID -> PatientID -> PatientName, PatientPhone
-- VisitID -> DoctorID -> DoctorName, Specialty, DeptName
-- VisitID -> DoctorID -> DeptName -> DeptHead
--
-- Decompose patient information, doctor information, department
-- information, and visit information into separate relations.

DROP TABLE IF EXISTS HospitalVisit_3NF;
DROP TABLE IF EXISTS HospitalDoctor_3NF;
DROP TABLE IF EXISTS HospitalPatient_3NF;
DROP TABLE IF EXISTS HospitalDepartment_3NF;

CREATE TABLE HospitalPatient_3NF (
    PatientID VARCHAR(10) PRIMARY KEY,
    PatientName VARCHAR(50),
    PatientPhone VARCHAR(20)
);

CREATE TABLE HospitalDepartment_3NF (
    DeptName VARCHAR(50) PRIMARY KEY,
    DeptHead VARCHAR(50)
);

CREATE TABLE HospitalDoctor_3NF (
    DoctorID VARCHAR(10) PRIMARY KEY,
    DoctorName VARCHAR(50),
    Specialty VARCHAR(50),
    DeptName VARCHAR(50),
    FOREIGN KEY (DeptName) REFERENCES HospitalDepartment_3NF(DeptName)
);

CREATE TABLE HospitalVisit_3NF (
    VisitID VARCHAR(10) PRIMARY KEY,
    VisitDate DATE,
    PatientID VARCHAR(10),
    DoctorID VARCHAR(10),
    Diagnosis VARCHAR(100),
    Fee DECIMAL(10,2),
    FOREIGN KEY (PatientID) REFERENCES HospitalPatient_3NF(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES HospitalDoctor_3NF(DoctorID)
);

-- Populate patient table.

INSERT INTO HospitalPatient_3NF VALUES
('P-201','Hassan','0300-1112233'),
('P-202','Mehreen','0301-4445566'),
('P-203','Junaid','0302-7778899');

-- Populate department table.

INSERT INTO HospitalDepartment_3NF VALUES
('Heart Care','Dr. Tariq'),
('Skin Clinic','Dr. Asma');

-- Populate doctor table.

INSERT INTO HospitalDoctor_3NF VALUES
('D-30','Dr. Imran','Cardiology','Heart Care'),
('D-31','Dr. Asma','Dermatology','Skin Clinic');

-- Populate visit table.

INSERT INTO HospitalVisit_3NF
(VisitID, VisitDate, PatientID, DoctorID, Diagnosis, Fee)
VALUES
('V-9001','2026-04-10','P-201','D-30','Hypertension',2500),
('V-9002','2026-04-10','P-202','D-31','Eczema',2000),
('V-9003','2026-04-11','P-201','D-31','Allergy',2000),
('V-9004','2026-04-12','P-203','D-30','Arrhythmia',3000);


-- ============================================================
-- DELIVERABLE 5 — SINGLE SELECT TO RECREATE TABLE 8.1
-- ============================================================

SELECT
    v.VisitID,
    v.VisitDate,
    p.PatientID,
    p.PatientName,
    p.PatientPhone,
    d.DoctorID,
    d.DoctorName,
    d.Specialty,
    dept.DeptName,
    dept.DeptHead,
    v.Diagnosis,
    v.Fee
FROM HospitalVisit_3NF v
JOIN HospitalPatient_3NF p
    ON v.PatientID = p.PatientID
JOIN HospitalDoctor_3NF d
    ON v.DoctorID = d.DoctorID
JOIN HospitalDepartment_3NF dept
    ON d.DeptName = dept.DeptName
ORDER BY v.VisitID;


-- ============================================================
-- DELIVERABLE 6 — HOSPITAL ANOMALIES ELIMINATED
-- ============================================================
--
-- Insertion anomaly is reduced because patient, doctor, and department
-- information can be inserted independently of a visit.
-- Update anomaly is reduced because each patient, doctor, and
-- department fact is stored in one place.
-- Deletion anomaly is reduced because deleting a visit does not delete
-- the associated patient's, doctor's, or department's master record.
-- Foreign keys preserve the relationships between the normalized tables.
--
-- ============================================================
-- SCHEMA INSPECTION / CHEAT SHEET
-- ============================================================

SHOW TABLES;

DESCRIBE Customer_3NF;
DESCRIBE Publisher_3NF;
DESCRIBE Book_3NF;
DESCRIBE Order_3NF;
DESCRIBE OrderItem_3NF;

DESCRIBE HospitalPatient_3NF;
DESCRIBE HospitalDepartment_3NF;
DESCRIBE HospitalDoctor_3NF;
DESCRIBE HospitalVisit_3NF;

-- Show complete CREATE statements if required:
-- SHOW CREATE TABLE Customer_3NF;
-- SHOW CREATE TABLE Book_3NF;
-- SHOW CREATE TABLE Order_3NF;
-- SHOW CREATE TABLE OrderItem_3NF;
-- SHOW CREATE TABLE HospitalPatient_3NF;
-- SHOW CREATE TABLE HospitalDepartment_3NF;
-- SHOW CREATE TABLE HospitalDoctor_3NF;
-- SHOW CREATE TABLE HospitalVisit_3NF;

-- ============================================================
-- END OF LAB 05 NORMALIZATION SOLUTION
-- ============================================================
