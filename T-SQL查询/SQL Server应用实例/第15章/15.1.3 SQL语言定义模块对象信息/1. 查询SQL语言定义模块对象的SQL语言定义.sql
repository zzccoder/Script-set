SELECT
	object_type = O.type_desc,
	object_name = O.name,
	O.create_date,
	O.modify_date,
	sql_definition = M.definition
FROM sys.sql_modules M
	INNER JOIN sys.objects O
		ON M.object_id = O.object_id
WHERE O.is_ms_shipped = 0
ORDER BY object_type, object_name