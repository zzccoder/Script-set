-- 创建一个测试数据库
CREATE DATABASE db_test
ON(
	NAME = db_test_DATA,
	FILENAME = 'c:\db_test.mdf')
LOG ON(
	NAME = db_test_log,
	FILENAME = 'c:\db_test.ldf')
GO

-- 备份并删除测试数据库
BACKUP DATABASE db_test
TO DISK = 'c:\db_test.bak'
WITH FORMAT

DROP DATABASE db_test
GO

--创建一个文件结构相同,但物理文件位置不同的数据库
CREATE DATABASE db_test
ON(
	NAME = db_test_DATA,
	FILENAME = 'd:\db_test.mdf')
LOG ON(
	NAME = db_test_log,
	FILENAME = 'd:\db_test.ldf')
GO

--在新建的数据库上强制还原备份
RESTORE DATABASE db_test
FROM DISK = 'c:\db_test.bak'
WITH REPLACE

--查看还原后的文件位置
SELECT 
	name, physical_name
FROM db_test.sys.database_files
/* -- 查询结果如下：(还原后文件被移动到新建数据库时指定的对应文件)
name                 physical_name
-------------------- ----------------
db_test_DATA         d:\db_test.mdf
db_test_log          d:\db_test.ldf

(2 行受影响)
--*/
GO

--删除测试
DROP DATABASE db_test
