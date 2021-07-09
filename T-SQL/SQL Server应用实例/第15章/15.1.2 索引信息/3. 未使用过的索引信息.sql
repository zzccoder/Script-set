-- ��ѯ����δʹ�ù���������Ϣ
-- ��Ҫ��SQL Server�����˺ܳ�ʱ��δ��������������������У�����ִ�н��û������
SELECT
	schema_name = SCH.name,
	table_name = TB.name,
	index_name = IX.name
FROM sys.tables TB
	INNER JOIN sys.schemas SCH
		ON TB.schema_id = SCH.schema_id
	INNER JOIN sys.indexes IX
		ON TB.object_id = IX.object_id
WHERE TB.is_ms_shipped = 0 -- ��������ʾ����ѯ�������ڲ�SQL Server �����������
	AND index_id > 0       -- ����ѯ����Ϣ
	AND NOT EXISTS(
		SELECT * FROM sys.dm_db_index_usage_stats 
		WHERE database_id = DB_ID()
			AND object_id = IX.object_id
			AND index_id = IX.index_id)
ORDER BY schema_name, table_name, index_name