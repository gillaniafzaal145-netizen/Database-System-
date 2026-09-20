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
-- TASK 1 — BOOKSTORE: IDENTIFY FDs AND ANOMALIES
-- ============================================================

-- Functional Dependencies identified from the supplied data:
--
-- OrderID -> OrderDate, CustID
-- CustID -> CustName, CustEmail
-- BookID -> BookTitle, Publisher, UnitPrice
-- (OrderID, BookID) -> Qty
--
-- Because each book has exactly one publisher, BookID also determines
-- its publisher.
--
-- Candidate key for the 1NF order-book relation:
-- (OrderID, BookID)
--
-- Insertion anomaly:
-- A new customer/book/instructor-type fact cannot be recorded
-- independently without unrelated order information.
--
-- Update anomaly:
-- If a customer's email changes, every order row containing that
-- customer must be updated.
--
-- Deletion anomaly:
-- Deleting the only order containing a particular book/customer
-- can accidentally remove the only stored information about that
-- book/customer.

-- ============================================================
-- TASK 2 — BOOKSTORE: CONVERT TO 1NF
-- ============================================================
-- Rule: every cell contains one atomic value and there are no
-- repeating groups.
--
-- Primary key: (OrderID, BookID)

DROP TABLE IF EXISTS OrderBook_1NF;

CREATE TABLE OrderBook_1NF (
    OrderID VARCHAR(10),
    OrderDate DATE,
    CustID VARCHAR(10),
    CustName VARCHAR(50),
    CustEmail VARCHAR(100),
    BookID VARCHAR(10),
    BookTitle VARCHAR(100),
    Publisher VARCHAR(50),
    UnitPrice DECIMAL(10,2),
    Qty INT,
    PRIMARY KEY (OrderID, BookID)
);

INSERT INTO OrderBook_1NF
(OrderID, OrderDate, CustID, CustName, CustEmail,
 BookID, BookTitle, Publisher, UnitPrice, Qty)
VALUES
('O-501','2026-04-02','C-11','Bilal','bilal@x.com',
 'B-1','SQL Basics','Pearson',1200,1),
('O-501','2026-04-02','C-11','Bilal','bilal@x.com',
 'B-2','Python 101','OReilly',1500,2),
('O-502','2026-04-03','C-12','Areeba','areeba@x.com',
 'B-1','SQL Basics','Pearson',1200,3),
('O-503','2026-04-05','C-11','Bilal','bilal@x.com',
 'B-3','Networks','Pearson',1800,1),
('O-503','2026-04-05','C-11','Bilal','bilal@x.com',
 'B-2','Python 101','OReilly',1500,1);

SELECT * FROM OrderBook_1NF;

-- ============================================================
-- LAB 04 STUDENT CHECK
-- ============================================================
-- The following query confirms the atomic 1NF rows:
SELECT OrderID, BookID, BookTitle, Publisher, UnitPrice, Qty
FROM OrderBook_1NF
ORDER BY OrderID, BookID;





-- ============================================================
-- PART C: ASSESSMENT PROBLEM — HOSPITAL PATIENT VISITS
-- ============================================================
-- This section is included because the supplied lab manual requires
-- the graded assessment to be solved individually in MySQL.
--
-- ============================================================
-- DELIVERABLE 1 — FUNCTIONAL DEPENDENCIES AND CANDIDATE KEY
-- ============================================================
--
-- Functional Dependencies:
--
-- VisitID -> VisitDate, PatientID, DoctorID, Diagnosis, Fee
-- PatientID -> PatientName, PatientPhone
-- DoctorID -> DoctorName, Specialty, DeptName
-- DeptName -> DeptHead
--
-- Therefore, the transitive dependency is:
-- DoctorID -> DeptName -> DeptHead
--
-- Candidate key for the original 1NF visit relation:
-- VisitID
--
-- VisitID is the primary/candidate key because each VisitID identifies
-- exactly one hospital visit.

CREATE DATABASE IF NOT EXISTS Hospital_normalization_lab;
USE Hospital_normalization_lab;

-- ============================================================
-- DELIVERABLE 2 — HOSPITAL 1NF
-- ============================================================

DROP TABLE IF EXISTS HospitalVisit_1NF;

CREATE TABLE HospitalVisit_1NF (
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

INSERT INTO HospitalVisit_1NF
(VisitID, VisitDate, PatientID, PatientName, PatientPhone,
 DoctorID, DoctorName, Specialty, DeptName, DeptHead,
 Diagnosis, Fee)
VALUES
('V-9001','2026-04-10','P-201','Hassan','0300-1112233',
 'D-30','Dr. Imran','Cardiology','Heart Care','Dr. Tariq',
 'Hypertension',2500),
('V-9002','2026-04-10','P-202','Mehreen','0301-4445566',
 'D-31','Dr. Asma','Dermatology','Skin Clinic','Dr. Asma',
 'Eczema',2000),
('V-9003','2026-04-11','P-201','Hassan','0300-1112233',
 'D-31','Dr. Asma','Dermatology','Skin Clinic','Dr. Asma',
 'Allergy',2000),
('V-9004','2026-04-12','P-203','Junaid','0302-7778899',
 'D-30','Dr. Imran','Cardiology','Heart Care','Dr. Tariq',
 'Arrhythmia',3000);

SELECT * FROM HospitalVisit_1NF;

