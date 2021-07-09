WITH
TB AS(
	SELECT 
		object_id, object_name = name
	FROM sys.tables
),
COL AS(
	SELECT 
		object_id, column_name = name
	FROM sys.columns
)
SELECT
	TB.object_id, TB.object_name,
	COL.column_name
FROM TB, COL
WHERE TB.object_id = COL.object_id
ORDER BY TB.object_id, COL.column_name
