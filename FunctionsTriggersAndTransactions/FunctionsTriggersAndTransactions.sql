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
ALTER PROC usp_SelectEmployeesBySeniority(@minYearsAtWork INT = 5)
AS
SELECT FirstName, LastName, HireDate,
	DATEDIFF(YEAR, HireDate, GETDATE()) AS Years
FROM Employees
WHERE DATEDIFF(YEAR, HireDate, GETDATE()) > @minYearsAtWork
ORDER BY HireDate

EXEC usp_SelectEmployeesBySeniority 10  -- Or EXEC usp_SelectEmployeesBySeniority @minYearsAtWork = 10

-- Returning values
CREATE PROCEDURE usp_AddNumbers
	@firstNumber INT,
	@secondNumber INT,
	@result INT OUTPUT
AS
SET @result = @firstNumber + @secondNumber

DECLARE @answer INT
EXECUTE usp_AddNumbers 5, 6, @answer OUTPUT
SELECT @answer AS Answer

-- Problem: Employees with Three Projects
/*
Create a precedure that assigns projects to employee.
If the employee has more than 3 projects throw exception and rollback the changes.
*/

CREATE PROC usp_AssignProject
	(@EmployeeId INT, @ProjectId INT)
AS
BEGIN TRANSACTION
INSERT INTO EmployeesProjects VALUES(@EmployeeId, @ProjectId)
IF((SELECT COUNT(*) FROM EmployeesProjects
WHERE EmployeeID = @EmployeeId) > 3)
BEGIN
	ROLLBACK
	RAISERROR('An Employee cannot have more than 3 projects assigned', 16, 1)  -- OR throw 50000, 'An Employee cannot have more than 3 projects assigned', 1
END
ELSE COMMIT

EXEC usp_AssignProject 2, 5
SELECT * FROM EmployeesProjects

-- Problem: Withdraw Money
/*
Create a stored procedure usp_WithdrawMoney (AccountId, moneyAmount) that operate in transactions.
Validate only if the account is existing and if not throw an exception.
*/
USE Bank
CREATE PROC usp_WithdrawMoney
	(@accountId INT, @moneyAmount MONEY)
AS
BEGIN TRANSACTION
UPDATE Accounts
SET Balance -= @moneyAmount
WHERE Id = @accountId

IF(@@ROWCOUNT <> 1)  -- Rows afected
BEGIN
	ROLLBACK
	RAISERROR('Account does not exist', 16, 1)
END
ELSE IF((SELECT Balance FROM Accounts WHERE Id = @accountId) < 0)
BEGIN
	ROLLBACK
	RAISERROR('Insufficient balance', 16, 1)
END
ELSE COMMIT

EXEC usp_WithdrawMoney 5, 15
EXEC usp_WithdrawMoney 11, 15
EXEC usp_WithdrawMoney 21, 15

-- Triggers
/*
Triggers are very much like stored procedures.
- Called in case of specific event.
We do not call triggers explicitly.
- Triggers are attached to a table.
- Triggers are fired when a certain SQL statement is executed
against the contents of the table.
*/
-- Instead of Trigger
CREATE TABLE Accounts(
	Username VARCHAR(10) NOT NULL PRIMARY KEY,
	[Password] VARCHAR(50) NOT NULL,
	Active VARCHAR(1) NOT NULL DEFAULT 'Y'
)

CREATE TRIGGER tr_AccountsDelete ON Accounts
	INSTEAD OF DELETE
AS
	UPDATE a SET Active = 'N'
	FROM Accounts AS a JOIN deleted d
		ON d.Username = a.Username
	WHERE a.Active = 'Y'

INSERT INTO Accounts VALUES('John', '123456', DEFAULT)
INSERT INTO Accounts VALUES('Maya', 'BeastMaster64', DEFAULT)
INSERT INTO Accounts VALUES('Tyler', 'amthebest', DEFAULT)

SELECT * FROM Accounts

DELETE FROM Accounts
WHERE Username = 'John'

SELECT * FROM Accounts

-- After Trigger
USE DatabaseExample
CREATE TRIGGER tr_TownsInsert ON Towns FOR INSERT
AS
	IF(EXISTS(SELECT * FROM inserted WHERE Name IS NULL)
	OR
	EXISTS(SELECT * FROM inserted WHERE LEN(Name) = 0))
	BEGIN 
		RAISERROR('Town name cannot be empty.', 16, 1)
		ROLLBACK TRAN
		RETURN
	END

INSERT INTO Towns VALUES('Plovdiv'), ('Vraca'), ('')  -- Not working
INSERT INTO Towns VALUES('Plovdiv'), ('Vraca')  -- Working