-- String Functions
SELECT FirstName + ' ' + LastName
AS 'Full Name'
FROM Employees

SELECT CONCAT(FirstName, ' ', LastName)
AS 'Full Name'
FROM Employees
-- CONCAT replaces NULL values with empty string

SELECT SUBSTRING('Hello from substring', 1, 5)  -- Index is 1-based!!!!!

SELECT REPLACE('MS SQL is the best', 'MS SQL', 'MySQL')

SELECT LTRIM('             Example          ')  -- Removes spaces from the left
SELECT RTRIM('             Example          ')  -- Removes spaces from the right

SELECT LEN('123456')  -- Number of characters
SELECT DATALENGTH('123456')  -- Number of bytes (double for Unicode)

SELECT LEFT('January', 3)  -- Gets the first n characters
SELECT RIGHT('Running', 3)  -- Gets the last n characters

SELECT UPPER(FirstName)  -- To upper
	,UPPER(LastName)
FROM Employees

SELECT REPLICATE('*', 6)
SELECT REVERSE('abc')

SELECT CHARINDEX('SQL', 'MS SQL is used by 10% of the dev')  -- Locates a specific pattern
SELECT STUFF('MS is the best', 4, 0, 'SQL ')  -- Inserts substring at specific position

-- Math Functions
SELECT PI()  -- 3.14159265358979
SELECT ABS(-6) -- absolute value
SELECT SQRT(4)  -- square root
SELECT SQUARE(2)  -- power of two
SELECT CAST(5 AS varchar(1))
-- CONVERT() is similar CAST()
SELECT POWER(5, 2) 
SELECT ROUND(123.456, 2)  -- 123.460
SELECT ROUND(123.456, -1)  -- 120.000
SELECT FLOOR(123.756)  -- 123
SELECT CEILING(123.156)  -- 124
SELECT SIGN(-555)  -- Returns +1, -1 or 0 depending on the value sign
SELECT RAND()  -- Returns a random number [0, 1)
SELECT CEILING(RAND() * 100)  -- Random number [1, 100]

-- Date Functions
SELECT DATEPART(QUARTER, CONVERT(datetime, '08-15-2017')) AS 'QUARTER'  -- Part of the datetime
SELECT DATEPART(YEAR, CONVERT(datetime, '08-15-2017')) AS 'YEAR'
SELECT DATEPART(MONTH, CONVERT(datetime, '08-15-2017')) AS 'MONTH'
SELECT DATEPART(DAY, CONVERT(datetime, '08-15-2017')) AS 'DAY'

SELECT *
	,DATEDIFF(YEAR, HireDate, GETDATE()) AS 'Work Time'
FROM Employees

SELECT DATENAME(WEEKDAY, '2017-05-05')  -- Friday

SELECT DATEADD(MONTH, 2, '2017-05-05')  -- 2017-07-05

-- Other Functions
SELECT ISNULL(NULL, 'The value is NULL')  -- Swap NULL with a specific default value

SELECT EmployeeID, FirstName, LastName
FROM Employees
ORDER BY EmployeeID
OFFSET 10 ROWS  -- Rows to skip
FETCH NEXT 5 ROWS ONLY  -- Rows to include

-- Wildcards
SELECT EmployeeID, FirstName, LastName 
FROM Employees
WHERE FirstName LIKE 'Ko_'

-- % -- any string, including zero-length
-- _ -- any single character
-- [...] -- any character within range
-- [^...] -- any character not in the range

SELECT EmployeeID, FirstName, LastName 
FROM Employees
WHERE FirstName LIKE '%ac[ki]%'

SELECT EmployeeID, FirstName, LastName 
FROM Employees
WHERE FirstName LIKE '%!%' ESCAPE '!'  -- specify prifix to treat special characters as normal
