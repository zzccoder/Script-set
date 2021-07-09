-- 创建测试数据库和测试表
CREATE DATABASE db_test
GO
ALTER DATABASE db_test
SET RECOVERY FULL
GO
CREATE TABLE db_test.dbo.tb(
	id int)
INSERT db_test.dbo.tb (id)
VALUES (1)
GO

-- 创建完全备份
BACKUP DATABASE db_test
TO DISK = 'c:\db_test.bak'
WITH FORMAT

-- 插第1条测试数据
INSERT db_test.dbo.tb (id)
VALUES (12)
-- 创建日志备份
BACKUP LOG db_test
TO DISK = 'c:\db_test.bak'

-- 插第2条测试数据
INSERT db_test.dbo.tb (id)
VALUES (123)
-- 创建日志备份
BACKUP LOG db_test
TO DISK = 'c:\db_test.bak'
GO

-- 还原测试
DROP DATABASE db_test
GO

-- 1. 尝试直接还原日志
RESTORE LOG db_test
FROM DISK = 'c:\db_test.bak'
WITH FILE = 2
GO

-- 2. 还原完全备份
RESTORE DATABASE db_test
FROM DISK = 'c:\db_test.bak'
WITH FILE = 1,
	NORECOVERY
GO

-- 3. 不按顺序还原日志
RESTORE LOG db_test
FROM DISK = 'c:\db_test.bak'
WITH FILE = 3
GO

-- 4. 只还原第1个日志
RESTORE LOG db_test
FROM DISK = 'c:\db_test.bak'
WITH FILE = 2
GO
SELECT * FROM db_test.dbo.tb
GO

-- 5. 还原所有日志
DROP DATABASE db_test
GO
RESTORE DATABASE db_test
FROM DISK = 'c:\db_test.bak'
WITH FILE = 1,
	NORECOVERY,
	REPLACE
RESTORE LOG db_test
FROM DISK = 'c:\db_test.bak'
WITH FILE = 2,
	NORECOVERY
RESTORE LOG db_test
FROM DISK = 'c:\db_test.bak'
WITH FILE = 3
GO
SELECT * FROM db_test.dbo.tb
GO


-- 删除测试环境
DROP DATABASE db_test