;WITH
TB AS(
	SELECT
		TB.object_id,
		schema_name = SCH.name,
		table_name = TB.name
	FROM sys.tables TB
		INNER JOIN sys.schemas SCH
			ON TB.schema_id = SCH.schema_id
	WHERE TB.is_ms_shipped = 0       -- 此条件表示仅查询不是由内部 SQL Server 组件创建对象
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
	TB.schema_name,
	TB.table_name,
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
FROM TB
	INNER JOIN IX
		ON TB.object_id = IX.object_id
ORDER BY schema_name, table_name, index_name, index_column_id
