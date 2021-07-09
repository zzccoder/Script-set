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
-- 将默认文件组设置为 读写文件组
ALTER DATABASE db_test
MODIFY FILEGROUP FG_READ_WRITE DEFAULT
GO

-- 在默认（读写）文件组上创建对象
CREATE TABLE db_test.dbo.tb_RW(
	id int
)
-- 在只读文件组上创建对象
CREATE TABLE db_test.dbo.tb_R(
	id int
)ON FG_READ_ONLY
GO

-- 设置只读文件组
ALTER DATABASE db_test
MODIFY FILEGROUP FG_READ_ONLY READ_ONLY
GO

-- 部分备份
BACKUP DATABASE db_test
	READ_WRITE_FILEGROUPS
TO DISK = 'c:\db_test.bak'
WITH FORMAT
-- 文件组备份
BACKUP DATABASE db_test
	FILEGROUP = 'FG_READ_ONLY'
TO DISK = 'c:\db_test.bak'
GO

-- 1. 测试在现有数据库基础上还原部分备份
-- 删除可读写文件组上的表
DROP TABLE db_test.dbo.tb_RW
GO
-- 在现有数据库基础上还原部分备份
RESTORE DATABASE db_test
FROM DISK = 'c:\db_test.bak'
WITH REPLACE
GO

-- 查询表是否恢复，及只读文件组上表是否还在
SELECT * FROM db_test.dbo.tb_RW
SELECT * FROM db_test.dbo.tb_R
GO


-- 2. 测试在空白数据库上还原部分备份
DROP DATABASE db_test
GO
-- 在现有数据库基础上还原部分备份
RESTORE DATABASE db_test
FROM DISK = 'c:\db_test.bak'
WITH REPLACE
GO

-- 查询表是否恢复，及只读文件组上表是否还在
SELECT * FROM db_test.dbo.tb_RW
SELECT * FROM db_test.dbo.tb_R
GO

-- 查询各文件的状态
SELECT * FROM db_test.sys.database_files
GO


-- 3. 文件组还原
RESTORE DATABASE db_test
	FILEGROUP = 'FG_READ_ONLY'
FROM DISK = 'c:\db_test.bak'
WITH FILE = 2
GO
-- 查询表是否恢复，及只读文件组上表是否还在
SELECT * FROM db_test.dbo.tb_RW
SELECT * FROM db_test.dbo.tb_R
GO


-- 删除测试数据库
DROP DATABASE db_test
