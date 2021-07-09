WITH
OBJ AS(
	SELECT
		name, type, create_date 
	FROM sys.objects
)
SELECT
	*,
	[ROW_NUMBER_type] = ROW_NUMBER() OVER(PARTITION BY type ORDER BY create_date),
	[RANK_type] = RANK() OVER(PARTITION BY type ORDER BY create_date),
	[DENSE_RANK_type] = DENSE_RANK() OVER(PARTITION BY type ORDER BY create_date),
	[NTILE_type] = NTILE(5) OVER(PARTITION BY type ORDER BY create_date),

	[ROW_NUMBER] = ROW_NUMBER() OVER(ORDER BY type, create_date),
	[RANK] = RANK() OVER(ORDER BY type, create_date),
	[DENSE_RANK] = DENSE_RANK() OVER(ORDER BY type, create_date),
	[NTILE] = NTILE(5) OVER(ORDER BY type, create_date)
FROM OBJ
ORDER BY type, create_date
