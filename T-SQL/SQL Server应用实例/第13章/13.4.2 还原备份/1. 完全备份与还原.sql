USE master
GO

-- 完全备份
BACKUP DATABASE AdventureWorks
TO DISK = 'c:\AdventureWorks.bak'
WITH FORMAT
GO

-- 完全还原
RESTORE DATABASE AdventureWorks
FROM DISK = 'c:\AdventureWorks.bak'
WITH REPLACE
