-- Creating Data
CREATE DATABASE People
USE People
CREATE TABLE Employees
(
	Id int NOT NULL IDENTITY PRIMARY KEY,  -- Auto-increment
	Email varchar(255) NOT NULL UNIQUE,  -- Unique value
	FirstName varchar(50),
	LastName varchar(50),
	Salary money CHECK (Salary > 420),  -- The value has to be > 420
	PaidTimeOff int DEFAULT 30  -- Default value

)

SELECT * FROM Employees  -- Selects all columns
SELECT FirstName, LastName FROM Employees  -- Selects columns: FirstName and LastName

-- Editing Data
ALTER TABLE Employees
ADD DateOfBirth DATE  -- Adds new column

ALTER TABLE Employees
DROP COLUMN DateOfBirth  --  Delets the column

ALTER TABLE Employees
ALTER COLUMN Email varchar(150)  -- Edits the column

-- Add primary key to existing column
ALTER TABLE Employees
ADD CONSTRAINT PK_Id
PRIMARY KEY (Id)

-- Add uunique constraint
ALTER TABLE Employees
ADD CONSTRAINT uq_Email
UNIQUE (Email)

-- Default constraint
ALTER TABLE Employees
ADD CONSTRAINT DF_Salary
DEFAULT 420 FOR Salary

ALTER TABLE Employees
ADD PhoneNumber varchar(10) NOT NULL

-- Deleting Data and Structures
-- To delete all of the entries in a table
TRUNCATE TABLE Employees

-- To drop a table
DROP TABLE Employees

-- To drop entire database
DROP DATABASE People
