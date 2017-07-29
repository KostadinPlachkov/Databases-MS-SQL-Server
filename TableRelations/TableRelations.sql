CREATE DATABASE DBTest

USE DBTest

-- Many-to-One/One-to-Many
CREATE TABLE Mountains(
	Id INT PRIMARY KEY IDENTITY(1, 1),
	Name VARCHAR(50) NOT NULL
)

CREATE TABLE Peaks(
	Id INT PRIMARY KEY IDENTITY(1, 1),
	Name VARCHAR(50),
	MountainId INT NOT NULL,
	CONSTRAINT FK_Mountains
	FOREIGN KEY (MountainId)
	REFERENCES Mountains(Id)
)

INSERT INTO Mountains VALUES('Rila')

INSERT INTO Peaks VALUES('Musala', 1)
SELECT * FROM Peaks
SELECT * FROM Mountains

-- Many-to-Many
CREATE TABLE Employees(
	Id INT PRIMARY KEY IDENTITY(1, 1),
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	Salary MONEY NOT NULL
)

CREATE TABLE Projects(
	Id INT PRIMARY KEY IDENTITY(1, 1),
	Name VARCHAR(255) NOT NULL,
	Description VARCHAR(MAX),
	StartDate DATE DEFAULT GETDATE(),
	EndDate DATE
)

-- Mapping Table
CREATE TABLE EmployeesProjects(
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id),
	ProjectId INT FOREIGN KEY REFERENCES Projects(Id),
	CONSTRAINT PK_EmployeeId_ProjectId
	PRIMARY KEY(EmployeeId, ProjectId)
)

INSERT INTO Employees VALUES('John', 'Cena', 100000)
INSERT INTO Projects(Name) VALUES('Strong AI')

SELECT * FROM Employees
SELECT * FROM Projects

INSERT INTO EmployeesProjects VALUES(1, 1)
SELECT * FROM EmployeesProjects

-- One-to-One
CREATE TABLE Cars(
	Id INT PRIMARY KEY IDENTITY(1, 1),
	Model VARCHAR(50) NOT NULL
)

CREATE TABLE Drivers(
	Id INT PRIMARY KEY IDENTITY(1, 1),
	Name VARCHAR(50) NOT NULL,
	CarId INT UNIQUE,
	CONSTRAINT FK_Cars
	FOREIGN KEY(CarId)
	REFERENCES Cars(Id)
)

INSERT INTO Cars VALUES('Tesla')
INSERT INTO Drivers(Name) VALUES('Elon Musk')
INSERT INTO Drivers(Name, CarId) VALUES('John Cena', 1)

SELECT * FROM Drivers

-- Test for One-to-One
UPDATE Drivers
SET CarId = 1
WHERE Id = 1

-- Example
/*
Football Database
Design a storage for football team information. It keeps up-to-date information 
about each team, with its players and manager. A team can participate in many 
leagues, both local and international. Players and managers are recorded with 
thier first and last name and their salary.
*/

CREATE TABLE Managers(
	Id INT PRIMARY KEY IDENTITY,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	Salary MONEY DEFAULT 0
)

CREATE TABLE Teams(
	Id INT PRIMARY KEY IDENTITY,
	Name VARCHAR(50) NOT NULL,
	ManagerId INT UNIQUE,
	CONSTRAINT FK_Managers
	FOREIGN KEY (ManagerId)
	REFERENCES Managers(Id)
)

CREATE TABLE Leagues(
	Id INT PRIMARY KEY IDENTITY,
	Name VARCHAR(50) NOT NULL
)

CREATE TABLE TeamsLeagues(
	TeamId INT,
	LeagueId INT,
	CONSTRAINT PK_TeamId_LeagueId
	PRIMARY KEY (TeamId, LeagueId),
	CONSTRAINT FK_Teams
	FOREIGN KEY (TeamId)
	REFERENCES Teams(Id),
	CONSTRAINT FK_Leagues
	FOREIGN KEY (LeagueId)
	REFERENCES Leagues(Id)
)

CREATE TABLE Players(
	Id INT PRIMARY KEY IDENTITY,
	PlayerNumber INT,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	Salary MONEY DEFAULT 0,
	TeamId INT,
	CONSTRAINT FK_Players_Teams
	FOREIGN KEY (TeamId)
	REFERENCES Teams(Id)
)

-- Self-referencing Table
ALTER TABLE Employees
ADD CONSTRAINT FK_Employees_Employees
FOREIGN KEY (ManagerId)
REFERENCES Employees(Id)

-- Retrieving Related Data
USE DatabaseExample

SELECT Departments.Name AS [Department]
	,AVG(Salary) AS [Total Salary]
FROM Employees
JOIN Departments ON
	Departments.DepartmentID = Employees.DepartmentID
GROUP BY Departments.Name
ORDER BY [Total Salary] DESC

-- Cascade Operations
-- Cascading allows when a change is made to certain entity, this change to apply to all related entities.

-- Delete Cascade
USE DBTest
DROP TABLE Drivers
DROP TABLE Cars

CREATE TABLE Drivers(
	DriverID INT PRIMARY KEY,
	DriverName VARCHAR(50)
)

CREATE TABLE Cars(
	CarID INT PRIMARY KEY,
	DriverID INT,
	CONSTRAINT FK_Car_Driver
	FOREIGN KEY(DriverID)
	REFERENCES Drivers(DriverID) ON DELETE CASCADE
)

INSERT INTO Drivers VALUES(1, 'John Cena')
INSERT INTO Cars VALUES(1, 1)

SELECT * FROM Drivers
SELECT * FROM Cars

DELETE FROM Drivers
WHERE DriverID = 1
-- Test
SELECT * FROM Drivers
SELECT * FROM Cars

-- Update Cascade
DROP TABLE Cars
CREATE TABLE Cars(
	CarID INT PRIMARY KEY,
	DriverID INT,
	CONSTRAINT FK_Car_Driver
	FOREIGN KEY(DriverID)
	REFERENCES Drivers(DriverID) ON UPDATE CASCADE
)

INSERT INTO Drivers VALUES(1, 'Bob')
INSERT INTO Cars VALUES(1, 1)

SELECT * FROM Drivers
SELECT * FROM Cars

UPDATE Drivers
SET DriverID = 5
WHERE DriverID = 1
-- Test
SELECT * FROM Drivers
SELECT * FROM Cars

CREATE TABLE Cars(
	CarID INT PRIMARY KEY,
	DriverID INT,
	CONSTRAINT FK_Car_Driver
	FOREIGN KEY(DriverID)
	REFERENCES Drivers(DriverID) ON DELETE SET NULL  -- When deleted, NULL is set as a value.
)
