-- 创建测试数据库
CREATE DATABASE db_test
GO

-- 创建多个备份，为还原操作做准备
BACKUP DATABASE db_test
TO DISK = 'c:\1_db.bak'
WITH FORMAT

BACKUP LOG db_test
TO DISK = 'c:\2_log.bak'
WITH FORMAT

BACKUP LOG db_test
TO DISK = 'c:\3_log.bak'
WITH FORMAT

BACKUP DATABASE db_test
TO DISK = 'c:\4_db.bak'
WITH FORMAT

BACKUP DATABASE db_test TO
DISK = 'c:\5_diff.bak'
WITH FORMAT,
	DIFFERENTIAL

BACKUP LOG db_test
TO DISK = 'c:\6_log.bak'
WITH FORMAT
GO

--下面是用于日志备份和差异备份还原中易犯的错误
-- 1. 恢复时使用错误的日志顺序
RESTORE DATABASE db_test
FROM DISK = 'c:\1_db.bak'
WITH NORECOVERY,
	REPLACE

RESTORE LOG db_test
FROM DISK = 'c:\3_log.bak'
/*-- 还原日志备份时，将收到类似下面的错误信息
消息 4305，级别 16，状态 1，第 6 行
此备份集中的日志开始于 LSN 37000000008000001，该 LSN 太晚，无法应用到数据库。可以还原包含 LSN 37000000007400001 的较早的日志备份。
-- */
GO

-- 2. 恢复时, 将日志备份应用于错误的完全备份
RESTORE DATABASE db_test
FROM DISK = 'c:\4_db.bak'
WITH NORECOVERY,
	REPLACE

RESTORE LOG db_test
FROM DISK = 'c:\2_log.bak'
/*-- 还原日志备份时，将收到类似下面的错误信息
消息 4326，级别 16，状态 1，第 8 行
此备份集中的日志终止于 LSN 37000000008000001，该 LSN 太早，无法应用到数据库。可以还原包含 LSN 37000000009800001 的较新的日志备份。
-- */
GO

-- 3. 将日志备份用于 RESTORE DATABASE
IF DB_ID('db_test') IS NOT NULL
	DROP DATABASE db_test

RESTORE DATABASE db_test
FROM DISK = 'c:\2_log.bak'
WITH NORECOVERY,
	REPLACE
/*-- 还原将收到类似下面的错误信息
消息 3118，级别 16，状态 1，第 4 行
数据库 "db_test" 不存在。RESTORE 只能在还原主文件的完整备份或文件备份时创建数据库。
-- */
GO

-- 4. 将差异备份用于错误的完全备份中
RESTORE DATABASE db_test
FROM DISK = 'c:\1_db.bak'
WITH NORECOVERY,
	REPLACE

RESTORE DATABASE db_test
FROM DISK = 'c:\5_diff.bak'
/*-- 还原差异备份时，将收到类似下面的错误信息
消息 3136，级别 16，状态 1，第 6 行
无法还原此差异备份，因为该数据库尚未还原到正确的早期状态。
--*/
GO

-- 5. 还原完全备份时,未使用NORECOVERY,导致不能正确还原日志备份或者差异备份
RESTORE DATABASE db_test
FROM DISK = 'c:\1_db.bak'
WITH REPLACE

RESTORE LOG db_test
FROM DISK='c:\2_log.bak'
/*--收到错误信息
消息 3117，级别 16，状态 1，第 5 行
无法还原日志备份或差异备份，因为没有文件可用于前滚。
--*/
GO

--删除测试
IF DB_ID('db_test') IS NOT NULL
	DROP DATABASE db_test
