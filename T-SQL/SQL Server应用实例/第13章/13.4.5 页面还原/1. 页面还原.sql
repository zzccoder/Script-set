-- 创建测试数据库，并设置数据库的页校验为 CHECKSUM 模式
CREATE DATABASE db_test
ON(
	NAME = db_test,
	FILENAME = N'c:\db_test.mdf')

ALTER DATABASE db_test
SET PAGE_VERIFY CHECKSUM
GO

-- 创建测试表
-- 测试数据使用了 0－9的数字，每条记录占用一个数据页，这个页中都是相同的数字
-- 这样做的目的是为了后面的人为破坏能够找到破坏的点
SELECT TOP 500
	col = REPLICATE((ROW_NUMBER() OVER(ORDER BY C.object_id)) % 10, 8000)
INTO db_test.dbo.tb
FROM sys.columns C, sys.objects
GO

-- 对数据库做完全备份
BACKUP DATABASE db_test
TO DISK = N'c:\db_test.bak'
WITH FORMAT
GO

-- 关闭 SQL Server， 并使用十六进制工具修改数据文件(找到非常长的一段数据都是单个数字重复的，改掉几十个）
SHUTDOWN
GO

-- 重新启动  SQL Server， 并检查数据页是否有问题
DBCC CHECKDB(N'db_test')
/*-- 如果前面直接修改数据库文件的操作得当，会导致数据页损坏，并收到类似下面的信息
tb的 DBCC 结果。
消息 8928，级别 16，状态 1，第 1 行
对象 ID 2073058421，索引 ID 0，分区 ID 72057594038321152，分配单元 ID 72057594043301888 (类型为 In-row data): 无法处理页 (1:176)。有关详细信息，请参阅其他错误消息。
消息 8939，级别 16，状态 98，第 1 行
表错误: 对象 ID 2073058421，索引 ID 0，分区 ID 72057594038321152，分配单元 ID 72057594043301888 (类型为 In-row data)，页 (1:176)。测试(IS_OFF (BUF_IOERR, pBUF->bstat))失败。值为 12716041 和 -4。
--*/

-- 此时检查 msdb.dbo.suspect_pages 表，可以看到错误页的记录信息
SELECT * FROM msdb.dbo.suspect_pages WITH(NOLOCK)
GO

-- 根据 DBCC 提示的错误页信息，还原错误页
RESTORE DATABASE db_test
	PAGE = '1:234'    -- PAGE 参数的值根据 DBCC CHECKDB 中提示的错误页调整
                      --可以指定多个PAGE，以同时还原多个页
FROM DISK = N'c:\db_test.bak'

/*-- 数据库还原成功，但提示还要应用尾日志
前滚开始点现在位于日志序列号(LSN) 52000000039300001 处。需要继续前滚到 LSN 52000000048300001 之前才能完成还原顺序。
--*/
GO

-- 验证错误页是否修复(由于未应用数据库尾日志，错误依旧）
DBCC CHECKDB(N'db_test')
G0

-- 下面将应用数据库尾日志
-- 处理之前建立一个测试表，以检查应用尾日志是否会丢失当前的数据
CREATE TABLE db_test.dbo.tb_check(
	id int)

-- 备份数据库尾日志，并通过 NORECOVERY 选项使数据库处于可还原备份的状态
BACKUP LOG db_test
TO DISK = N'c:\db_test_log.bak'
WITH NORECOVERY,
	FORMAT

-- 还原数据库尾日志，并使数据库可用
RESTORE LOG db_test
FROM DISK = N'c:\db_test_log.bak'
WITH RECOVERY
GO

-- 检查备份尾日志前建立的测试表，如果该表存在，说明应用尾日志不会丢失数据
SELECT * FROM db_test.dbo.tb_check
GO

-- 再次 DBCC CHECKDB， 确认数据页错误已经修复
DBCC CHECKDB(N'db_test')
GO


-- 删除测试数据库
DROP DATABASE db_test
