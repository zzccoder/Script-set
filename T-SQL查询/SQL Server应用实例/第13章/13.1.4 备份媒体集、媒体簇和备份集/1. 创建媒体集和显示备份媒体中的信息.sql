-- 创建媒体集和第1个备份集
BACKUP DATABASE msdb
TO 
	DISK = 'c:\msdb_1.bak',
	DISK = 'c:\msdb_2.bak'
WITH FORMAT
GO

-- 创建第2个备份集
BACKUP DATABASE msdb
TO 
	DISK = 'c:\msdb_1.bak',
	DISK = 'c:\msdb_2.bak'
GO

-- 显示媒体集信息
RESTORE LABELONLY
FROM DISK = 'c:\msdb_2.bak'

-- 显示备份集信息
RESTORE HEADERONLY
FROM DISK = 'c:\msdb_2.bak'

-- 显示数据文件信息
RESTORE FILELISTONLY
FROM DISK = 'c:\msdb_2.bak'
WITH FILE = 2

