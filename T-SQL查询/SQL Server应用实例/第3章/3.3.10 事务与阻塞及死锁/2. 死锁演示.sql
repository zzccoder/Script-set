-- 死锁演示

-- 1. 连接A
-- 建立测试环境
USE tempdb
GO

CREATE TABLE dbo.tb(
	id int)
INSERT dbo.tb(
	id)
VALUES(
	1)
GO

-- 数据处理
SET DEADLOCK_PRIORITY LOW -- NORMAL
BEGIN TRAN
	SELECT * FROM dbo.tb WITH(HOLDLOCK)
	WAITFOR DELAY '00:00:05'
	UPDATE dbo.tb SET id = 2
COMMIT TRAN
GO


-- 连接B
USE tempdb
GO

BEGIN TRAN
	SELECT * FROM dbo.tb WITH(HOLDLOCK)

	UPDATE dbo.tb SET id = 2
COMMIT TRAN
GO

-- 删除演示环境
DROP TABLE dbo.tb
GO
