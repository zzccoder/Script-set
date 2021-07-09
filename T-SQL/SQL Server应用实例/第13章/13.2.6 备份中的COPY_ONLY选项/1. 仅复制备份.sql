-- 创建测试数据库
CREATE DATABASE db_test
GO

-- 备份数据库
BACKUP DATABASE db_test
TO DISK = 'c:\db_test.bak'
WITH FORMAT

-- 仅复制日志备份
BACKUP LOG db_test
TO DISK = 'c:\db_test_log.bak'
WITH FORMAT,
	COPY_ONLY

-- 日志备份
BACKUP LOG db_test
TO DISK = 'c:\db_test_log.bak'
GO

-- 还原数据库测试
RESTORE DATABASE db_test
FROM DISK = 'c:\db_test.bak'
WITH REPLACE,
	NORECOVERY

RESTORE LOG db_test
FROM DISK = 'c:\db_test_log.bak'
WITH FILE = 2
GO

-- 删除测试
DROP DATABASE db_test