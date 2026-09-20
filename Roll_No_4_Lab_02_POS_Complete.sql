-- ========================================================
-- POINT OF SALE (POS) DATABASE
-- ========================================================

-- Create Database
CREATE DATABASE pos;

-- Select Database
USE pos;


-- ========================================================
-- 1. CATEGORIES TABLE
-- ========================================================

CREATE TABLE categories (
    category_id INT NOT NULL AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (category_id)
);

-- Insert Categories
INSERT INTO categories (category_name) VALUES
('Electronics'),
('Grocery'),
('Clothes'),
('Furniture'),
('Books'),
('Sports'),
('Toys'),
('Accessories'),
('Appliances'),
('Stationery');


-- ========================================================
-- 2. ROLES TABLE
-- ========================================================

CREATE TABLE roles (
    role_id INT NOT NULL AUTO_INCREMENT,
    role_name VARCHAR(50) NOT NULL,
    PRIMARY KEY (role_id)
);

-- Insert Roles
INSERT INTO roles (role_name) VALUES
('admin'),
('salesman'),
('customer'),
('manager'),
('guest');


-- ========================================================
-- 3. USERS TABLE
-- ========================================================

CREATE TABLE users (
    user_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    role_id INT NOT NULL,
    PRIMARY KEY (user_id),

    -- Foreign Key
    FOREIGN KEY (role_id)
    REFERENCES roles(role_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- Insert Users
INSERT INTO users (name, email, role_id) VALUES
('Ali', 'ali@gmail.com', 1),
('Ahmed', 'ahmed@gmail.com', 2),
('Usman', 'usman@gmail.com', 1),
('Bilal', 'bilal@gmail.com', 5),
('Hassan', 'hassan@gmail.com', 3),
('Hamza', 'hamza@gmail.com', 4),
('Zain', 'zain@gmail.com', 2),
('Omar', 'omar@gmail.com', 1),
('Saad', 'saad@gmail.com', 4),
('Fahad', 'fahad@gmail.com', 2);


-- ========================================================
-- 4. PRODUCTS TABLE
-- ========================================================

CREATE TABLE products (
    product_id INT NOT NULL AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,0) NOT NULL,
    category_id INT NOT NULL,
    PRIMARY KEY (product_id),

    -- Foreign Key
    FOREIGN KEY (category_id)
    REFERENCES categories(category_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- Insert Products
INSERT INTO products
(product_name, price, category_id) VALUES
('Laptop', 85000, 1),
('Mouse', 1500, 1),
('Shirt', 2500, 3),
('Sofa', 50000, 4),
('Notebook', 200, 10),
('Basketball', 3500, 6),
('Refrigerator', 60000, 9),
('Book', 500, 5),
('Headphones', 7000, 1),
('Dress', 4000, 3);


-- ========================================================
-- 5. ORDERS TABLE
-- ========================================================

CREATE TABLE orders (
    order_id INT NOT NULL AUTO_INCREMENT,
    user_id INT NOT NULL,
    order_date DATE NOT NULL,
    PRIMARY KEY (order_id),

    -- Foreign Key
    FOREIGN KEY (user_id)
    REFERENCES users(user_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- Insert Orders
INSERT INTO orders (user_id, order_date) VALUES
(2, '2026-03-10'),
(2, '2026-03-10'),
(4, '2026-03-10'),
(5, '2026-03-12'),
(7, '2026-03-11'),
(6, '2026-03-13'),
(10, '2026-03-10'),
(10, '2026-03-10'),
(4, '2026-03-10'),
(8, '2026-03-12');


-- ========================================================
-- 6. ORDEREDITEM TABLE
-- ========================================================

CREATE TABLE ordereditem (
    ordereditem_id INT NOT NULL AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,0) NOT NULL,
    PRIMARY KEY (ordereditem_id),

    -- Foreign Key for Orders
    FOREIGN KEY (order_id)
    REFERENCES orders(order_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

    -- Foreign Key for Products
    FOREIGN KEY (product_id)
    REFERENCES products(product_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- Insert Ordered Items
INSERT INTO ordereditem
(order_id, product_id, quantity, price) VALUES
(1, 1, 2, 85000),
(2, 8, 2, 500),
(3, 6, 6, 3500),
(4, 9, 2, 7000),
(5, 8, 1, 500),
(6, 10, 2, 4000),
(10, 2, 3, 1500),
(9, 5, 2, 200),
(8, 7, 1, 60000),
(7, 3, 3, 2500);


-- ========================================================
-- 7. SUPPLIERS TABLE
-- ========================================================

CREATE TABLE suppliers (
    supplier_id INT NOT NULL AUTO_INCREMENT,
    supplier_name VARCHAR(100) NOT NULL,
    contact VARCHAR(30),
    email VARCHAR(100),
    city VARCHAR(50),
    PRIMARY KEY (supplier_id)
);

-- Insert Suppliers
INSERT INTO suppliers
(supplier_name, contact, email, city) VALUES
('Tech World', '03001234567', 'techworld@gmail.com', 'Muzaffarabad'),
('Smart Electronics', '03111234567', 'smart@gmail.com', 'Islamabad'),
('Book House', '03221234567', 'bookhouse@gmail.com', 'Rawalpindi'),
('Fashion Point', '03331234567', 'fashion@gmail.com', 'Lahore'),
('Home Store', '03441234567', 'homestore@gmail.com', 'Islamabad');


-- ========================================================
-- 8. PAYMENTS TABLE
-- ========================================================

CREATE TABLE payments (
    payment_id INT NOT NULL AUTO_INCREMENT,
    order_id INT NOT NULL,
    payment_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(30) NOT NULL,
    payment_status VARCHAR(30) NOT NULL,
    PRIMARY KEY (payment_id),

    -- Foreign Key
    FOREIGN KEY (order_id)
    REFERENCES orders(order_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- Insert Payments
INSERT INTO payments
(order_id, payment_date, amount, payment_method, payment_status) VALUES
(1, '2026-03-10', 170000, 'Cash', 'Paid'),
(2, '2026-03-10', 1000, 'Card', 'Paid'),
(3, '2026-03-10', 21000, 'Cash', 'Paid'),
(4, '2026-03-12', 14000, 'JazzCash', 'Paid'),
(5, '2026-03-11', 500, 'Cash', 'Paid'),
(6, '2026-03-13', 8000, 'Card', 'Paid'),
(7, '2026-03-10', 7500, 'Cash', 'Paid'),
(8, '2026-03-10', 60000, 'Bank Transfer', 'Paid'),
(9, '2026-03-10', 400, 'Cash', 'Paid'),
(10, '2026-03-12', 4500, 'Card', 'Pending');


-- ========================================================
-- 9. DISPLAY TABLE DATA
-- ========================================================

-- Display Categories
SELECT * FROM categories;

-- Display Roles
SELECT * FROM roles;

-- Display Users
SELECT * FROM users;

-- Display Products
SELECT * FROM products;

-- Display Orders
SELECT * FROM orders;

-- Display Ordered Items
SELECT * FROM ordereditem;

-- Display Suppliers
SELECT * FROM suppliers;

-- Display Payments
SELECT * FROM payments;
