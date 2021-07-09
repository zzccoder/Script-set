-- 当设置数据库兼容级别为 65 时
EXEC sp_dbcmptlevel N'AdventureWorks', 65
GO

USE AdventureWorks
-- BACKUP 语句出错
BACKUP DATABASE master 
TO DISK = 'c:\master.bak'
WITH FORMAT
/*--产生错误信息
消息 325，级别 15，状态 1，第 4 行
'BACKUP' 附近有语法错误。您可能需要将当前数据库的兼容级别设置为更高的值，以启用此功能。有关存储过程 sp_dbcmptlevel 的信息，请参见帮助。
--*/
GO

-- 恢复数据库兼容级别
EXEC sp_dbcmptlevel N'AdventureWorks', 90
