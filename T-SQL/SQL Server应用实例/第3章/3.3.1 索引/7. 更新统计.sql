DECLARE CUR_ix CURSOR
LOCAL
FOR
WITH
IX AS(
	SELECT 
		schema_name = S.name,
		table_name = TB.name,
		index_name = IX.name
	FROM sys.indexes IX
		INNER JOIN sys.tables TB
			ON IX.object_id = TB.object_id
		INNER JOIN sys.schemas S
			ON TB.schema_id = S.schema_id
	WHERE TB.is_ms_shipped = 0
		AND IX.index_id >= 1
		AND IX.is_hypothetical = 0
		AND STATS_DATE(IX.object_id, IX.index_id) < DATEADD(Month, -1, GETDATE())
),
IXSQL AS(
	SELECT 
		SQL = N'UPDATE STATISTICS ' + QUOTENAME(schema_name)
				+ N'.' + QUOTENAME(table_name)
				+ N' ' + QUOTENAME(index_name)
	FROM IX
)
SELECT * FROM IXSQL

DECLARE @sql nvarchar(max)
OPEN CUR_ix
FETCH CUR_ix INTO @sql
WHILE @@FETCH_STATUS = 0
BEGIN
	RAISERROR(N'Executed: %s', 10, 1, @sql) WITH NOWAIT
	EXEC sp_executesql @sql
	FETCH CUR_ix INTO @sql
END
CLOSE CUR_ix
DEALLOCATE CUR_ix


