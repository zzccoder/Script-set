-- 1. FOR XML AUTO
WITH
TB AS(
	SELECT 
		id = object_id, table_name = name,
		create_date, modify_date
	FROM sys.tables
),
COL AS(
	SELECT 
		id = object_id, column_name = name,
		max_length, precision, scale,
		user_type_id
	FROM sys.columns
),
TYP AS(
	SELECT 
		user_type_id, type_name = name
	FROM sys.types
)
SELECT
	TB.table_name, TB.create_date, TB.modify_date,
	COL.column_name,
	TYP.type_name,
	COL.max_length, COL.precision, COL.scale
FROM TB
	INNER JOIN COL
		ON TB.id = COL.id
	INNER JOIN TYP
		ON COL.user_type_id = TYP.user_type_id
ORDER BY COL.id, COL.column_name
FOR XML AUTO
GO


-- 2. FOR XML AUTO
--   ���ɵ�XML�ĵ��е�XML��νṹ����Ԫ��Ƕ�ף�������SELECT�Ӿ���ָ����������ʶ��������˳��
--   ��FROM�Ӿ���������˳���޹�
WITH
TB AS(
	SELECT 
		id = object_id, table_name = name,
		create_date, modify_date
	FROM sys.tables
),
COL AS(
	SELECT 
		id = object_id, column_name = name,
		max_length, precision, scale,
		user_type_id
	FROM sys.columns
),
TYP AS(
	SELECT 
		user_type_id, type_name = name
	FROM sys.types
)
SELECT
	TB.table_name, TB.create_date, TB.modify_date,
	TYP.type_name,
	COL.column_name,
	COL.max_length, COL.precision, COL.scale
FROM TB
	INNER JOIN COL
		ON TB.id = COL.id
	INNER JOIN TYP
		ON COL.user_type_id = TYP.user_type_id
ORDER BY COL.id, COL.column_name
FOR XML AUTO
GO


-- 3. FOR XML AUTO �е�����˳��
WITH
A AS(
	SELECT id = 1 UNION ALL
	SELECT id = 2
),
B AS(
	SELECT id = 1, value = 1 UNION ALL
	SELECT id = 1, value = 3 UNION ALL
	SELECT id = 2, value = 2
)
SELECT
	A.id,
	B.value
FROM A, B
WHERE A.id = B.id
ORDER BY B.value
FOR XML AUTO
