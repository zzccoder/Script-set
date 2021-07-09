WITH
LIB AS(
	SELECT type = 'S', ShowCount = 2 UNION ALL
	SELECT type = 'V', ShowCount = 1 UNION ALL
	SELECT type = 'P', ShowCount = 3
)
SELECT 
	LIB.*,
	O.*
FROM LIB
	CROSS APPLY(
		SELECT TOP (LIB.ShowCount) 
			name, create_date
		FROM sys.objects
		ORDER BY create_date
	)O
ORDER BY LIB.type, O.create_date