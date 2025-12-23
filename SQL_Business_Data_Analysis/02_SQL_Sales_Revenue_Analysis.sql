-- =========================================
-- File: 02_SQL_Sales_Revenue_Analysis.sql
-- Objective: Analyze sales data to extract revenue, quantity and transaction insights
-- Skills demonstrated: SQL SELECT, JOIN, GROUP BY, HAVING, aggregation functions, basic business insights
-- Tables used: FactResellerSales, DimProduct, DimProductCategory, DimProductSubcategory, DimGeography
-- =========================================
-- 1. Verify ProductKey as primary key
SELECT ProductKey, COUNT(*)
FROM dimproduct
GROUP BY ProductKey
HAVING COUNT(*) > 1;

-- 2. Verify SalesOrderNumber + SalesOrderLineNumber as composite PK
SELECT SalesOrderNumber,
       SalesOrderLineNumber,
       COUNT(*)
FROM factresellersales
GROUP BY SalesOrderNumber, SalesOrderLineNumber
HAVING COUNT(*) > 1;

-- 3. Count daily transactions since 2020-01-01
SELECT OrderDate as Data, 
       COUNT(SalesOrderLineNumber) AS NumeroTransazioni
FROM factresellersales
WHERE OrderDate >= '2020-01-01'
GROUP BY OrderDate
ORDER BY OrderDate;

-- 4. Total revenue, quantity, average unit price per product
SELECT p.EnglishProductName as NOMEPRODOTTO,
       SUM(s.SalesAmount) as FatturatoTotale,
       SUM(s.OrderQuantity) as QuantitaTotaleVenduta,
       AVG(s.UnitPrice) as PrezzoMedioVendita
FROM factresellersales as s
INNER JOIN dimproduct as p
ON p.ProductKey = s.ProductKey
WHERE s.OrderDate >= '2020-01-01'
GROUP BY EnglishProductName
ORDER BY FatturatoTotale DESC;

-- 5. Total revenue and quantity per product category
SELECT c.EnglishProductCategoryName as CATEGORIA,
       SUM(s.SalesAmount) as TOTALEFATTURATO,
       SUM(s.OrderQuantity) as QUANTITATOTALE
FROM factresellersales as s
INNER JOIN dimproduct as p
ON s.ProductKey = p.ProductKey
INNER JOIN dimproductsubcategory as sc
ON sc.ProductSubcategoryKey = p.ProductSubcategoryKey
INNER JOIN dimproductcategory as c
ON c.ProductCategoryKey = sc.ProductCategoryKey
GROUP BY c.EnglishProductCategoryName
ORDER BY TOTALEFATTURATO DESC;

-- 6. Total revenue per city over 60K since 2020-01-01
SELECT g.City as CITTA,
       SUM(s.SalesAmount) as FATTURATO
FROM factresellersales as s
INNER JOIN dimgeography as g
ON g.SalesTerritoryKey = s.SalesTerritoryKey
WHERE s.OrderDate >= '2020-01-01'
GROUP BY g.City
HAVING SUM(s.SalesAmount) > 60000
ORDER BY FATTURATO DESC, CITTA ASC;
