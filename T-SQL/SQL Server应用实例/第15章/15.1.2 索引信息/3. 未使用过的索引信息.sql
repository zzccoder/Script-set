-- 查询所有未使用过的索引信息
-- 需要在SQL Server运行了很长时间未重新启动过的情况下运行，否则执行结果没有意义
SELECT
	schema_name = SCH.name,
	table_name = TB.name,
	index_name = IX.name
FROM sys.tables TB
	INNER JOIN sys.schemas SCH
		ON TB.schema_id = SCH.schema_id
	INNER JOIN sys.indexes IX
		ON TB.object_id = IX.object_id
WHERE TB.is_ms_shipped = 0 -- 此条件表示仅查询不是由内部SQL Server 组件创建对象
	AND index_id > 0       -- 不查询堆信息
	AND NOT EXISTS(
		SELECT * FROM sys.dm_db_index_usage_stats 
		WHERE database_id = DB_ID()
			AND object_id = IX.object_id
			AND index_id = IX.index_id)
ORDER BY schema_name, table_name, index_name