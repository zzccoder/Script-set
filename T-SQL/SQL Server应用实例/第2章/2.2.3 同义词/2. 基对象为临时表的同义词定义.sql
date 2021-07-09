-- 定义一个引用临时表的同义词
CREATE SYNONYM dbo.tb_Common
FOR #
GO

-- 创建一个用户定义函数, 函数中引用同义词
CREATE FUNCTION dbo.f_sum()
RETURNS int
AS
BEGIN
	RETURN((SELECT SUM(col) FROM dbo.tb_Common))
END
GO

-- 创建测试存储过程1
CREATE PROC dbo.p_test1
AS
SELECT col = 1 
INTO #

SELECT test1 = dbo.f_sum()
GO

-- 创建测试存储过程2
CREATE PROC dbo.p_test2
AS
SELECT col = 10
INTO #

EXEC dbo.p_test1
SELECT test2 = dbo.f_sum()
GO

-- 调用存储过程进行测试
SET NOCOUNT ON

CREATE TABLE #(col int)
EXEC dbo.p_test2
DROP TABLE #

SET NOCOUNT OFF
GO

-- 删除演示环境
DROP PROC dbo.p_test1, dbo.p_test2
DROP FUNCTION dbo.f_sum
DROP SYNONYM dbo.tb_Common
