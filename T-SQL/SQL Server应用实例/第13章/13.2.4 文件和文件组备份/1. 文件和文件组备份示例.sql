USE master
GO
-- ����һ���������ļ��顢��д�ļ��顢ֻ���ļ���Ĳ������ݿ�
CREATE DATABASE db_test
ON(
	NAME = db_test_DATA,
	FILENAME = 'c:\db_test.mdf'
),
FILEGROUP FG_READ_WRITE(
	NAME = db_test_RW,
	FILENAME = 'c:\db_test_RW.ndf'
),
FILEGROUP FG_READ_ONLY(
	NAME = db_test_R,
	FILENAME = 'c:\db_test_R.ndf'
)
LOG ON(
	NAME = db_test_LOG,
	FILENAME = 'c:\db_test.ldf'
)
GO

-- ����ֻ���ļ���
ALTER DATABASE db_test
MODIFY FILEGROUP FG_READ_ONLY READ_ONLY
GO

-- �ļ����ļ��鱸��
BACKUP DATABASE db_test
	FILEGROUP = 'PRIMARY',
	FILE = 'db_test_R'
TO DISK = 'c:\db_test.bak'
WITH FORMAT
GO

-- ɾ���������ݿ�
DROP DATABASE db_test

