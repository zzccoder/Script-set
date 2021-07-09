USE master
GO
--创建测试数据库
CREATE DATABASE db_test
ON(
	NAME = db_test_DATA,
	FILENAME = 'c:\db_test.mdf'),
FILEGROUP FG_1(
	NAME = db_test_DATA_1,
	FILENAME = 'c:\db_test_1.ndf')
LOG ON(
	NAME = db_test_LOG,
	FILENAME = 'c:\db_test.ldf')
GO

-- 数据库备份
BACKUP DATABASE db_test
TO DISK = 'c:\db_test.bak'
WITH FORMAT
GO

-- 备份之后建立测试表
CREATE TABLE db_test.dbo.tb_PRIMARY(
	id int
) ON [PRIMARY]

CREATE TABLE db_test.dbo.tb_FG_1(
	id int
) ON FG_1
GO


-- 停止 SQL Server 实例，破坏所有的数据文件
SHUTDOWN

/*-- 下述操作操作系统中进行
1. 删除文件 c:\db_test.mdf和c:\db_test_1.ndf (模拟破坏)
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
FROM DISK = 'c:\db_test.bak'
WITH NORECOVERY

-- 还原数据库尾日志
RESTORE LOG db_test 
FROM DISK = 'c:\db_test_log.bak' 
WITH RECOVERY
GO

-- 查询数据库备份之后建立的各个表是否存在，以验证恢复的正确性
SELECT * FROM db_test.dbo.tb_PRIMARY
SELECT * FROM db_test.dbo.tb_FG_1
/*-- 结果如下，因为所有的表都存在，所以抢救数据成功
id
-----------

(0 行受影响)

id
-----------

(0 行受影响)
--*/
GO

-- 删除测试环境
DROP DATABASE db_test