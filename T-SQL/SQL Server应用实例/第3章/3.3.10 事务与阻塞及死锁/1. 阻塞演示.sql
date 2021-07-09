-- 1. 连接A

-- 建立演示环境
USE tempdb

CREATE TABLE dbo.tb(
	id int)
GO

-- 开启事务并插入数据
BEGIN TRAN
	INSERT dbo.tb(
		id)
	VALUES(
		1)
--COMMIT TRAN
GO

-- 2. 连接B
USE tempdb

SELECT * FROM dbo.tb
GO

-- 删除演示环境
DROP TABLE dbo.tb
GO

