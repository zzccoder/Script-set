-- ��ʾ�����
DECLARE @t TABLE(id int)

-- 1. ��INSERT�����ʹ��OUTPUT
--    OUTPUT���ֱ�ӷ��ظ�������
INSERT @t
OUTPUT INSERTED.*
SELECT object_id FROM sys.objects O


-- 2. ��UPDATE�����ʹ��OUTPUT
--    OUTPUT���FROM�Ӿ���ָ���ı��е���, ������ڱ�UPDATE�ı��в�������
UPDATE A SET
	id = O.object_id % 100
OUTPUT 
	O.name,
	DELETED.id AS id_BeforeUpdate, 
	INSERTED.id AS id_AfterUpdate
FROM @t A, sys.objects O
WHERE A.id = O.object_id


-- 3. ��DELETE�����ʹ��OUTPUT
--    ����Ľ�����ظ�ָ���ı����

--    a. ���ڱ����������ı����
DECLARE @re TABLE(
	id int, name sysname)

--    b. ɾ��
DELETE A
OUTPUT 
	DELETED.id, O.name
INTO @re
FROM @t A, sys.objects O
WHERE A.id = O.object_id

--    c. ��ʾ���
SELECT * FROM @re
