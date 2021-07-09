SELECT
	table_name = TB.name,
	column_names = STUFF(C.column_names.value('(/r)[1]', 'nvarchar(max)'), 1, 1, N'')
FROM sys.tables TB
	CROSS APPLY(
		SELECT column_names = (
				SELECT N',' + name
				FROM sys.columns 
				WHERE object_id = TB.object_id
				FOR XML PATH(''), ROOT('r'), TYPE
			)
	)C
