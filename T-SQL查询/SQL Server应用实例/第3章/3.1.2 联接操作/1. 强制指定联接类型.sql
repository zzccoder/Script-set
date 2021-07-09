USE model

-- 强制使用嵌套循环联接
SELECT 
	TableName = OBJ.name, 
	ColumnName = COL.name
FROM sys.objects OBJ
	INNER JOIN sys.columns Col
		ON OBJ.object_id = COL.object_id
OPTION(LOOP JOIN )

-- 强制使用合并联接
SELECT 
	TableName = OBJ.name, 
	ColumnName = COL.name
FROM sys.objects OBJ
	INNER JOIN sys.columns Col
		ON OBJ.object_id = COL.object_id
OPTION(MERGE JOIN )

-- 强制使用哈希联接
SELECT 
	TableName = OBJ.name, 
	ColumnName = COL.name
FROM sys.objects OBJ
	INNER JOIN sys.columns Col
		ON OBJ.object_id = COL.object_id
OPTION(HASH JOIN )
