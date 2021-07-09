-- ʹ��EXCEPTʵ�ֲ
SELECT object_id, name, type FROM master.sys.tables
EXCEPT
SELECT object_id, name, type FROM tempdb.sys.tables

-- ʹ��NOT INʵ�ֲ
SELECT DISTINCT
	object_id, name, type 
FROM master.sys.tables TB
WHERE object_id NOT IN( -- ����object_id��Ψһ��, ���ֻ���ô����ж��Ƿ����
		SELECT object_id
		FROM(
			SELECT object_id, name, type FROM tempdb.sys.tables
		)OBJ)

-- ʹ��NOT EXISTSʵ�ֲ
SELECT DISTINCT
	object_id, name, type 
FROM master.sys.tables TB
WHERE NOT EXISTS( -- exists�����ö������Ϊ�ж��Ƿ���ڵ�����
		SELECT object_id, name, type FROM tempdb.sys.tables
		WHERE object_id = TB.object_id
			AND name = TB.name
			AND type = TB.type)

-- ��NOT IN�Ӿ���,����CHECKSUM�ö������Ϊ�ж��Ƿ���ڵ�����
SELECT DISTINCT
	object_id, name, type 
FROM master.sys.tables TB
WHERE CHECKSUM(object_id, name, type) NOT IN(
		SELECT CHECKSUM(object_id, name, type)
		FROM(
			SELECT object_id, name, type FROM tempdb.sys.tables
		)OBJ)
