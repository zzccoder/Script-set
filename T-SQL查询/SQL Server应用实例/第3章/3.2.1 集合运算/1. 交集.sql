-- ʹ��INTERSECTʵ�ֽ���
SELECT object_id, name, type FROM sys.tables
INTERSECT
SELECT object_id, name, type FROM sys.objects

-- ʹ��INʵ�ֽ���
SELECT DISTINCT
	object_id, name, type 
FROM sys.tables TB
WHERE object_id IN( -- ����object_id��Ψһ��, ���ֻ���ô����ж��Ƿ����
		SELECT object_id
		FROM(
			SELECT object_id, name, type FROM sys.objects
		)OBJ)

-- ʹ��EXISTSʵ�ֽ���
SELECT DISTINCT
	object_id, name, type 
FROM sys.tables TB
WHERE EXISTS( -- exists�����ö������Ϊ�ж��Ƿ���ڵ�����
		SELECT object_id, name, type FROM sys.objects
		WHERE object_id = TB.object_id
			AND name = TB.name
			AND type = TB.type)

-- ��IN�Ӿ���,����CHECKSUM�ö������Ϊ�ж��Ƿ���ڵ�����
SELECT DISTINCT
	object_id, name, type 
FROM sys.tables TB
WHERE CHECKSUM(object_id, name, type) IN(
		SELECT CHECKSUM(object_id, name, type)
		FROM(
			SELECT object_id, name, type FROM sys.objects
		)OBJ)
