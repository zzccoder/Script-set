USE master
GO
-- 创建一个包含主文件组、读写文件组、只读文件组的测试数据库
CREATE DATABASE db_test
ON(
	NAME = db_test_DATA,
	FILENAME = 'c:\db_test.mdf'
),
FILEGROUP FG_READ_WRITE(
	NAME = db_test_RW,
	FILENAME = 'c:\db_test_RW.ndf'
),
FILEGROUP FG_READ_ONLY(
	NAME = db_test_R,
	FILENAME = 'c:\db_test_R.ndf'
)
LOG ON(
	NAME = db_test_LOG,
	FILENAME = 'c:\db_test.ldf'
)
GO

-- 设置只读文件组
ALTER DATABASE db_test
MODIFY FILEGROUP FG_READ_ONLY READ_ONLY
GO

-- 文件和文件组备份
BACKUP DATABASE db_test
	FILEGROUP = 'PRIMARY',
	FILE = 'db_test_R'
TO DISK = 'c:\db_test.bak'
WITH FORMAT
GO

-- 删除测试数据库
DROP DATABASE db_test

