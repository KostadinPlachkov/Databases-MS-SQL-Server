USE DatabaseExample
-- Functions
CREATE FUNCTION udf_ProjectDurationWeeks(@StartDate DATETIME, @EndDate DATETIME)
RETURNS INT
AS
BEGIN
	DECLARE @projectWeeks INT
	IF(@EndDate IS NULL)
	BEGIN
		SET @EndDate = GETDATE()
	END
	SET @projectWeeks = DATEDIFF(WEEK, @StartDate, @EndDate)
	RETURN @projectWeeks
END

SELECT ProjectID, StartDate, EndDate,
	dbo.udf_ProjectDurationWeeks(StartDate, EndDate) AS ProjectDurationWeeks
FROM Projects

CREATE FUNCTION udf_GetSalaryLevel(@salary MONEY)
RETURNS VARCHAR(8)
AS
BEGIN
	IF(@salary < 30000)
	BEGIN
		RETURN 'Low'
	END
	ELSE IF(@salary >= 30000 AND @salary <= 50000)
	BEGIN
		RETURN 'Average'
	END
	BEGIN
		RETURN 'High'
	END
	RETURN NULL
END

SELECT FirstName, LastName, Salary,
	dbo.udf_GetSalaryLevel(Salary) AS SalaryLevel
FROM Employees

-- Transactions
/*
Transaction is a sequence of actions (database operations)
executed as a whole:
- Either all of them complete successfully or none of them.
Example of transaction:
- A bank transfer from one account into another (withdrawal + deposit).
- If either the withdrawal or the deposit fails the whole operation is cancelled.

Transactions Properties
Modern DBMS servers have built-in transaction support.
- Implement “ACID” transactions.
- E.g. MS SQL Server, Oracle, MySQL, …
ACID means:
- Atomicity
- Consistency
- Isolation
- Durability
*/

BEGIN TRANSACTION
DELETE FROM Employees
ROLLBACK

CREATE TABLE LeftTable(
	Id INT IDENTITY PRIMARY KEY,
	Name VARCHAR(50)
)

CREATE TABLE RightTable(
	Id INT IDENTITY PRIMARY KEY,
	Name VARCHAR(50)
)

CREATE TABLE Mapping(
	LeftId INT NOT NULL,
	RightId INT NOT NULL
)

ALTER TABLE Mapping
ADD CONSTRAINT PK__Left__Right
PRIMARY KEY(LeftId, RightId)

ALTER TABLE Mapping
ADD CONSTRAINT FK__LeftTable__LeftId
FOREIGN KEY (LeftId)
REFERENCES LeftTable(Id)
ON DELETE CASCADE

ALTER TABLE Mapping
ADD CONSTRAINT FK__RightTable__RightId
FOREIGN KEY (RightId)
REFERENCES RightTable(Id)
ON DELETE CASCADE

INSERT INTO LeftTable VALUES('First value'),('Second value')
INSERT INTO RightTable VALUES('Third value'),('Fourth value')
INSERT INTO Mapping VALUES(1, 2)

BEGIN TRANSACTION
DECLARE @rowsBefore INT = (SELECT COUNT(*) FROM Mapping)
DELETE FROM LeftTable
WHERE Id = 1
DECLARE @rowsAfter INT = (SELECT COUNT(*) FROM Mapping)

PRINT CONCAT('Cascade deletes: ', @rowsBefore - @rowsAfter)
ROLLBACK

-- Stored Procedures
/*
Stored procedures are named sequences of T-SQL statements.
- Encapsulate repetitive program logic.
- Can accept input parameters.
- Can return output results.
Benefits of stored procedures.
- Share application logic.
- Improved performance.
- Reduced network traffic.
*/

-- Create
CREATE PROC usp_SelectEmployeesBySeniority
AS
SELECT * FROM Employees
WHERE DATEDIFF(YEAR, HireDate, GETDATE()) > 5

EXEC usp_SelectEmployeesBySeniority

-- Alter
ALTER PROC usp_SelectEmployeesBySeniority
AS
SELECT FirstName, LastName, HireDate,
	DATEDIFF(YEAR, HireDate, GETDATE()) AS Years
FROM Employees
WHERE DATEDIFF(YEAR, HireDate, GETDATE()) > 5
ORDER BY HireDate

EXEC usp_SelectEmployeesBySeniority

-- DROP
DROP PROC usp_SelectEmployeesBySeniority

/*
You could check if any object depends on the stored procedure
by executing the system stored procedure sp_depends
*/
EXEC sp_depends 'usp_SelectEmployeesBySeniority'

-- Parameterized Procedures
