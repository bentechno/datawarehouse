USE northwinddwh_stage
GO

-- stage customers
SELECT [CustomerID]
		,[CompanyName]
		,[ContactName]
		,[ContactTitle]
		,[Address]
		,[City]
		,[Region]
		,[PostalCode]
		,[Country]
INTO [dbo].[stgNorthwindCustomers]
FROM [northwind].[dbo].[Customers]

-- stage employees
SELECT [EmployeeID]
		,[FirstName]
		,[LastName]
		,[Title]
INTO [dbo].[stgNorthwindEmployees]
FROM [northwind].[dbo].[Employees]

-- stage products
SELECT [ProductID]
		,[ProductName]
		,[Discontinued]
		,[CompanyName]
		,[CategoryName]
INTO [dbo].[stgNorthwindProducts]
FROM [northwind].[dbo].[Products] p
	join [northwind].[dbo].Suppliers s
		on p.[SupplierID]= s.[SupplierID]
	join [northwind].[dbo].Categories c
		on c.[CategoryID] = p.[CategoryID]

-- stage date
SELECT *
INTO [dbo].[stgNorthwindDates]
FROM [ExternalSources2].[dbo].[date_dimension]

-- stage fact
SELECT [ProductID]
		,d.[OrderID]
		,[CustomerID]
		,[EmployeeID]
		,[OrderDate]
		,[ShippedDate]
		,[UnitPrice]
		,[Quantity]
		,[Discount]
INTO [dbo].[stgNorthwindSales]
FROM [northwind].[dbo].[Order Details] d
	join [northwind].[dbo].[Orders] o
		on o.[OrderID] = d.[OrderID]
