-- 1. PATH模式
SELECT
	[@create_date] = TB.create_date,
	[@modify_date] = TB.modify_date,
	RTRIM(TB.name),
	[Column/@max_length] = C.max_length,
	[Column/@precision] = C.precision,
	[Column/@scale] = C.scale,
	[Column] = C.name,
	[Column/Type] = T.name
FROM sys.tables TB
	INNER JOIN sys.columns C
		ON TB.object_id = C.object_id
	INNER JOIN sys.types T
		ON C.user_type_id = T.user_type_id
ORDER BY TB.object_id, C.name
FOR XML PATH('Table')
GO

-- 2. PATH 模式生成嵌套的XML数据
SELECT
	[@create_date] = TB.create_date,
	[@modify_date] = TB.modify_date,
	[*] = TB.name,
	[*] = C.Colomn
FROM sys.tables TB
	CROSS APPLY(
		SELECT Colomn = (
			SELECT
				[@max_length] = C.max_length,
				[@precision] = C.precision,
				[@scale] = C.scale,
				[*] = name,
				[*] = T.Type
			FROM sys.columns C
				CROSS APPLY(
					SELECT Type = (
						SELECT
							[*] = name
						FROM sys.types T
						WHERE user_type_id = C.user_type_id
						FOR XML PATH('Type'), TYPE)
				)T
			WHERE object_id = TB.object_id
			ORDER BY name
			FOR XML PATH('Column'), TYPE)			
	)C
ORDER BY object_id
FOR XML PATH('Table')
