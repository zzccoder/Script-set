SET NOCOUNT ON

DECLARE CUR_dx CURSOR LOCAL
FOR
WITH
PT AS(
    SELECT 
		object_id, index_id,
		partition_count = COUNT (*)
    FROM sys.partitions
	GROUP BY object_id, index_id
),
DIX AS(
	SELECT
		DDIPS.object_id, 
		DDIPS.index_id,
		DDIPS.partition_number,
		DDIPS.avg_fragmentation_in_percent,
		object_name = O.name,
		schema_name = S.name,
		index_name = IX.name,
		partition_count = PT.partition_count
	FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL , NULL, 'LIMITED') DDIPS
		INNER JOIN sys.objects O
			ON DDIPS.object_id = O.object_id
		INNER JOIN sys.schemas S
			ON S.schema_id = O.schema_id
		INNER JOIN sys.indexes IX
			ON DDIPS.object_id = IX.object_id
				AND DDIPS.index_id = IX.index_id
		INNER JOIN PT
			ON DDIPS.object_id = PT.object_id
				AND DDIPS.index_id = PT.index_id
	WHERE DDIPS.avg_fragmentation_in_percent > 5
		AND DDIPS.index_id > 0
),
DIXSQL AS(
	SELECT 
		SQL = N'ALTER INDEX ' + QUOTENAME(index_name)
				+ N' ON ' + QUOTENAME(schema_name) + N'.' + QUOTENAME(object_name)
				+ CASE
					WHEN avg_fragmentation_in_percent < 30 THEN N' REORGANIZE'
					ELSE N' REBUILD' END
				+ CASE 
					WHEN partition_count > 1 
						THEN N' PARTITION =  ' + CONVERT(nvarchar(20), partition_number)
					ELSE N'' END
	FROM DIX
)
SELECT * FROM DIXSQL

DECLARE @sql nvarchar(max)
OPEN CUR_dx
FETCH CUR_dx INTO @sql
WHILE @@FETCH_STATUS = 0
BEGIN
	EXEC sp_executesql @sql
	RAISERROR(N'Executed: %s', 10, 1, @sql) WITH NOWAIT
	FETCH CUR_dx INTO @sql
END
CLOSE CUR_dx
DEALLOCATE CUR_dx
