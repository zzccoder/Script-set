-- 创建测试数据库
CREATE DATABASE db_test
GO

-- 使用磁盘媒体集备份测试数据库,备份完成后删除测试数据库
-- 下面的备份操作将在 c:\db_test_a.bak和c:\db_test_a.bak上创建一个媒体集
BACKUP DATABASE db_test 
TO 
	DISK = 'c:\db_test_a.bak',
	DISK = 'c:\db_test_b.bak'
WITH FORMAT
DROP DATABASE db_test
GO

-- 错误引用媒体集的演示
-- 1. 还原时仅指定媒体集中的一个备份媒体
RESTORE DATABASE db_test 
FROM DISK = 'c:\db_test_a.bak'
/*-- 还原操作将收到类似下面的错误信息
消息 3132，级别 16，状态 1，第 1 行
媒体集有 2 个媒体簇，但只提供了 1 个。必须提供所有成员。
--*/

-- 2. 尝试单独引用媒体集中的某个备份媒体进行备份
BACKUP DATABASE master
TO DISK = 'c:\db_test_a.bak'
/*--将收到错误信息
消息 3132，级别 16，状态 1，第 1 行
媒体集有 2 个媒体簇，但只提供了 1 个。必须提供所有成员。
--*/

-- 3. 尝试同时引用媒体集及非媒体集中的备份媒体备份
BACKUP DATABASE master 
TO 
	DISK = 'c:\db_test_a.bak',
	DISK = 'c:\db_test_b.bak',
	DISK = 'c:\db_test_c.bak'
/*--将收到错误信息
消息 3231，级别 16，状态 1，第 1 行
在 "c:\db_test_a.bak" 上加载的媒体已格式化为支持 2 个媒体簇，但根据指定的备份设备，应支持 3 个媒体簇。
--*/

-- 4. 重新初始化媒体集时示指定媒体集中的所有备份媒体
BACKUP DATABASE master 
TO DISK = 'c:\db_test_a.bak'
WITH INIT
/*--将收到错误信息
消息 3132，级别 16，状态 1，第 1 行
媒体集有 2 个媒体簇，但只提供了 1 个。必须提供所有成员。
--*/


-- 正确引用媒体集的演示
-- 1. 指定完整的媒体集可以正常恢复数据库
RESTORE DATABASE db_test 
FROM
	DISK = 'c:\db_test_a.bak',
	DISK = 'c:\db_test_b.bak'
/*-- 成功还原并收到类似下面的信息
已为数据库 'db_test'，文件 'db_test' (位于文件 1 上)处理了 176 页。
已为数据库 'db_test'，文件 'db_test_log' (位于文件 1 上)处理了 1 页。
RESTORE DATABASE 成功处理了 177 页，花费 0.716 秒(2.025 MB/秒)。
--*/

-- 1. 使用 FORMAT 重写媒体头可以重建媒体集
BACKUP DATABASE master
TO DISK = 'c:\db_test_a.bak'
WITH FORMAT
/*-- 成功备份，并且收到类似下面的信息
已为数据库 'master'，文件 'master' (位于文件 1 上)处理了 376 页。
已为数据库 'master'，文件 'mastlog' (位于文件 1 上)处理了 2 页。
BACKUP DATABASE 成功处理了 378 页，花费 1.223 秒(2.531 MB/秒)。
--*/
GO

-- 删除测试数据库
IF DB_ID(N'db_test') IS NOT NULL
	DROP DATABASE db_test