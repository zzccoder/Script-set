USE master
GO
-- 创建并完全备份测试数据库
CREATE DATABASE db_test
BACKUP DATABASE db_test
TO DISK = 'c:\db_test.bak'
WITH FORMAT
GO

-- 标记事务处理
BEGIN TRANSACTION Tran1 WITH MARK

CREATE TABLE db_test.dbo.tb(
	id int)

COMMIT TRAN Tran1

-- 事务完成后插入数据
INSERT db_test.dbo.tb(
	id)
SELECT 
	object_id 
FROM sys.objects
GO

-- 备份事务日志
BACKUP LOG db_test
TO DISK = 'c:\db_test_log.bak'
WITH FORMAT
GO

-- 还原数据到事务标记 Tran1 前
-- 还原完全备份
RESTORE DATABASE db_test
FROM DISK = 'c:\db_test.bak'
WITH NORECOVERY,
	REPLACE

-- 还原日志
RESTORE LOG db_test
FROM DISK='c:\db_test_log.bak'
WITH STOPBEFOREMARK = 'Tran1',
	STANDBY = 'C:\db_test_redo.bak'

-- 事务标记 Tran1 前没有创建表，检查该表是否存在，以验证的点是否正确
SELECT OBJECT_ID(N'db_test.dbo.tb')
/* -- 结果:
-----------
NULL

(1 行受影响)
--*/
GO

-- 还原数据库到事务标记 Tran1 后
RESTORE LOG db_test
FROM DISK = 'c:\db_test_log.bak'
WITH STOPATMARK = 'Tran1'

-- 检查测试表是否存在，以验证的点是否正确
SELECT 
	OBJECT_ID(N'db_test.dbo.tb'), COUNT(*)
FROM db_test.dbo.tb
/*-- 结果
----------- -----------
2073058421  0
--*/
GO

-- 删除测试
DROP DATABASE db_test
