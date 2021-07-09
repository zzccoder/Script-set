USE master
GO
--创建测试数据库
CREATE DATABASE db_test
ON(
	NAME = db_test_DATA,
	FILENAME = 'c:\db_test.mdf'),
FILEGROUP FG_1(
	NAME = db_test_DATA_1,
	FILENAME = 'c:\db_test_1.ndf'),
FILEGROUP FG_2(
	NAME = db_test_DATA_2,
	FILENAME = 'c:\db_test_2.ndf')
LOG ON(
	NAME = db_test_LOG,
	FILENAME = 'c:\db_test.ldf')
GO

-- 在各个文件组上创建测试表
CREATE TABLE db_test.dbo.tb_PRIMARY(
	id int
) ON [PRIMARY]

CREATE TABLE db_test.dbo.tb_FG_1(
	id int
) ON FG_1

CREATE TABLE db_test.dbo.tb_FG_2(
	id int
) ON FG_2
GO

-- 文件组备份
BACKUP DATABASE db_test
	FILEGROUP = N'FG_1'
TO DISK = 'c:\db_test_FG_1.bak'
WITH FORMAT

-- 备份之后，在文件组 FG_1 上的表 tb_FG_1 中插入测试数据
INSERT db_test.dbo.tb_FG_1(
	id)
VALUES(
	1)
GO

-- 停止 SQL Server 实例，破坏文件组 FG_1
SHUTDOWN

/*-- 下述操作操作系统中进行
1. 删除文件 c:\db_test_1.ndf (模拟破坏)
2. 重新SQL Server服务,此时数据库DB置疑
--*/
GO

--下面演示了如何恢复数据
-- 首先要备份当前日志
BACKUP LOG db_test 
TO DISK = 'c:\db_test_log.bak' 
WITH FORMAT,
	NO_TRUNCATE

-- 利用文件组备份恢复破坏的文件
RESTORE DATABASE db_test
	FILEGROUP = N'FG_1'
FROM DISK = 'c:\db_test_FG_1.bak'
WITH NORECOVERY

-- 还原数据库尾日志
RESTORE LOG db_test 
FROM DISK = 'c:\db_test_log.bak' 
WITH RECOVERY
GO

-- 查询文件组 FG_1 上的表 tb_FG_1，验证数据是否丢失
SELECT * FROM db_test.dbo.tb_FG_1
/*-- 结果如下，存在数据，表示数据抢救成功
id
-----------
1

(1 行受影响)
--*/
GO

-- 删除测试环境
DROP DATABASE db_test