USE AdventureWorks
GO

-- 建立索引视图时， 必须满足的选项设置
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

-- 建立视图
CREATE VIEW Sales.v_SaleOrders
WITH SCHEMABINDING   -- 索引视图要求必须具有此项
AS
SELECT 
	O.OrderDate, OD.ProductID,
	Revenue = SUM(OD.UnitPrice * OD.OrderQty * (1 - OD.OrderQty)),
	ItemCount = COUNT_BIG(*)   -- 索引视图中必须用COUNT_BIG
FROM Sales.SalesOrderHeader O
	INNER JOIN Sales.SalesOrderDetail OD
		ON O.SalesOrderID = OD.SalesOrderID
GROUP BY O.OrderDate, OD.ProductID
GO
-- 在视图上建立索引
CREATE UNIQUE CLUSTERED INDEX IXUC_ProductID_OrderDate
	ON Sales.v_SaleOrders(
		ProductID, OrderDate)
GO

-- 执行与视图相关的查询（查询并不引用视图）
SET SHOWPLAN_TEXT ON
GO
SELECT 
	OD.ProductID,
	Revenue = AVG(OD.UnitPrice * OD.OrderQty * (1 - OD.OrderQty))
FROM Sales.SalesOrderHeader O
	INNER JOIN Sales.SalesOrderDetail OD
		ON O.SalesOrderID = OD.SalesOrderID
WHERE OrderDate >= '20020101' 
	AND OrderDate < '20030101'
GROUP BY OD.ProductID
GO
SET SHOWPLAN_TEXT OFF
GO

-- 删除演示环境
DROP VIEW Sales.v_SaleOrders