;WITH
DEP AS(
	SELECT DISTINCT
		object_id,
		referenced_object_id = referenced_major_id
	FROM sys.sql_dependencies D
	WHERE class IN(0, 1)
),
DEP_TREE AS(
	SELECT
		object_id,
		level = 0,
		path = CONVERT(varchar(8000),
				RIGHT(10000 + ROW_NUMBER() OVER(ORDER BY object_id), 4))
	FROM DEP A
	WHERE NOT EXISTS(
			SELECT * FROM DEP
			WHERE referenced_object_id = A.object_id)
	UNION ALL
	SELECT
		object_id = A.referenced_object_id,
		level = B.level + 1,
		path = CONVERT(varchar(8000),
				B.path + 
				RIGHT(10000 + ROW_NUMBER() OVER(ORDER BY A.referenced_object_id), 4))
	FROM DEP A, DEP_TREE B
	WHERE A.object_id = B.object_id
		AND A.object_id <> A.referenced_object_id
),
DEP_INFO AS(
	SELECT 
		schema_name = SCH.name,
		object_name = O.name,
		object_type = O.type_desc,
		DEP.level,
		DEP.path		
	FROM DEP_TREE DEP
		INNER JOIN sys.objects O
			ON DEP.object_id = O.object_id
		INNER JOIN sys.schemas SCH
			ON O.schema_id = SCH.schema_id
)
SELECT
	object_name = REPLICATE(N' ', level * 2)
			+ N'|- ' 
			+ QUOTENAME(schema_name) + N'.' + QUOTENAME(object_name),
	object_type,
	level
FROM DEP_INFO
ORDER BY path