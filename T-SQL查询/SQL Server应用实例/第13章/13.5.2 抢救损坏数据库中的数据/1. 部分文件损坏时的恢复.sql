USE master
GO
--�����������ݿ�
CREATE DATABASE db_test
ON(
	NAME = db_test_DATA,
	FILENAME = 'c:\db_test.mdf'),
FILEGROUP FG_1(
	NAME = db_test_DATA_1,
	FILENAME = 'c:\db_test_1.ndf'),
FILEGROUP FG_2(
	NAME = db_test_DATA_2,
	FILENAME = 'c:\db_test_2.ndf')
LOG ON(
	NAME = db_test_LOG,
	FILENAME = 'c:\db_test.ldf')
GO

-- �ڸ����ļ����ϴ������Ա�
CREATE TABLE db_test.dbo.tb_PRIMARY(
	id int
) ON [PRIMARY]

CREATE TABLE db_test.dbo.tb_FG_1(
	id int
) ON FG_1

CREATE TABLE db_test.dbo.tb_FG_2(
	id int
) ON FG_2
GO

-- �ļ��鱸��
BACKUP DATABASE db_test
	FILEGROUP = N'FG_1'
TO DISK = 'c:\db_test_FG_1.bak'
WITH FORMAT

-- ����֮�����ļ��� FG_1 �ϵı� tb_FG_1 �в����������
INSERT db_test.dbo.tb_FG_1(
	id)
VALUES(
	1)
GO

-- ֹͣ SQL Server ʵ�����ƻ��ļ��� FG_1
SHUTDOWN

/*-- ������������ϵͳ�н���
1. ɾ���ļ� c:\db_test_1.ndf (ģ���ƻ�)
2. ����SQL Server����,��ʱ���ݿ�DB����
--*/
GO

--������ʾ����λָ�����
-- ����Ҫ���ݵ�ǰ��־
BACKUP LOG db_test 
TO DISK = 'c:\db_test_log.bak' 
WITH FORMAT,
	NO_TRUNCATE

-- �����ļ��鱸�ݻָ��ƻ����ļ�
RESTORE DATABASE db_test
	FILEGROUP = N'FG_1'
FROM DISK = 'c:\db_test_FG_1.bak'
WITH NORECOVERY

-- ��ԭ���ݿ�β��־
RESTORE LOG db_test 
FROM DISK = 'c:\db_test_log.bak' 
WITH RECOVERY
GO

-- ��ѯ�ļ��� FG_1 �ϵı� tb_FG_1����֤�����Ƿ�ʧ
SELECT * FROM db_test.dbo.tb_FG_1
/*-- ������£��������ݣ���ʾ�������ȳɹ�
id
-----------
1

(1 ����Ӱ��)
--*/
GO

-- ɾ�����Ի���
DROP DATABASE db_test