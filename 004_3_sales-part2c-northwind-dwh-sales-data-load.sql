USE northwinddwh_dw
GO

-- Load DimEmployee
INSERT INTO northwind.DimEmployee
			(EmployeeID, EmployeeName, EmployeeTitle)
SELECT EmployeeID, FirstName + ' ' + LastName AS EmployeeName, Title
	FROM northwinddwh_stage.dbo.stgNorthwindEmployees

-- Load DimCustomer
INSERT INTO northwind.DimCustomer
	(CustomerID, CompanyName, ContactName, ContactTitle, CustomerCountry, CustomerRegion, CustomerCity, CustomerPostalCode)
SELECT
	CustomerID, CompanyName, ContactName, ContactTitle, Country, 
	CASE WHEN Region IS NULL THEN 'N/A' ELSE Region END, City, 
	CASE WHEN PostalCode IS NULL THEN 'N/A' ELSE PostalCode END
	FROM northwinddwh_stage.dbo.stgNorthwindCustomers

-- Load DimProduct
INSERT INTO northwind.DimProduct
	(ProductID, ProductName, Discontinued, SupplierName, CategoryName)
SELECT
	ProductID, ProductName, 
	CASE WHEN Discontinued =0 THEN 'N' ELSE 'Y' END, 
	CompanyName, CategoryName
FROM northwinddwh_stage.dbo.stgNorthwindProducts

-- Load DimDate
INSERT INTO northwind.DimDate
	(DateKey, [Date], FullDateUSA, [DayOfWeek], [DayName], [DayOfMonth], [DayOfYear]
	,WeekOfYear, [MonthName], [MonthOfYear], [Quarter], [QuarterName]
	,[Year], [IsWeekday])
SELECT 
	DateKey, [Date], FullDateUSA, [DayOfWeekUSA], [DayName], [DayOfMonth], [DayOfYear]
	,WeekOfYear, [MonthName], [Month], [Quarter], [QuarterName]
	,[Year], [IsWeekday]
FROM northwinddwh_stage.dbo.stgNorthwindDates
;

-- Load FactSales
INSERT INTO northwind.FactSales
			(ProductKey, CustomerKey, EmployeeKey
			,OrderDateKey
			,ShippedDateKey
			,OrderID
			,Quantity
			,ExtendedPriceAmount
			,DiscountAmount
			,SoldAmount)
SELECT p.ProductKey, c.CustomerKey, e.EmployeeKey,
		FORMAT([OrderDate], 'yyyyMMdd') AS OrderDateKey,
		CASE WHEN FORMAT(s.ShippedDate, 'yyyyMMdd')  IS NULL THEN -1
		ELSE FORMAT(s.ShippedDate, 'yyyyMMdd') END AS ShippedDateKey,
		s.OrderId,
		Quantity,
		Quantity * UnitPrice AS ExtendedPriceAmount,
		Quantity * UnitPrice * Discount AS DiscountAmount,
		Quantity * UnitPrice * (1-Discount) AS SoldAmount
FROM northwinddwh_stage.dbo.stgNorthwindSales s
	JOIN northwinddwh_dw.northwind.DimCustomer c
		ON s.CustomerID = c.CustomerID
	JOIN northwinddwh_dw.northwind.DimEmployee e
		ON s.EmployeeID = e.EmployeeID
	JOIN northwinddwh_dw.northwind.DimProduct p
		ON s.ProductID = p.ProductID
;

CREATE VIEW northwind.SalesMart
AS
SELECT s.OrderID, s.Quantity, s.ExtendedPriceAmount, s.DiscountAmount, s.SoldAmount
		, c.CompanyName, c.ContactName, c.ContactTitle, c.CustomerCity
			,c.CustomerCountry, c.CustomerRegion, c.CustomerPostalCode
		, e.EmployeeName, e.EmployeeTitle
		, p.ProductName, p.Discontinued, p.CategoryName
		, od.*
FROM northwind.FactSales s
	JOIN northwind.DimCustomer c ON c.CustomerKey = s.CustomerKey
	JOIN northwind.DimEmployee e ON e.EmployeeKey = s.EmployeeKey
	JOIN northwind.DimProduct p ON p.ProductKey = s.ProductKey
	JOIN northwind.DimDate od ON od.DateKey = s.OrderDateKey

