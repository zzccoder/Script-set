-- 将本查询执行的结果存储为 .sql 文件， 然后在数据库引擎优化向导中引用它做为工作负荷

USE AdventureWorks
GO

SET NOCOUNT ON

-- 准备测试所涉及的表
DECLARE @tb_request TABLE(
	object_id int,
	table_name sysname,
	column_count int
)

;WITH
COLS AS(
	SELECT
		object_id,
		column_count = COUNT(*)
	FROM sys.columns
	GROUP BY object_id
)
INSERT @tb_request
SELECT 
	TB.object_id,
	table_name = QUOTENAME(S.name) + N'.' + QUOTENAME(TB.name),
	column_count = C.column_count
FROM sys.tables TB
	INNER JOIN sys.schemas S
		ON TB.schema_id = S.schema_id
	INNER JOIN COLS C
		ON TB.object_id = C.object_id
WHERE TB.is_ms_shipped = 0
IF @@ROWCOUNT = 0
BEGIN
	RAISERROR(N'当前数据库中没有用户表', 16, 1) WITH NOWAIT
	RETURN
END

-- 查询测试
DECLARE
	@object_id int,
	@table_name sysname,
	@column_count int,
	@column_count_query int,
	@row_query_count int,
	@column_list nvarchar(max),
	@sql nvarchar(max),
	@script_count int

SET @script_count = 5000
PRINT N'USE ' + QUOTENAME(DB_NAME())
WHILE @script_count > 0
BEGIN
	SET @script_count = @script_count - 1
	SELECT TOP 1
		@object_id = object_id,
		@table_name =table_name,
		@column_count = column_count,
		@column_count_query = ABS(CHECKSUM(NEWID())) % column_count + 1,
		@row_query_count = ABS(CHECKSUM(NEWID())) % 100000 + 1
	FROM @tb_request
	ORDER BY NEWID()

	IF @column_count = @column_count_query
		SET @column_list = N'*'
	ELSE
		SET @column_list = STUFF(
				(
					SELECT TOP(@column_count_query)
						N',' + QUOTENAME(name)
					FROM sys.columns
					WHERE object_id = @object_id
					ORDER BY NEWID()
					FOR XML PATH(''), ROOT('r'), TYPE
				).value('/r[1]', 'nvarchar(max)'),
			1, 1, N'')

	SET @sql = N'
GO

SELECT TOP ' + QUOTENAME(@row_query_count, N'()') + N'
	' + @column_list + N'
FROM ' + @table_name
	PRINT @sql
END