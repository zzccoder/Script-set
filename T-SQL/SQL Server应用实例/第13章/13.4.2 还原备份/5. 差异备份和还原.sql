-- �����������ݿ�Ͳ��Ա�
CREATE DATABASE db_test
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
-- �������챸��
BACKUP DATABASE db_test
TO DISK = 'c:\db_test.bak'
WITH DIFFERENTIAL

-- ���2����������
INSERT db_test.dbo.tb (id)
VALUES (123)
-- �������챸��
BACKUP DATABASE db_test
TO DISK = 'c:\db_test.bak'
WITH DIFFERENTIAL
GO

-- ��ԭ����

-- 1. ֻ��ԭ��1�������ļ�
DROP DATABASE db_test
GO
RESTORE DATABASE db_test
FROM DISK = 'c:\db_test.bak'
WITH FILE = 1,
	NORECOVERY
RESTORE DATABASE db_test
FROM DISK = 'c:\db_test.bak'
WITH FILE = 2
GO
SELECT * FROM db_test.dbo.tb
GO

-- 2. ֻ��ԭ��2�������ļ�
DROP DATABASE db_test
GO
RESTORE DATABASE db_test
FROM DISK = 'c:\db_test.bak'
WITH FILE = 1,
	NORECOVERY
RESTORE DATABASE db_test
FROM DISK = 'c:\db_test.bak'
WITH FILE = 3
GO
SELECT * FROM db_test.dbo.tb
GO



-- ɾ�����Ի���
DROP DATABASE db_test