USE master
GO
-- 创建测试数据库
CREATE DATABASE db_test
GO

-- 对数据库进行备份
BACKUP DATABASE db_test
TO DISK = 'c:\db_test.bak'
WITH FORMAT
GO

-- 创建测试表
CREATE TABLE db_test.dbo.tb_test(
	ID int)

-- 延时 2 秒钟,再进行后面的操作(这是由于SQL Server的时间精度最大为百分之三秒,不延时的话,可能会导致还原到时间点的操作失败)
WAITFOR DELAY '00:00:02'
GO

-- 假设我们现在误操作删除了 db_test.dbo.tb_test 这个表
DROP TABLE db_test.dbo.tb_test

--保存删除表的时间
SELECT dt = GETDATE() INTO #
GO

--在删除操作后,发现不应该删除表 db_test.dbo.tb_test

--下面演示了如何恢复这个误删除的表 db_test.dbo.tb_test

--首先,备份事务日志(使用事务日志才能还原到指定的时间点)
BACKUP LOG db_test
TO DISK = 'c:\db_test_log.bak'
WITH FORMAT
GO

-- 接下来,我们要先还原完全备份(还原日志必须在还原完全备份的基础上进行)
RESTORE DATABASE db_test
FROM DISK = 'c:\db_test.bak'
WITH REPLACE, 
	NORECOVERY
GO

--将事务日志还原到删除操作前（这里的时间对应上面的删除时间，并比删除时间略早
DECLARE 
	@dt datetime
SELECT 
	@dt = DATEADD(ms, - 20, dt)
FROM #  --获取比表被删除的时间略早的时间
RESTORE LOG db_test
FROM DISK = 'c:\db_test_log.bak'
WITH RECOVERY,
	STOPAT = @dt
GO

--查询一下,看表是否恢复
SELECT * FROM db_test.dbo.tb_test

/*--结果:
ID          
----------- 

（所影响的行数为 0 行）
--*/

--测试成功
GO

--最后删除我们做的测试环境
DROP DATABASE db_test
DROP TABLE #
