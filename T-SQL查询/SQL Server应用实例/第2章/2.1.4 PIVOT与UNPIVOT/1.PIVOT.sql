WITH
OBJ AS(
	SELECT type FROM sys.objects
)
SELECT *
FROM OBJ
PIVOT(
	COUNT(type)
	FOR type 
	IN([U], [V], [P])
)P
GO

-- PIVOT操作的数据源包含多余的列
SELECT U,V,P
FROM sys.objects
PIVOT(
	COUNT(type)
	FOR type 
	IN([U], [V], [P])
)P