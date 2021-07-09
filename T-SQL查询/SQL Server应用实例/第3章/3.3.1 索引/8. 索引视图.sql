USE AdventureWorks
GO

-- ����������ͼʱ�� ���������ѡ������
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

-- ������ͼ
CREATE VIEW Sales.v_SaleOrders
WITH SCHEMABINDING   -- ������ͼҪ�������д���
AS
SELECT 
	O.OrderDate, OD.ProductID,
	Revenue = SUM(OD.UnitPrice * OD.OrderQty * (1 - OD.OrderQty)),
	ItemCount = COUNT_BIG(*)   -- ������ͼ�б�����COUNT_BIG
FROM Sales.SalesOrderHeader O
	INNER JOIN Sales.SalesOrderDetail OD
		ON O.SalesOrderID = OD.SalesOrderID
GROUP BY O.OrderDate, OD.ProductID
GO
-- ����ͼ�Ͻ�������
CREATE UNIQUE CLUSTERED INDEX IXUC_ProductID_OrderDate
	ON Sales.v_SaleOrders(
		ProductID, OrderDate)
GO

-- ִ������ͼ��صĲ�ѯ����ѯ����������ͼ��
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

-- ɾ����ʾ����
DROP VIEW Sales.v_SaleOrders