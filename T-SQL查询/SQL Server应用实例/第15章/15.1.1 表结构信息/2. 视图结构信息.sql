SELECT
	schema_name = SCH.name,
	view_name = V.name,
	column_name = C.name,
	type_name = T.name,
	column_length_byte = C.max_length,
	column_precision = C.precision,
	column_scale = C.scale,
	column_is_nullable = C.is_nullable,
	column_is_identity = C.is_identity,
	column_is_computed = C.is_computed
FROM sys.views V
	INNER JOIN sys.schemas SCH
		ON V.schema_id = SCH.schema_id
	INNER JOIN sys.columns C
		ON V.object_id = C.object_id
	INNER JOIN sys.types T
		ON C.user_type_id = T.user_type_id
WHERE V.is_ms_shipped = 0       -- 此条件表示仅查询不是由内部 SQL Server 组件创建对象
ORDER BY schema_name, view_name, column_name