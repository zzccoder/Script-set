-- ����һ���������ļ��顢2���û������ļ���Ĳ������ݿ�
CREATE DATABASE db_test
ON(
	NAME = db_test_DATA,
	FILENAME = 'c:\db_test.mdf'
),
FILEGROUP FG(
	NAME = db_test_1,
	FILENAME = 'c:\db_test_1.ndf'
),
(
	NAME = db_test_2,
	FILENAME = 'c:\db_test_2.ndf'
)
GO

-- �ļ����ļ��鱸��
BACKUP DATABASE db_test
	FILEGROUP = N'PRIMARY',
	FILEGROUP = N'FG'
TO DISK = 'c:\db_test.bak'
WITH FORMAT

BACKUP DATABASE db_test
	FILE = N'db_test_2'
TO DISK = 'c:\db_test.bak'
GO

-- ��ԭ����
-- 1. ���������ݿ���ֻ��ԭ�����ļ�
RESTORE DATABASE db_test
		FILE = N'db_test_2'
FROM DISK = 'c:\db_test.bak'
WITH FILE = 2,
	NORECOVERY

-- ���ݺ�Ӧ�õ�ǰ��־
BACKUP LOG db_test
TO DISK = 'c:\db_test.bak'
WITH NORECOVERY

RESTORE LOG db_test
FROM DISK = 'c:\db_test.bak'
WITH FILE = 3
GO

-- 2.a ��ԭ�ļ�ʱ�������ݿ�
DROP DATABASE db_test
GO
RESTORE DATABASE db_test
	FILE = N'db_test_2'
FROM DISK = 'c:\db_test.bak'
WITH FILE = 2
GO

-- 2.b ��ԭ�ļ�ʱ��ʱ�������ݿ�
DROP DATABASE db_test
GO
RESTORE DATABASE db_test
	FILEGROUP = N'FG'
FROM DISK = 'c:\db_test.bak'
WITH FILE = 1
GO

-- 3. ��ԭ���ļ���ʱ�������ݿ⣬ͬʱ��ԭ�û������ļ���
RESTORE DATABASE db_test
	FILEGROUP = N'PRIMARY',
	FILEGROUP = N'FG'
FROM DISK = 'c:\db_test.bak'
WITH FILE = 1
GO

-- ɾ�����Ի���
DROP DATABASE db_test