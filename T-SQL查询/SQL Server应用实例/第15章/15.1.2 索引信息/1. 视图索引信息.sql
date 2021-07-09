;WITH
V AS(
	SELECT
		V.object_id,
		schema_name = SCH.name,
		view_name = V.name
	FROM sys.views V
		INNER JOIN sys.schemas SCH
			ON V.schema_id = SCH.schema_id
	WHERE V.is_ms_shipped = 0       -- 此条件表示仅查询不是由内部 SQL Server 组件创建对象
),
IX AS(
	SELECT
		IX.object_id,
		index_name = IX.name,
		index_type_desc = IX.type_desc,
		IX.is_unique,
		IX.is_primary_key,
		IX.is_unique_constraint,
		IX.is_disabled,
		index_column_name = C.name,
		IXC.index_column_id,
		IXC.is_descending_key,
		IXC.is_included_column
	FROM sys.indexes IX
		INNER JOIN sys.index_columns IXC
			ON IX.object_id = IXC.object_id
				AND IX.index_id = IXC.index_id
		INNER JOIN sys.columns C
			ON IXC.object_id = C.object_id
				AND IXC.column_id = C.column_id
)
SELECT
	V.schema_name,
	V.view_name,
	IX.index_name,
	IX.index_type_desc,
	IX.is_unique,
	IX.is_primary_key,
	IX.is_unique_constraint,
	IX.is_disabled,
	IX.index_column_name,
	IX.index_column_id,
	IX.is_descending_key,
	IX.is_included_column
FROM V
	INNER JOIN IX
		ON V.object_id = IX.object_id
ORDER BY schema_name, view_name, index_name, index_column_id
