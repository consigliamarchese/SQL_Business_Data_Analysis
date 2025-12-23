-- =========================================
-- File: 01_SQL_Product_Employee_Insights.sql
-- Objective: Explore product and employee data to extract business insights
-- Skills demonstrated: SQL SELECT, filtering, aggregations, calculating markup,
-- basic business logic, data exploration
-- Tables used: DimProduct, DimEmployee, FactResellerSales
-- =========================================
-- 1. View all products
SELECT *
FROM dimproduct;

-- 2. Finished goods info
SELECT ProductKey AS CODICEPRODOTTO,
       ProductAlternateKey,
       EnglishProductName AS NOMEPRODOTTO,
       Color,
       StandardCost,
       FinishedGoodsFlag
FROM dimproduct
WHERE FinishedGoodsFlag = 1;

-- 3. Product markup
SELECT ProductKey,
       ModelName AS NomeModello,
       EnglishProductName AS NomeProdotto,
       StandardCost AS CostoStandard,
       ListPrice AS Prezzodilistino,
       ListPrice - StandardCost AS Markup
FROM dimproduct
WHERE ProductAlternateKey LIKE "%FR%" OR ProductAlternateKey LIKE "%BR%";

-- 4. Finished goods with list price 1000-2000
SELECT ProductKey AS CODICEPRODOTTO,
       EnglishProductName AS NOMEPRODOTTO,
       ListPrice
FROM dimproduct
WHERE FinishedGoodsFlag = 1
  AND ListPrice BETWEEN 1000 AND 2000
ORDER BY ListPrice DESC;

-- 5. View salespersons
SELECT *
FROM dimemployee
WHERE SalesPersonFlag = 1;

-- 6. Profit for selected products since 2020-01-01
SELECT SalesOrderNumber,
       SalesOrderLineNumber,
       OrderDate,
       ProductKey,
       ResellerKey,
       SalesAmount - TotalProductCost AS PROFITTO
FROM factresellersales
WHERE ProductKey IN (597,598,477,214)
  AND OrderDate >= '2020-01-01'
ORDER BY PROFITTO DESC, OrderDate;
