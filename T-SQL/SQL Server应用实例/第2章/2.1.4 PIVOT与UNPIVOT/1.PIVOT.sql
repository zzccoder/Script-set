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

-- PIVOT����������Դ�����������
SELECT U,V,P
FROM sys.objects
PIVOT(
	COUNT(type)
	FOR type 
	IN([U], [V], [P])
)P