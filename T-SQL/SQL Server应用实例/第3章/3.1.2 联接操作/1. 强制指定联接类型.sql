USE model

-- ǿ��ʹ��Ƕ��ѭ������
SELECT 
	TableName = OBJ.name, 
	ColumnName = COL.name
FROM sys.objects OBJ
	INNER JOIN sys.columns Col
		ON OBJ.object_id = COL.object_id
OPTION(LOOP JOIN )

-- ǿ��ʹ�úϲ�����
SELECT 
	TableName = OBJ.name, 
	ColumnName = COL.name
FROM sys.objects OBJ
	INNER JOIN sys.columns Col
		ON OBJ.object_id = COL.object_id
OPTION(MERGE JOIN )

-- ǿ��ʹ�ù�ϣ����
SELECT 
	TableName = OBJ.name, 
	ColumnName = COL.name
FROM sys.objects OBJ
	INNER JOIN sys.columns Col
		ON OBJ.object_id = COL.object_id
OPTION(HASH JOIN )
