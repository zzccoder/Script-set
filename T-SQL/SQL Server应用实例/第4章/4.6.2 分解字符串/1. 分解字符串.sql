SELECT
	table_name = TB.name,
	column_names = C.column_names.value('/c[1]', 'nvarchar(max)')
FROM sys.tables TB
	CROSS APPLY(
		SELECT column_names = (
				SELECT name
				FROM sys.columns c
				WHERE object_id = TB.object_id
				FOR XML AUTO, TYPE
			).query('<c>
				{for $i in /c[position()<last()]/@name return concat(string($i),",")}
				{concat(" ",string(/c[last()]/@name))}
				</c>')
	)C
