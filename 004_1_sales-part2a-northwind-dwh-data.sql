-- Creer les structures des tables de dimensions et de faits mais sans aucune données
USE northwinddwh_dw
GO
CREATE SCHEMA northwind
GO

DROP TABLE northwind.DimCustomer;
DROP TABLE northwind.DimDate;
DROP TABLE northwind.DimProduct;
DROP TABLE northwind.DimEmployee;
DROP TABLE northwind.FactSales;

CREATE TABLE northwind.DimCustomer (
   [CustomerKey]  int IDENTITY  NOT NULL
,  [CustomerID]  nvarchar(5)   NOT NULL
,  [CompanyName]  nvarchar(40)   NOT NULL
,  [ContactName]  nvarchar(30)   NOT NULL
,  [ContactTitle]  nvarchar(30)   NOT NULL
,  [CustomerCountry]  nvarchar(15)   NOT NULL
,  [CustomerRegion]  nvarchar(15)  DEFAULT 'N/A' NOT NULL
,  [CustomerCity]  nvarchar(15)   NOT NULL
,  [CustomerPostalCode]  nvarchar(10)   NOT NULL
,  [RowIsCurrent]  bit  DEFAULT 1 NOT NULL
,  [RowStartDate]  datetime  DEFAULT '12/31/1899' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NULL
, CONSTRAINT [PK_northwind.DimCustomer] PRIMARY KEY CLUSTERED 
( [CustomerKey] )
) ON [PRIMARY]
;

CREATE TABLE northwind.DimDate (
   [DateKey]  int NOT NULL
,  [Date]  date   NULL
,  [FullDateUSA]  nchar(11)   NOT NULL
,  [DayOfWeek]  tinyint   NOT NULL
,  [DayName]  nchar(10)   NOT NULL
,  [DayOfMonth]  tinyint   NOT NULL
,  [DayOfYear]  smallint   NOT NULL
,  [WeekOfYear]  tinyint   NOT NULL
,  [MonthName]  nchar(10)   NOT NULL
,  [MonthOfYear]  tinyint   NOT NULL
,  [Quarter]  tinyint   NOT NULL
,  [QuarterName]  nchar(10)   NOT NULL
,  [Year]  smallint   NOT NULL
,  [IsWeekday]  bit  DEFAULT 0 NOT NULL
, CONSTRAINT [PK_northwind.DimDate] PRIMARY KEY CLUSTERED 
( [DateKey] )
) ON [PRIMARY]
;

CREATE TABLE northwind.DimProduct (
   [ProductKey]  int IDENTITY  NOT NULL
,  [ProductID]  int   NOT NULL
,  [ProductName]  nvarchar(40)   NOT NULL
,  [Discontinued]  nchar(1)  DEFAULT 'N' NOT NULL
,  [SupplierName]  nvarchar(40)   NOT NULL
,  [CategoryName]  nvarchar(15)   NOT NULL
,  [RowIsCurrent]  bit  DEFAULT 1 NOT NULL
,  [RowStartDate]  datetime  DEFAULT '12/31/1899' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NULL
, CONSTRAINT [PK_northwind.DimProduct] PRIMARY KEY CLUSTERED 
( [ProductKey] )
) ON [PRIMARY]
;

CREATE TABLE northwind.DimEmployee (
   [EmployeeKey]  int IDENTITY  NOT NULL
,  [EmployeeID]  int   NOT NULL
,  [EmployeeName]  nvarchar(40)   NOT NULL
,  [EmployeeTitle]  nvarchar(30)   NOT NULL
,  [RowIsCurrent]  bit   DEFAULT 1 NOT NULL
,  [RowStartDate]  datetime  DEFAULT '12/31/1899' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NULL
, CONSTRAINT [PK_northwind.DimEmployee] PRIMARY KEY CLUSTERED 
( [EmployeeKey] )
) ON [PRIMARY]
;

CREATE TABLE northwind.FactSales (
   [ProductKey]  int   NOT NULL
,  [CustomerKey]  int   NOT NULL
,  [EmployeeKey]  int   NOT NULL
,  [OrderDateKey]  int   NOT NULL
,  [ShippedDateKey]  int   NOT NULL
,  [OrderID]  int   NOT NULL
,  [Quantity]  smallint   NOT NULL
,  [ExtendedPriceAmount]  money   NOT NULL
,  [DiscountAmount]  money  DEFAULT 0 NOT NULL
,  [SoldAmount]  money   NOT NULL
, CONSTRAINT [PK_northwind.FactSales] PRIMARY KEY NONCLUSTERED 
( [ProductKey], [OrderID] )
) ON [PRIMARY]
;

ALTER TABLE northwind.FactSales ADD CONSTRAINT
   FK_northwind_FactSales_ProductKey FOREIGN KEY
   (
   ProductKey
   ) REFERENCES northwind.DimProduct
   ( ProductKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;

ALTER TABLE northwind.FactSales ADD CONSTRAINT
   FK_northwind_FactSales_CustomerKey FOREIGN KEY
   (
   CustomerKey
   ) REFERENCES northwind.DimCustomer
   ( CustomerKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;

ALTER TABLE northwind.FactSales ADD CONSTRAINT
   FK_northwind_FactSales_EmployeeKey FOREIGN KEY
   (
   EmployeeKey
   ) REFERENCES northwind.DimEmployee
   ( EmployeeKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;

ALTER TABLE northwind.FactSales ADD CONSTRAINT
   FK_northwind_FactSales_OrderDateKey FOREIGN KEY
   (
   OrderDateKey
   ) REFERENCES northwind.DimDate
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;

ALTER TABLE northwind.FactSales ADD CONSTRAINT
   FK_northwind_FactSales_ShippedDateKey FOREIGN KEY
   (
   ShippedDateKey
   ) REFERENCES northwind.DimDate
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;