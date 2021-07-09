-- �����������ݿ�
CREATE DATABASE db_test
GO

-- �������ݿ�
BACKUP DATABASE db_test
TO DISK = 'c:\db_test.bak'
WITH FORMAT

-- ��������־����
BACKUP LOG db_test
TO DISK = 'c:\db_test_log.bak'
WITH FORMAT,
	COPY_ONLY

-- ��־����
BACKUP LOG db_test
TO DISK = 'c:\db_test_log.bak'
GO

-- ��ԭ���ݿ����
RESTORE DATABASE db_test
FROM DISK = 'c:\db_test.bak'
WITH REPLACE,
	NORECOVERY

RESTORE LOG db_test
FROM DISK = 'c:\db_test_log.bak'
WITH FILE = 2
GO

-- ɾ������
DROP DATABASE db_test