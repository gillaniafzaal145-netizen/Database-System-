-- =========================================================
-- DBMS OPEN-ENDED LAB
-- CAR RENTAL MANAGEMENT SYSTEM
-- =========================================================

CREATE DATABASE CarGo_Rentals;
USE CarGo_Rentals;

-- 1. CUSTOMERS TABLE
CREATE TABLE Customers
(
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    CustomerPhone VARCHAR(20) NOT NULL UNIQUE,
    CustomerEmail VARCHAR(100) UNIQUE,
    Address VARCHAR(200),
    LicenseNumber VARCHAR(50) NOT NULL UNIQUE,
    RegistrationDate DATE NOT NULL
);

-- 2. VEHICLES TABLE
CREATE TABLE Vehicles
(
    VehicleID INT AUTO_INCREMENT PRIMARY KEY,
    VehicleNumber VARCHAR(20) NOT NULL UNIQUE,
    VehicleModel VARCHAR(100) NOT NULL,
    VehicleType VARCHAR(50) NOT NULL,
    VehicleYear INT NOT NULL,
    DailyRate DECIMAL(10,2) NOT NULL,
    VehicleStatus VARCHAR(20) DEFAULT 'Available',
    CHECK (DailyRate > 0),
    CHECK (VehicleYear >= 2000),
    CHECK (VehicleStatus IN ('Available', 'Rented', 'Maintenance'))
);

-- 3. RENTALS TABLE
CREATE TABLE Rentals
(
    RentalID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    VehicleID INT NOT NULL,
    RentalDate DATE NOT NULL,
    ReturnDate DATE,
    RentalDays INT,
    TotalCharge DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (VehicleID) REFERENCES Vehicles(VehicleID),
    CHECK (ReturnDate IS NULL OR ReturnDate >= RentalDate),
    CHECK (RentalDays IS NULL OR RentalDays > 0),
    CHECK (TotalCharge IS NULL OR TotalCharge >= 0)
);

-- 4. PAYMENTS TABLE
CREATE TABLE Payments
(
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    RentalID INT NOT NULL UNIQUE,
    PaymentAmount DECIMAL(10,2) NOT NULL,
    PaymentDate DATE NOT NULL,
    PaymentMethod VARCHAR(30) DEFAULT 'Cash',
    PaymentStatus VARCHAR(20) DEFAULT 'Paid',
    FOREIGN KEY (RentalID) REFERENCES Rentals(RentalID),
    CHECK (PaymentAmount >= 0),
    CHECK (PaymentMethod IN ('Cash', 'Card', 'Online')),
    CHECK (PaymentStatus IN ('Paid', 'Pending'))
);

-- 5. VEHICLE MAINTENANCE TABLE
CREATE TABLE VehicleMaintenance
(
    MaintenanceID INT AUTO_INCREMENT PRIMARY KEY,
    VehicleID INT NOT NULL,
    MaintenanceDate DATE NOT NULL,
    Description VARCHAR(200) NOT NULL,
    Cost DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (VehicleID) REFERENCES Vehicles(VehicleID),
    CHECK (Cost >= 0)
);

-- SAMPLE CUSTOMERS
INSERT INTO Customers
(CustomerName, CustomerPhone, CustomerEmail, Address, LicenseNumber, RegistrationDate)
VALUES
('Ali Khan', '0300-1234567', 'ali@gmail.com', 'Muzaffarabad', 'LIC001', '2026-08-01'),
('Ahmed Raza', '0311-2345678', 'ahmed@gmail.com', 'Islamabad', 'LIC002', '2026-08-03'),
('Sara Malik', '0322-3456789', 'sara@gmail.com', 'Rawalpindi', 'LIC003', '2026-08-05'),
('Usman Shah', '0333-4567890', 'usman@gmail.com', 'Lahore', 'LIC004', '2026-08-10'),
('Ayesha Noor', '0344-5678901', 'ayesha@gmail.com', 'Abbottabad', 'LIC005', '2026-08-12');

-- SAMPLE VEHICLES
INSERT INTO Vehicles
(VehicleNumber, VehicleModel, VehicleType, VehicleYear, DailyRate, VehicleStatus)
VALUES
('ABC-123', 'Toyota Corolla', 'Sedan', 2022, 5000, 'Available'),
('LEA-456', 'Honda Civic', 'Sedan', 2023, 7000, 'Rented'),
('ISB-789', 'Suzuki Swift', 'Hatchback', 2021, 4000, 'Available'),
('MZD-321', 'Toyota Yaris', 'Sedan', 2024, 5500, 'Available'),
('LHR-654', 'KIA Sportage', 'SUV', 2023, 9000, 'Maintenance'),
('GB-999', 'Hyundai Tucson', 'SUV', 2022, 8500, 'Available');

-- SAMPLE RENTALS
INSERT INTO Rentals
(CustomerID, VehicleID, RentalDate, ReturnDate, RentalDays, TotalCharge)
VALUES
(1, 1, '2026-09-01', '2026-09-04', 3, 15000),
(2, 2, '2026-09-10', NULL, NULL, NULL),
(3, 3, '2026-08-20', '2026-08-23', 3, 12000);

-- SAMPLE PAYMENTS
INSERT INTO Payments
(RentalID, PaymentAmount, PaymentDate, PaymentMethod, PaymentStatus)
VALUES
(1, 15000, '2026-09-01', 'Cash', 'Paid'),
(2, 0, '2026-09-10', 'Cash', 'Pending'),
(3, 12000, '2026-08-20', 'Card', 'Paid');

-- SAMPLE MAINTENANCE
INSERT INTO VehicleMaintenance
(VehicleID, MaintenanceDate, Description, Cost)
VALUES
(5, '2026-09-05', 'Engine oil and filter change', 8000),
(5, '2026-09-12', 'Brake inspection', 5000),
(2, '2026-08-15', 'General service', 6000);

-- JOIN QUERY 1
SELECT c.CustomerName, v.VehicleNumber, v.VehicleModel,
       r.RentalDate, r.ReturnDate
FROM Rentals r
INNER JOIN Customers c ON r.CustomerID = c.CustomerID
INNER JOIN Vehicles v ON r.VehicleID = v.VehicleID;

-- JOIN QUERY 2
SELECT c.CustomerName, v.VehicleNumber, v.VehicleModel
FROM Customers c
LEFT JOIN Rentals r ON c.CustomerID = r.CustomerID
LEFT JOIN Vehicles v ON r.VehicleID = v.VehicleID
ORDER BY c.CustomerName;

-- JOIN QUERY 3
SELECT v.VehicleNumber, v.VehicleModel, r.RentalID,
       r.RentalDate, r.ReturnDate
FROM Vehicles v
LEFT JOIN Rentals r
    ON v.VehicleID = r.VehicleID
    AND r.ReturnDate IS NULL;

-- JOIN QUERY 4
SELECT c.CustomerID, c.CustomerName,
       COUNT(r.RentalID) AS TotalRentals
FROM Customers c
LEFT JOIN Rentals r ON c.CustomerID = r.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY c.CustomerID;

-- VIEW
CREATE VIEW RentalReport AS
SELECT r.RentalID, c.CustomerName, c.CustomerPhone,
       v.VehicleNumber, v.VehicleModel, v.VehicleType,
       r.RentalDate, r.ReturnDate, r.RentalDays, r.TotalCharge,
       p.PaymentAmount, p.PaymentDate, p.PaymentMethod, p.PaymentStatus
FROM Rentals r
INNER JOIN Customers c ON r.CustomerID = c.CustomerID
INNER JOIN Vehicles v ON r.VehicleID = v.VehicleID
LEFT JOIN Payments p ON r.RentalID = p.RentalID;

SELECT * FROM RentalReport;

-- TRIGGER
DELIMITER //
CREATE TRIGGER PreventVehicleDoubleRental
BEFORE INSERT ON Rentals
FOR EACH ROW
BEGIN
    IF EXISTS
    (
        SELECT 1 FROM Rentals
        WHERE VehicleID = NEW.VehicleID
        AND ReturnDate IS NULL
    )
    THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'This vehicle is currently rented and cannot be rented again.';
    END IF;
END //
DELIMITER ;

-- TRIGGER TEST (run separately; it should produce an error)
-- INSERT INTO Rentals (CustomerID, VehicleID, RentalDate)
-- VALUES (4, 2, '2026-09-19');

-- STORED PROCEDURE
DELIMITER //
CREATE PROCEDURE RegisterRental
(
    IN p_CustomerID INT,
    IN p_VehicleID INT,
    IN p_RentalDate DATE,
    IN p_ReturnDate DATE
)
BEGIN
    DECLARE v_DailyRate DECIMAL(10,2);
    DECLARE v_RentalDays INT;
    DECLARE v_TotalCharge DECIMAL(10,2);
    DECLARE v_RentalID INT;

    SELECT DailyRate INTO v_DailyRate
    FROM Vehicles
    WHERE VehicleID = p_VehicleID;

    IF v_DailyRate IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Vehicle does not exist.';
    END IF;

    IF p_ReturnDate < p_RentalDate THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Return date cannot be before rental date.';
    END IF;

    SET v_RentalDays = DATEDIFF(p_ReturnDate, p_RentalDate);

    IF v_RentalDays = 0 THEN
        SET v_RentalDays = 1;
    END IF;

    SET v_TotalCharge = v_RentalDays * v_DailyRate;

    INSERT INTO Rentals
    (CustomerID, VehicleID, RentalDate, ReturnDate,
     RentalDays, TotalCharge)
    VALUES
    (p_CustomerID, p_VehicleID, p_RentalDate, p_ReturnDate,
     v_RentalDays, v_TotalCharge);

    SET v_RentalID = LAST_INSERT_ID();

    SELECT v_RentalID AS RentalID,
           v_RentalDays AS RentalDays,
           v_DailyRate AS DailyRate,
           v_TotalCharge AS TotalCharge;
END //
DELIMITER ;

-- STORED PROCEDURE TEST
CALL RegisterRental(4, 4, '2026-09-19', '2026-09-22');

-- UPDATE VEHICLE STATUS FOR ACTIVE RENTALS
UPDATE Vehicles
SET VehicleStatus = 'Rented'
WHERE VehicleID IN
(
    SELECT VehicleID
    FROM Rentals
    WHERE ReturnDate IS NULL
);

-- OPTIMIZATION INDEX
CREATE INDEX idx_rentals_vehicle_return
ON Rentals(VehicleID, ReturnDate);

-- FINAL CHECKS
SELECT * FROM Customers;
SELECT * FROM Vehicles;
SELECT * FROM Rentals;
SELECT * FROM Payments;
SELECT * FROM VehicleMaintenance;
SELECT * FROM RentalReport;
SHOW INDEX FROM Rentals;
