-- ʹ��UNIONʵ�ֲ�����ȥ���ظ�ֵ
SELECT object_id, name, type FROM sys.tables
UNION
SELECT object_id, name, type FROM sys.objects

-- ʹ��UNION ALLʵ�ֲ���
SELECT object_id, name, type FROM sys.tables
UNION ALL
SELECT object_id, name, type FROM sys.objects
