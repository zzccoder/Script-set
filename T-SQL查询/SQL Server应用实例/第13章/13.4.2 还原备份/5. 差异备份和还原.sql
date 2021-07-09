-- 创建测试数据库和测试表
CREATE DATABASE db_test
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
-- 创建差异备份
BACKUP DATABASE db_test
TO DISK = 'c:\db_test.bak'
WITH DIFFERENTIAL

-- 插第2条测试数据
INSERT db_test.dbo.tb (id)
VALUES (123)
-- 创建差异备份
BACKUP DATABASE db_test
TO DISK = 'c:\db_test.bak'
WITH DIFFERENTIAL
GO

-- 还原测试

-- 1. 只还原第1个差异文件
DROP DATABASE db_test
GO
RESTORE DATABASE db_test
FROM DISK = 'c:\db_test.bak'
WITH FILE = 1,
	NORECOVERY
RESTORE DATABASE db_test
FROM DISK = 'c:\db_test.bak'
WITH FILE = 2
GO
SELECT * FROM db_test.dbo.tb
GO

-- 2. 只还原第2个差异文件
DROP DATABASE db_test
GO
RESTORE DATABASE db_test
FROM DISK = 'c:\db_test.bak'
WITH FILE = 1,
	NORECOVERY
RESTORE DATABASE db_test
FROM DISK = 'c:\db_test.bak'
WITH FILE = 3
GO
SELECT * FROM db_test.dbo.tb
GO



-- 删除测试环境
DROP DATABASE db_test