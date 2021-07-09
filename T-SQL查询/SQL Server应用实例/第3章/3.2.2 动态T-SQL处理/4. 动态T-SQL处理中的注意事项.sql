-- 1. 动态T-SQL处理中的数据类型问题
DECLARE @value int
SET @value = 100

DECLARE @sql varchar(8000)
SET @sql='SELECT * FROM tbname WHERE col=' + @value
EXEC(@sql)
GO

-- 2. 动态T-SQL处理中的字符串边界符的问题
--    a. 需要正确使用字符串边界符
DECLARE @value varchar(10)
SET @value = 'aa'

DECLARE 
	@sql1 varchar(8000),
	@sql2 varchar(8000),
	@sql3 varchar(8000)

-- 未使用字符串边界符
SET @sql1 = 'SELECT * FROM tbname WHERE col1=' + @value

-- 缺少字符串边界符
SET @sql2 = 'SELECT * FROM tbname WHERE col1='' + @value + '

-- 正确的处理拼接方法
SET @sql3 = 'SELECT * FROM tbname WHERE col1=''' + @value + ''''
GO

--    b. 需要注意字符串中本身包含的字符串边界符
DECLARE @value varchar(10)
SELECT @value = 'a''a'

DECLARE @sql varchar(8000)
-- 未考虑字符串中本身包含的字符串边界符
SET @sql = 'SELECT * FROM tbname WHERE col=''' + @value + ''''
EXEC(@sql)

-- 正确处理字符串中本身包含的字符串边界符
SET @sql = 'SELECT * FROM tbname WHERE col=''' 
		+ REPLACE(@value, '''', '''''') + ''''
EXEC(@sql)
GO

-- 3. 变量中的对象名
--    a. 直接引用变量
DECLARE @tbname sysname
SET @tbname = 'sysobjects'
SELECT * FROM @tbname

-- 正确的方法
EXEC('SELECT * FROM ' + @tbname)
GO

--    b. sp_executesql中易犯的错误: 对象名做参数
DECLARE @tbname sysname
SET @tbname = 'sysobjects'
EXEC sp_executesql
	N'SELECT * FROM @tbname',
	N'@tbname sysname',
	@tbname
GO

-- 4. 动态T-SQL处理中的参数传递
DECLARE 
	@tbname sysname, @sql varchar(100), @sqlN nvarchar(4000)

-- 试图把引用外部定义的变量
SET @sql = 'SELECT TOP 1 @tbname = name FROM sys.objects'
EXEC(@sql)
SELECT @tbname

-- 正确的方法
SET @sqlN = N'SELECT TOP 1 @tbname = name FROM sys.objects'
EXEC sp_executesql 
	@sqlN,
	N'@tbname sysname OUTPUT',
	@tbname OUTPUT
SELECT @tbname
GO

-- 5. QUOTENAME在动态T-SQL处理中的应用
DECLARE 
	@tbname sysname,@value varchar(10),@date datetime

SELECT 
	@tbname = 'tb name''s',
	@value = 'a''b',
	@date = GETDATE()
DECLARE @sql varchar(4000)
SET @sql = 'SELECT * FROM ' + QUOTENAME(@tbname)
	+ ' WHERE col1 = ' + QUOTENAME(@value, '''')
	+ ' AND col2 = '+QUOTENAME(@date, '''')
EXEC(@sql)
