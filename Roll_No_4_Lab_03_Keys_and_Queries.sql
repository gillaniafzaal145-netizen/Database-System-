-- MySQL Lab Guide - Complete Lab Solution
-- Source: Mysql Lab Guide.pdf
-- All tasks from the provided lab guide are included below.

-- =========================================================
-- SECTION 1: DATABASE KEYS
-- =========================================================

-- 1. Primary Key
-- Uniquely identifies each record and cannot be NULL.
-- Implemented in the table definitions below.

-- 2. Foreign Key
-- Creates a relationship between two tables.
-- Implemented in Students, Courses, Instructors and Enrollments.

-- 3. Unique Key
-- Ensures all values in a column are unique.
-- Implemented on department name, student email and instructor email.

-- 4. Composite Key
-- Primary key consisting of more than one column.
-- Implemented in Enrollments:
-- PRIMARY KEY (student_id, course_id)

-- 5. Candidate Key
-- Example from the guide: email or CNIC can potentially identify a student.

-- 6. Alternate Key
-- Example from the guide: email or CNIC when student_id is the primary key.

-- 7. Super Key
-- Examples from the guide: student_id, email, or student_id + name.

-- 8. Natural Key
-- Example from the guide: CNIC as a real-world unique attribute.
-- Example:
-- CREATE TABLE citizens (
--     cnic VARCHAR(15) PRIMARY KEY,
--     name VARCHAR(100)
-- );

-- 9. Surrogate Key
-- Example from the guide: AUTO_INCREMENT student_id.
-- This is used in the Students table below.


-- =========================================================
-- SECTION 2: CREATE TABLE
-- Complete University Lab Example
-- =========================================================

CREATE DATABASE IF NOT EXISTS Course_Enrollment_Lab03;
USE Course_Enrollment_Lab03;

-- Remove old tables so the complete script can be run again.
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS instructors;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS departments;

-- Departments Table
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100) UNIQUE
);

-- Students Table
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    age INT,
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- Courses Table
CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- Instructors Table
CREATE TABLE instructors (
    instructor_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- Enrollments Table (Composite Key)
CREATE TABLE enrollments (
    student_id INT,
    course_id INT,
    semester VARCHAR(20),
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);


-- =========================================================
-- ALTER TABLE PRACTICE
-- =========================================================

-- Add Column
ALTER TABLE students
ADD phone VARCHAR(20);

-- Modify Column
ALTER TABLE students
MODIFY age INT NOT NULL;

-- Rename Column
ALTER TABLE students
CHANGE dept_id department_id INT;

-- Drop Column
ALTER TABLE students
DROP COLUMN phone;

-- Add Primary Key example:
-- The Students table already has its primary key.
-- ALTER TABLE students ADD PRIMARY KEY (student_id);

-- Add Unique Key example:
-- The email column already has a UNIQUE constraint.
-- ALTER TABLE students
-- ADD CONSTRAINT unique_email UNIQUE (email);

-- Add Foreign Key example:
-- The foreign key is already defined in the Students table.
-- ALTER TABLE students
-- ADD CONSTRAINT fk_department
-- FOREIGN KEY (department_id) REFERENCES departments(dept_id);


-- =========================================================
-- SECTION 3: CRUD OPERATIONS
-- =========================================================

-- INSERT
INSERT INTO departments (dept_id, dept_name)
VALUES
(1, 'CS'),
(2, 'EE');

INSERT INTO students (name, email, age, department_id)
VALUES
('Ali', 'ali@gmail.com', 20, 1),
('Sara', 'sara@gmail.com', 21, 1),
('Ahmed', 'ahmed@gmail.com', 22, 2);

INSERT INTO courses (course_id, course_name, dept_id)
VALUES
(101, 'Database', 1),
(102, 'AI', 1),
(201, 'Circuits', 2);

INSERT INTO instructors (instructor_id, name, email, dept_id)
VALUES
(1, 'Khurram', 'khurram@gmail.com', 1),
(2, 'Ahmed', 'instructor.ahmed@gmail.com', 2);

INSERT INTO enrollments (student_id, course_id, semester)
VALUES
(1, 101, 'Fall 2025'),
(1, 102, 'Fall 2025'),
(2, 101, 'Fall 2025');


-- SELECT
SELECT * FROM students;

-- Additional SELECT queries for the lab
SELECT * FROM departments;
SELECT * FROM courses;
SELECT * FROM instructors;
SELECT * FROM enrollments;


-- UPDATE
UPDATE students
SET name = 'Ali Khan'
WHERE student_id = 1;

-- Verify updated record
SELECT * FROM students
WHERE student_id = 1;


-- DELETE
-- Delete the student after removing dependent enrollment records.
DELETE FROM enrollments
WHERE student_id = 2;

DELETE FROM students
WHERE student_id = 2;

-- Verify deletion
SELECT * FROM students;


-- =========================================================
-- SECTION 4: JOINS BETWEEN STUDENTS AND COURSES
-- =========================================================

-- INNER JOIN: Students with their enrolled courses
SELECT
    s.student_id,
    s.name AS student_name,
    c.course_id,
    c.course_name,
    e.semester
FROM students s
INNER JOIN enrollments e
    ON s.student_id = e.student_id
INNER JOIN courses c
    ON e.course_id = c.course_id;


-- =========================================================
-- SECTION 5: CANDIDATE, ALTERNATE AND COMPOSITE KEYS
-- =========================================================

-- Candidate Key example:
-- email is unique and can potentially identify a student.
SELECT student_id, name, email
FROM students
WHERE email = 'ali@gmail.com';

-- Alternate Key example:
-- student_id is selected as the primary key, while email remains UNIQUE.
-- Therefore email represents an alternate key in this design.

-- Composite Key example:
-- Enrollments uses (student_id, course_id) as its composite primary key.
SELECT student_id, course_id, semester
FROM enrollments;


-- =========================================================
-- SECTION 6: TRUNCATE AND DROP
-- =========================================================

-- TRUNCATE:
-- Removes all rows from a table while keeping its structure.
-- Run this only when you want to clear the table.
--
-- Example:
-- TRUNCATE TABLE enrollments;

-- DROP:
-- Removes the table and its structure.
-- The following commands are provided as the lab practice requested
-- in the guide. They are commented so that the complete solution
-- remains available after execution.
--
-- DROP TABLE students;


-- =========================================================
-- END OF LAB
-- =========================================================
