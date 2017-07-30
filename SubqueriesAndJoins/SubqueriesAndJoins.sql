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