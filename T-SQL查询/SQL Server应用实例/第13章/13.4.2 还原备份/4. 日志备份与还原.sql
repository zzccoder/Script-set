-- �����������ݿ�Ͳ��Ա�
CREATE DATABASE db_test
GO
ALTER DATABASE db_test
SET RECOVERY FULL
GO
CREATE TABLE db_test.dbo.tb(
	id int)
INSERT db_test.dbo.tb (id)
VALUES (1)
GO

-- ������ȫ����
BACKUP DATABASE db_test
TO DISK = 'c:\db_test.bak'
WITH FORMAT

-- ���1����������
INSERT db_test.dbo.tb (id)
VALUES (12)
-- ������־����
BACKUP LOG db_test
TO DISK = 'c:\db_test.bak'

-- ���2����������
INSERT db_test.dbo.tb (id)
VALUES (123)
-- ������־����
BACKUP LOG db_test
TO DISK = 'c:\db_test.bak'
GO

-- ��ԭ����
DROP DATABASE db_test
GO

-- 1. ����ֱ�ӻ�ԭ��־
RESTORE LOG db_test
FROM DISK = 'c:\db_test.bak'
WITH FILE = 2
GO

-- 2. ��ԭ��ȫ����
RESTORE DATABASE db_test
FROM DISK = 'c:\db_test.bak'
WITH FILE = 1,
	NORECOVERY
GO

-- 3. ����˳��ԭ��־
RESTORE LOG db_test
FROM DISK = 'c:\db_test.bak'
WITH FILE = 3
GO

-- 4. ֻ��ԭ��1����־
RESTORE LOG db_test
FROM DISK = 'c:\db_test.bak'
WITH FILE = 2
GO
SELECT * FROM db_test.dbo.tb
GO

-- 5. ��ԭ������־
DROP DATABASE db_test
GO
RESTORE DATABASE db_test
FROM DISK = 'c:\db_test.bak'
WITH FILE = 1,
	NORECOVERY,
	REPLACE
RESTORE LOG db_test
FROM DISK = 'c:\db_test.bak'
WITH FILE = 2,
	NORECOVERY
RESTORE LOG db_test
FROM DISK = 'c:\db_test.bak'
WITH FILE = 3
GO
SELECT * FROM db_test.dbo.tb
GO


-- ɾ�����Ի���
DROP DATABASE db_test