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

-- ��ȫ���ݲ�ɾ���������ݿ�
BACKUP DATABASE db_test
TO DISK = 'c:\db_test.bak'
WITH FORMAT

DROP DATABASE db_test
GO


-- ���仹ԭ����
-- ��ʼ���仹ԭ
RESTORE DATABASE db_test
	FILEGROUP = N'PRIMARY'
FROM DISK = 'c:\db_test.bak'
WITH REPLACE,
	PARTIAL
GO

-- ��ѯ�ɶ�д��ֻ���ļ����ϵĲ��Ա��Ƿ��Ѿ��ָ�
SELECT * FROM db_test.dbo.tb_RW
SELECT * FROM db_test.dbo.tb_R
/*-- ���Խ��
��Ϣ 8653������ 16��״̬ 1���� 1 ��
��ѯ�������޷�Ϊ�����ͼ 'tb_RW' ���ɼƻ�����Ϊ�ñ�פ���ڲ���������״̬���ļ����С�
--*/
GO

-- ������ԭ�ɶ�д�ļ���
RESTORE DATABASE db_test
	FILEGROUP = N'FG_READ_WRITE'
FROM DISK = 'c:\db_test.bak'
GO

-- ��ѯ�ɶ�д��ֻ���ļ����ϵĲ��Ա��Ƿ��Ѿ��ָ�
SELECT * FROM db_test.dbo.tb_RW
SELECT * FROM db_test.dbo.tb_R
/*-- ���Խ��
��Ϣ 8653������ 16��״̬ 1���� 3 ��
��ѯ�������޷�Ϊ�����ͼ 'tb_R' ���ɼƻ�����Ϊ�ñ�פ���ڲ���������״̬���ļ����С�
--*/
GO

-- ������ԭֻ��д�ļ���
RESTORE DATABASE db_test
	FILEGROUP = N'FG_READ_ONLY'
FROM DISK = 'c:\db_test.bak'
GO

-- ��ѯ�ɶ�д��ֻ���ļ����ϵĲ��Ա��Ƿ��Ѿ��ָ�
SELECT * FROM db_test.dbo.tb_RW
SELECT * FROM db_test.dbo.tb_R
/*-- ���Խ��
id
-----------

(0 ����Ӱ��)

id
-----------

(0 ����Ӱ��)
--*/
GO

-- ɾ���������ݿ�
DROP DATABASE db_test
