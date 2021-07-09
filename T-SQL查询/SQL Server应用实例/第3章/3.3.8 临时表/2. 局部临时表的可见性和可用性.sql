-- 局部临时表的可见性和可用性
USE tempdb
GO

-- 建立演示环境
CREATE PROC dbo.p_Child
AS
	SET NOCOUNT ON
	IF OBJECT_ID(N'tempdb..#tb') IS NULL
		RAISERROR('#tb not exists', 10, 1) WITH NOWAIT
	ELSE
		SELECT * FROM #tb

	CREATE TABLE #tb(
		Description varchar(20))
	INSERT #tb(
		Description)
	VALUES(
		'#tb in dbo.p_Child')
	SELECT * FROM #tb
GO

CREATE PROC dbo.p_Test1
AS
	SET NOCOUNT ON
	CREATE TABLE #tb(
		Description varchar(20))
	INSERT #tb(
		Description)
	VALUES(
		'#tb in dbo.p_Test1')
	SELECT * FROM #tb
	
	EXEC dbo.p_Child

	SELECT * FROM #tb
GO

CREATE PROC dbo.p_Test2
AS
	SET NOCOUNT ON
	CREATE TABLE #tb(
		Description varchar(20))
	INSERT #tb(
		Description)
	VALUES(
		'#tb in dbo.p_Test2')
	SELECT * FROM #tb
GO

-- 演示1. 子过程
PRINT '-- 演示1. 子过程'
EXEC dbo.p_Test1
GO

-- 演示2. 并行过程
PRINT '-- 演示2. 并行过程'
EXEC dbo.p_Test2
EXEC dbo.p_Child
GO

-- 演示3, 当前连接中, 批处理外的临时表
PRINT '-- 演示3, 当前连接中, 批处理外的临时表'
CREATE TABLE #tb(
	Description varchar(20))
INSERT #tb(
	Description)
VALUES(
	'#tb in current link')
EXEC dbo.p_Child
DROP TABLE #tb
GO

-- 删除演示环境
DROP PROC dbo.p_Child, dbo.p_Test1, dbo.p_Test2