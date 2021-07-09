-- 1. 使用 sql:column 函数
DECLARE @test xml
SET @test = ''

SELECT TOP 1
	@test = @test.query('<s>{sql:column("name")}</s>')
FROM sys.objects

SELECT @test
GO


-- 2. 使用 sql:variable 函数
-- 生成 xml 数据
DECLARE @test xml
SET @test = (
		SELECT * FROM sys.objects OBJ
		FOR XML AUTO, TYPE, ROOT('OBJS')
	)

-- 对 xml 数据进行查询
DECLARE 
	@column_name sysname,
	@row_no int

SELECT 
	@column_name = N'name',  -- 指定查询的属性
	@row_no = 4              -- 指定查询第几个OBJ节点

SELECT @test
SELECT @test.value('(/OBJS/OBJ[sql:variable("@row_no")]/@*[local-name()=sql:variable("@column_name")])[1]', 'nvarchar(max)')