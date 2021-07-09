-- 创建一个包含主文件组、2个用户定义文件组的测试数据库
CREATE DATABASE db_test
ON(
	NAME = db_test_DATA,
	FILENAME = 'c:\db_test.mdf'
),
FILEGROUP FG(
	NAME = db_test_1,
	FILENAME = 'c:\db_test_1.ndf'
),
(
	NAME = db_test_2,
	FILENAME = 'c:\db_test_2.ndf'
)
GO

-- 文件和文件组备份
BACKUP DATABASE db_test
	FILEGROUP = N'PRIMARY',
	FILEGROUP = N'FG'
TO DISK = 'c:\db_test.bak'
WITH FORMAT

BACKUP DATABASE db_test
	FILE = N'db_test_2'
TO DISK = 'c:\db_test.bak'
GO

-- 还原测试
-- 1. 在现有数据库上只还原单个文件
RESTORE DATABASE db_test
		FILE = N'db_test_2'
FROM DISK = 'c:\db_test.bak'
WITH FILE = 2,
	NORECOVERY

-- 备份和应用当前日志
BACKUP LOG db_test
TO DISK = 'c:\db_test.bak'
WITH NORECOVERY

RESTORE LOG db_test
FROM DISK = 'c:\db_test.bak'
WITH FILE = 3
GO

-- 2.a 还原文件时创建数据库
DROP DATABASE db_test
GO
RESTORE DATABASE db_test
	FILE = N'db_test_2'
FROM DISK = 'c:\db_test.bak'
WITH FILE = 2
GO

-- 2.b 还原文件时组时创建数据库
DROP DATABASE db_test
GO
RESTORE DATABASE db_test
	FILEGROUP = N'FG'
FROM DISK = 'c:\db_test.bak'
WITH FILE = 1
GO

-- 3. 还原主文件组时创建数据库，同时还原用户定义文件组
RESTORE DATABASE db_test
	FILEGROUP = N'PRIMARY',
	FILEGROUP = N'FG'
FROM DISK = 'c:\db_test.bak'
WITH FILE = 1
GO

-- 删除测试环境
DROP DATABASE db_test