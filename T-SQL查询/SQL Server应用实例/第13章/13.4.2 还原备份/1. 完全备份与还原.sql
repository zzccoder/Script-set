USE master
GO

-- ��ȫ����
BACKUP DATABASE AdventureWorks
TO DISK = 'c:\AdventureWorks.bak'
WITH FORMAT
GO

-- ��ȫ��ԭ
RESTORE DATABASE AdventureWorks
FROM DISK = 'c:\AdventureWorks.bak'
WITH REPLACE
