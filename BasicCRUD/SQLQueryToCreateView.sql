CREATE VIEW v_TopTenHighestSalaries AS
	  SELECT TOP (10) [FirstName] + ' ' + [LastName] AS [Full Name]
		  ,[JobTitle]
		  ,[Salary]
		  ,HireDate
	  FROM [DatabaseExample].[dbo].[Employees]
	  ORDER BY Salary DESC  -- Descending order
