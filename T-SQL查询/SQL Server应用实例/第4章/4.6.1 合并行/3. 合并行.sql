SELECT
	table_name = TB.name,
	column_names = STUFF(C.column_names.query('(/a/text())').value('.', 'nvarchar(max)'), 1, 1, N''),
	column_ids = STUFF(C.column_names.query('(/b/text())').value('.', 'varchar(max)'), 1, 1, N'')
FROM sys.tables TB
	CROSS APPLY(
		SELECT column_names = (
				SELECT 
					a = N',' + name, 
					b = ',' + RTRIM(column_id)
				FROM sys.columns 
				WHERE object_id = TB.object_id
				FOR XML PATH(''), TYPE
			)
	)C