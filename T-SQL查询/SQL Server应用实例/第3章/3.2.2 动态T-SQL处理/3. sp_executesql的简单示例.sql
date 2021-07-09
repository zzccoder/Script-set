-- 1. 使用sp_executesql实现表达式计算
DECLARE @str nvarchar(max)
SET @str = N'12+4.0/(78-1)' -- 待计算的表达式

-- 计算表达式
DECLARE 
	@sql nvarchar(max),
	@re float
SET @sql = N'SET @re = (' + @str + N')'
EXEC sp_executesql @sql,
	N'@re float OUTPUT',
	@re OUTPUT
SELECT Result = @re
GO

-- 2. 将动态查询结果定义成游标变量
DECLARE 
	@sql nvarchar(max),
	@cur CURSOR
SET @sql = N'
SET @cur = CURSOR LOCAL
FOR
SELECT name FROM sys.objects
WHERE type = @type
OPEN @cur
'
EXEC sp_executesql @sql,
	N'@cur CURSOR OUTPUT, @type char(2)',
	@cur OUTPUT, 'S'
FETCH @cur
CLOSE @cur
DEALLOCATE @cur

