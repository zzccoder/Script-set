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
-- ��Ĭ���ļ�������Ϊ ��д�ļ���
ALTER DATABASE db_test
MODIFY FILEGROUP FG_READ_WRITE DEFAULT
GO

-- ��Ĭ�ϣ���д���ļ����ϴ�������
CREATE TABLE db_test.dbo.tb_RW(
	id int
)
-- ��ֻ���ļ����ϴ�������
CREATE TABLE db_test.dbo.tb_R(
	id int
)ON FG_READ_ONLY
GO

-- ����ֻ���ļ���
ALTER DATABASE db_test
MODIFY FILEGROUP FG_READ_ONLY READ_ONLY
GO

-- ���ֱ���
BACKUP DATABASE db_test
	READ_WRITE_FILEGROUPS
TO DISK = 'c:\db_test.bak'
WITH FORMAT
-- �ļ��鱸��
BACKUP DATABASE db_test
	FILEGROUP = 'FG_READ_ONLY'
TO DISK = 'c:\db_test.bak'
GO

-- 1. �������������ݿ�����ϻ�ԭ���ֱ���
-- ɾ���ɶ�д�ļ����ϵı�
DROP TABLE db_test.dbo.tb_RW
GO
-- ���������ݿ�����ϻ�ԭ���ֱ���
RESTORE DATABASE db_test
FROM DISK = 'c:\db_test.bak'
WITH REPLACE
GO

-- ��ѯ���Ƿ�ָ�����ֻ���ļ����ϱ��Ƿ���
SELECT * FROM db_test.dbo.tb_RW
SELECT * FROM db_test.dbo.tb_R
GO


-- 2. �����ڿհ����ݿ��ϻ�ԭ���ֱ���
DROP DATABASE db_test
GO
-- ���������ݿ�����ϻ�ԭ���ֱ���
RESTORE DATABASE db_test
FROM DISK = 'c:\db_test.bak'
WITH REPLACE
GO

-- ��ѯ���Ƿ�ָ�����ֻ���ļ����ϱ��Ƿ���
SELECT * FROM db_test.dbo.tb_RW
SELECT * FROM db_test.dbo.tb_R
GO

-- ��ѯ���ļ���״̬
SELECT * FROM db_test.sys.database_files
GO


-- 3. �ļ��黹ԭ
RESTORE DATABASE db_test
	FILEGROUP = 'FG_READ_ONLY'
FROM DISK = 'c:\db_test.bak'
WITH FILE = 2
GO
-- ��ѯ���Ƿ�ָ�����ֻ���ļ����ϱ��Ƿ���
SELECT * FROM db_test.dbo.tb_RW
SELECT * FROM db_test.dbo.tb_R
GO


-- ɾ���������ݿ�
DROP DATABASE db_test
