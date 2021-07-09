USE master
GO
-- 创建并完全备份测试数据库
CREATE DATABASE db_test
BACKUP DATABASE db_test
TO DISK = 'c:\db_test.bak'
WITH FORMAT
GO

-- 记录序列号的临时表
IF OBJECT_ID(N'tempdb..#lsn') IS NOT NULL
	DROP TABLE #lsn
CREATE TABLE #lsn(
	ID int IDENTITY,
	Flag int,
	CurrentLSN char(22),
	Operation sysname,
	Context sysname,
	TransactionID char(13)
)
-- 开始创建测试表之前记录当前的 lsn， 并标记 last_lsn
INSERT #lsn(
	CurrentLSN, Operation, Context, TransactionID)
EXEC(N'DBCC LOG(N''db_test'')')
UPDATE #lsn SET
	Flag = 1
WHERE IDENTITYCOL = SCOPE_IDENTITY()

-- 创建测试表
CREATE TABLE db_test.dbo.tb(
	id int)

-- 开始创建测试表之后记录当前的 lsn， 并标记 last_lsn
INSERT #lsn(
	CurrentLSN, Operation, Context, TransactionID)
EXEC(N'DBCC LOG(N''db_test'')')
UPDATE #lsn SET
	Flag = 2
WHERE IDENTITYCOL = SCOPE_IDENTITY()

-- 插入测试记录
INSERT db_test.dbo.tb(
	id)
VALUES(1)

-- 备份事务日志，以便可以从日志备份中恢复到指定的日志序列号
BACKUP LOG db_test
TO DISK = 'c:\db_test_log.bak'
WITH FORMAT
GO


-- 还原完全备份
RESTORE DATABASE db_test
FROM DISK = 'c:\db_test.bak'
WITH NORECOVERY,
	REPLACE

-- 通过日志序列号还原数据库到创建测试表之前
-- 得到日志序列号
DECLARE
	@lsn varchar(50),
	@sql nvarchar(1000)
SELECT
	@sql = N'
DECLARE 
	@a binary(4), @b binary(4), @c binary(2)
SELECT
	@a = 0x' + SUBSTRING(CurrentLSN, 1, 8) + N',
	@b = 0x' + SUBSTRING(CurrentLSN, 10, 8) + N',
	@c = 0x' + SUBSTRING(CurrentLSN, 19, 4) + N'
SELECT
	@lsn = ''lsn:'' + 
			LEFT(RTRIM(CONVERT(int, @a)) + ''000000'', 6) + 
			RIGHT(CONVERT(int, @b) + 1000000, 6) + 
			RIGHT(CONVERT(int, @c) + 1000000, 5)
'
FROM #lsn
WHERE Flag = 1
EXEC sp_executesql @sql, N'@lsn varchar(50) OUTPUT', @lsn OUTPUT

-- 还原日志到指定的日志序列号
RESTORE LOG db_test
FROM DISK='c:\db_test_log.bak'
WITH STOPATMARK = @lsn,
	STANDBY = 'C:\db_test_redo.bak'

-- 通过检查该表是否存在，以验证的点是否正确
SELECT OBJECT_ID(N'db_test.dbo.tb')
/* -- 结果:
-----------
NULL

(1 行受影响)
--*/
GO

-- 通过日志序列号还原数据库到创建测试表之前
-- 得到日志序列号
DECLARE
	@lsn varchar(50),
	@sql nvarchar(1000)
SELECT
	@sql = N'
DECLARE 
	@a binary(4), @b binary(4), @c binary(2)
SELECT
	@a = 0x' + SUBSTRING(CurrentLSN, 1, 8) + N',
	@b = 0x' + SUBSTRING(CurrentLSN, 10, 8) + N',
	@c = 0x' + SUBSTRING(CurrentLSN, 19, 4) + N'
SELECT
	@lsn = ''lsn:'' + 
			LEFT(RTRIM(CONVERT(int, @a)) + ''000000'', 6) + 
			RIGHT(CONVERT(int, @b) + 1000000, 6) + 
			RIGHT(CONVERT(int, @c) + 1000000, 5)
'
FROM #lsn
WHERE Flag = 2
EXEC sp_executesql @sql, N'@lsn varchar(50) OUTPUT', @lsn OUTPUT

-- 还原日志到指定的日志序列号
RESTORE LOG db_test
FROM DISK='c:\db_test_log.bak'
WITH STOPATMARK = @lsn,
	STANDBY = 'C:\db_test_redo.bak'

-- 检查测试表是否存在，以验证的点是否正确
SELECT 
	OBJECT_ID(N'db_test.dbo.tb'), COUNT(*)
FROM db_test.dbo.tb
/*-- 结果
----------- -----------
2073058421  0

(1 行受影响)
--*/
GO

-- 删除测试
DROP DATABASE db_test
DROP TABLE #lsn
