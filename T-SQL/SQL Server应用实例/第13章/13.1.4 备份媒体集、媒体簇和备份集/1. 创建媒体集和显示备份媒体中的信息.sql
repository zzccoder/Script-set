-- ����ý�弯�͵�1�����ݼ�
BACKUP DATABASE msdb
TO 
	DISK = 'c:\msdb_1.bak',
	DISK = 'c:\msdb_2.bak'
WITH FORMAT
GO

-- ������2�����ݼ�
BACKUP DATABASE msdb
TO 
	DISK = 'c:\msdb_1.bak',
	DISK = 'c:\msdb_2.bak'
GO

-- ��ʾý�弯��Ϣ
RESTORE LABELONLY
FROM DISK = 'c:\msdb_2.bak'

-- ��ʾ���ݼ���Ϣ
RESTORE HEADERONLY
FROM DISK = 'c:\msdb_2.bak'

-- ��ʾ�����ļ���Ϣ
RESTORE FILELISTONLY
FROM DISK = 'c:\msdb_2.bak'
WITH FILE = 2

