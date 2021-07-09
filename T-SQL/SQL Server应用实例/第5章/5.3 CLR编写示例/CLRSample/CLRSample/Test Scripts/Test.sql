-- 运用此程序集实现的不同 SQL 对象的查询示例

-----------------------------------------------------------------------------------------
-- 用户定义的函数
-----------------------------------------------------------------------------------------
-- 标量值函数
SELECT dbo.F_Format(GETDATE(), 'yyyyMMdd_HHmmss')

-- 表值函数
SELECT * 
FROM dbo.SplitString(N'SELECT * FROM dbo.SplitString', N' .')


-----------------------------------------------------------------------------------------
-- 聚合函数
-----------------------------------------------------------------------------------------
SELECT 
	type, names = dbo.ConcatString(name)
FROM sys.objects
GROUP BY type


-----------------------------------------------------------------------------------------
-- 存储过程
-----------------------------------------------------------------------------------------
DECLARE 
	@id int, @re int

-- 因为未处理NULL值, 因此下面的调用会出错
EXEC @re = dbo.SplitStringToTable @id OUTPUT
SELECT 
	id = @id, re = @re

-- 正确的调用
SET @id = 1
EXEC @re = dbo.SplitStringToTable @id OUTPUT
SELECT 
	id = @id, re = @re


-----------------------------------------------------------------------------------------
-- 用户定义的类型
-----------------------------------------------------------------------------------------
-- 定义引用CLR用户定义类型的变量
DECLARE @ServerInfo ServerInfo

-- 未赋值之前显示状态
SELECT 
	@ServerInfo.ConnectionString(),
	@ServerInfo

-- 赋值
SET @ServerInfo = ''
SELECT 
	CONVERT(nvarchar(200), @ServerInfo),
	@ServerInfo

-- 通过方法设置值
SET @ServerInfo.SetValue(NULL, NULL, NULL, N'tempdb', NULL)
SELECT 
	CONVERT(nvarchar(200), @ServerInfo),
	@ServerInfo

