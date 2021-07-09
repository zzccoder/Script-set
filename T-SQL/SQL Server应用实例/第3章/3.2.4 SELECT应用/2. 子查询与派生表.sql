-- 1. 通过子查询结合派生表实现横向聚合
;WITH
TB AS(
	SELECT type = 'A', col1 = 1, col2 = 3, col3 = 5, col4 = 9 UNION ALL
	SELECT type = 'B', col1 = 5, col2 = 1, col3 = 7, col4 = 1 UNION ALL
	SELECT type = 'C', col1 = 3, col2 = 7, col3 = 2, col4 = 6 UNION ALL
	SELECT type = 'D', col1 = 6, col2 = 8, col3 = 5, col4 = 2
)
SELECT
	type,
	colMax = (
			SELECT 
				MAX(col) 
			FROM(
					SELECT col = TB.col1 UNION ALL
					SELECT col = TB.col2 UNION ALL
					SELECT col = TB.col3 UNION ALL
					SELECT col = TB.col4
			)A
		)
FROM TB
