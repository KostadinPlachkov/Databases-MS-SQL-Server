-- Aggregate functions are used to operate over one or more groups (with some elements in them), performing data analysis on every one
-- MIN, MAX, AVG, COUNT
USE DatabaseExample
-- COUNT
SELECT ProjectID, COUNT(EmployeeID) AS 'Employees'
FROM EmployeesProjects
GROUP BY ProjectID
ORDER BY 'Employees' DESC

SELECT FirstName, COUNT(EmployeeID) AS 'Common Names'
FROM Employees
GROUP BY FirstName
ORDER BY 'Common Names' DESC

-- SUM
SELECT DepartmentID, SUM(Salary) AS 'Total Salary'
FROM Employees
GROUP BY DepartmentID
ORDER BY 'Total Salary' DESC

-- MAX
SELECT DepartmentID, MAX(Salary) AS 'Highest Salary'
FROM Employees
GROUP BY DepartmentID
ORDER BY 'Highest Salary' DESC

-- MIN
SELECT DepartmentID, MIN(Salary) AS 'Lowest Salary'
FROM Employees
GROUP BY DepartmentID
ORDER BY 'Lowest Salary'

-- AVG
SELECT DepartmentID, AVG(Salary) AS 'Average Salary'
FROM Employees
GROUP BY DepartmentID
ORDER BY 'Average Salary' DESC

-- Having
/*
- The HAVING clause is used to filter data based on aggregate values.
- Any aggregate function (like MIN, MAX, SUM etc.) used both in the "HAVING" clause and in the select statement are executed one time only.
- Unlike HAVING, the WHERE clause filters rows before the aggregation happens.
*/

SELECT DepartmentID
	,SUM(Salary) AS [Total Salary]
FROM Employees
GROUP BY DepartmentID
HAVING SUM(Salary) >= 500000

DECLARE @DateOfCompanyCreation Datetime
SET @DateOfCompanyCreation = (SELECT MIN(HireDate) FROM Employees)
SELECT COUNT(EmployeeID) AS [Employees]
	,DATEDIFF(YEAR, @DateOfCompanyCreation, HireDate) AS [Years in The Company]
FROM Employees
GROUP BY DATEDIFF(YEAR, @DateOfCompanyCreation, HireDate)