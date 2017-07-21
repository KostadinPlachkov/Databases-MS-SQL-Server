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

