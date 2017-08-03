-- JOINS
USE DatabaseExample

-- INNER
SELECT FirstName
	,LastName
	,Salary
	,d.Name AS [Department]
FROM Employees AS e
INNER JOIN Departments AS d
ON d.DepartmentID = e.DepartmentID

INSERT INTO Departments(Name, ManagerID) VALUES('Robotics', 1)

-- FULL
SELECT FirstName
	,LastName
	,Salary
	,d.Name AS [Department]
FROM Employees AS e
FULL JOIN Departments AS d
ON d.DepartmentID = e.DepartmentID

-- LEFT OUTER
SELECT FirstName
	,LastName
	,Salary
	,d.Name AS [Department]
FROM Employees AS e
LEFT OUTER JOIN Departments AS d
ON d.DepartmentID = e.DepartmentID

-- RIGHT OUTER
SELECT FirstName
	,LastName
	,Salary
	,d.Name AS [Department]
FROM Employees AS e
RIGHT OUTER JOIN Departments AS d
ON d.DepartmentID = e.DepartmentID
WHERE d.DepartmentID = 7

-- CROSS AND SELF JOIN
SELECT e1.FirstName, e2.LastName FROM Employees AS e1
	CROSS JOIN Employees AS e2
	ORDER BY NEWID()  -- Randomize the entries. The entries will not be ordered by FirstName

-- SELF
SELECT e1.FirstName + ' ' + e1.LastName AS [EmployeeName]
	,e2.FirstName + ' ' + e2.LastName AS [ManagerName]
FROM Employees AS e1
JOIN Employees AS e2
ON e1.ManagerID = e2.EmployeeID

-- Example
SELECT TOP (50) e.FirstName, e.LastName, a.AddressText, t.Name FROM Employees AS e
JOIN Addresses AS a
ON a.AddressID = e.AddressID
JOIN Towns AS t
ON t.TownID = a.TownID
ORDER BY e.FirstName, e.LastName

-- Subqueries 
SELECT * FROM (SELECT FirstName + ' ' + LastName AS [Full Name]
	,JobTitle
FROM Employees
WHERE DepartmentID = (SELECT DepartmentID FROM Departments
WHERE Name = 'Sales')  -- DepartmentID of Sales is 3
) AS EmployeesJobs
WHERE EmployeesJobs.[Full Name] LIKE 'Brian%'

SELECT [Salary Group], COUNT(*) AS [Employees] FROM
(SELECT 
CASE
	WHEN Salary BETWEEN 10000 AND 20000 THEN '[10000 - 20000]'
	WHEN Salary BETWEEN 20001 AND 30000 THEN '[20000 - 20000]'
	WHEN Salary BETWEEN 30001 AND 40000 THEN '[30000 - 20000]'
	WHEN Salary BETWEEN 40001 AND 50000 THEN '[40000 - 20000]'
	WHEN Salary BETWEEN 50001 AND 60000 THEN '[50000 - 60000]'
	ELSE '[60000+]'
END AS [Salary Group]
FROM Employees) AS salaryT
GROUP BY [Salary Group]

SELECT MIN(AverageSalary) AS MinAvgSalary FROM
(SELECT DepartmentID, AVG(Salary) AS AverageSalary
FROM Employees
GROUP BY DepartmentID
) AS AverageSalaryT

SELECT * FROM
(SELECT DepartmentID, AVG(Salary) AS AverageSalary,
	DENSE_RANK() OVER (ORDER BY AVG(Salary)) AS Ranking  
/* The difference between RANK() and DENSE_RANK() is that
when we have identical values RANK() will give N numbers of the same ranking
values and will continue with +N (Olympic ranking)(Example: 1, 2, 2, 4, 5),
while DENSE_RANK will continue with the next rank value (Example: 1, 2, 2, 3, 4)
*/
FROM Employees
GROUP BY DepartmentID) AS AvgSalRankingT
WHERE Ranking = 15

SELECT DepartmentID, ManagerID, Salary,
ROW_NUMBER() OVER
 (PARTITION BY DepartmentID ORDER BY Salary)
 AS Ranking
FROM Employees

-- Common Table Expressions (CTE)

WITH Employees_CTE(FullName, DepartmentName)
AS
(
	SELECT e.FirstName + ' ' + e.LastName, d.Name
	FROM Employees AS e
	LEFT JOIN Departments AS d
	ON d.DepartmentID = e.DepartmentID
)
SELECT * FROM Employees_CTE

-- Indices
/*
Indices can be built-in the table (clustered) or stored externally (non-clustered).
Adding and deleting records in indexed tables is slow!
Indices should be used for big tables only (e.g. 50 000 rows).
*/

/*
Clustered index is actually the data itself.
Maximum 1 clustered index per table.
*/
CREATE CLUSTERED INDEX
IX_EmployeesSalary_Salary
ON EmployeesSalary(Salary)

-- Test
SELECT [Full Name]
FROM EmployeesSalary
WHERE Salary = 30000

/*
Much less valuable if table does not have a clustered index.
A non-clustered index has pointers to the actual data rows.
*/
CREATE NONCLUSTERED INDEX
IX_EmployeesSalary_FullName
ON EmployeesSalary([Full Name])

-- Test
SELECT [Full Name]
FROM EmployeesSalary
WHERE [Full Name] = 'Kostadin Plachkov'

CREATE NONCLUSTERED INDEX
IX_EmployeesSalary_FullName_Salary
ON EmployeesSalary([Full Name])
INCLUDE(Salary)

-- Test
SELECT [Full Name], Salary
FROM EmployeesSalary
WHERE [Full Name] = 'Kostadin Plachkov'