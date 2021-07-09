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
IXC AS(
	SELECT
		IXC.object_id,
		IXC.index_id,
		IXC.index_column_id,
		IXC.is_descending_key,
		IXC.is_included_column,
		column_name = C.name
	FROM sys.index_columns IXC
		INNER JOIN sys.columns C
			ON IXC.object_id = C.object_id
				AND IXC.column_id = C.column_id
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
		index_columns = STUFF(IXC_COL.index_columns, 1, 2, N''),
		index_columns_include = STUFF(IXC_COL_INCLUDE.index_columns_include, 1, 2, N'')
	FROM sys.indexes IX
		CROSS APPLY(
			SELECT index_columns = (
					SELECT
						N', ' + QUOTENAME(column_name)
							+ CASE is_descending_key
									WHEN 1 THEN N' DESC'
									ELSE N'' 
								END
					FROM IXC
					WHERE object_id = IX.object_id
						AND index_id = IX.index_id
						AND is_included_column = 0
					ORDER BY index_column_id
					FOR XML PATH(''), ROOT('r'), TYPE
				).value('/r[1]', 'nvarchar(max)')	
		)IXC_COL
		OUTER APPLY(
			SELECT index_columns_include = (
					SELECT
						N', ' + QUOTENAME(column_name)
					FROM IXC
					WHERE object_id = IX.object_id
						AND index_id = IX.index_id
						AND is_included_column = 1
					ORDER BY index_column_id
					FOR XML PATH(''), ROOT('r'), TYPE
				).value('/r[1]', 'nvarchar(max)')	
		)IXC_COL_INCLUDE
	WHERE index_id > 0 -- 不查询堆信息
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
	IX.index_columns,
	IX.index_columns_include
FROM V
	INNER JOIN IX
		ON V.object_id = IX.object_id
ORDER BY schema_name, view_name, index_name
