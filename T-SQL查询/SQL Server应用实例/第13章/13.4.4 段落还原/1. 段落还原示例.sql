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

-- 完全备份并删除测试数据库
BACKUP DATABASE db_test
TO DISK = 'c:\db_test.bak'
WITH FORMAT

DROP DATABASE db_test
GO


-- 段落还原测试
-- 开始段落还原
RESTORE DATABASE db_test
	FILEGROUP = N'PRIMARY'
FROM DISK = 'c:\db_test.bak'
WITH REPLACE,
	PARTIAL
GO

-- 查询可读写和只读文件组上的测试表是否已经恢复
SELECT * FROM db_test.dbo.tb_RW
SELECT * FROM db_test.dbo.tb_R
/*-- 测试结果
消息 8653，级别 16，状态 1，第 1 行
查询处理器无法为表或视图 'tb_RW' 生成计划，因为该表驻留在不处于联机状态的文件组中。
--*/
GO

-- 继续还原可读写文件组
RESTORE DATABASE db_test
	FILEGROUP = N'FG_READ_WRITE'
FROM DISK = 'c:\db_test.bak'
GO

-- 查询可读写和只读文件组上的测试表是否已经恢复
SELECT * FROM db_test.dbo.tb_RW
SELECT * FROM db_test.dbo.tb_R
/*-- 测试结果
消息 8653，级别 16，状态 1，第 3 行
查询处理器无法为表或视图 'tb_R' 生成计划，因为该表驻留在不处于联机状态的文件组中。
--*/
GO

-- 继续还原只读写文件组
RESTORE DATABASE db_test
	FILEGROUP = N'FG_READ_ONLY'
FROM DISK = 'c:\db_test.bak'
GO

-- 查询可读写和只读文件组上的测试表是否已经恢复
SELECT * FROM db_test.dbo.tb_RW
SELECT * FROM db_test.dbo.tb_R
/*-- 测试结果
id
-----------

(0 行受影响)

id
-----------

(0 行受影响)
--*/
GO

-- 删除测试数据库
DROP DATABASE db_test
