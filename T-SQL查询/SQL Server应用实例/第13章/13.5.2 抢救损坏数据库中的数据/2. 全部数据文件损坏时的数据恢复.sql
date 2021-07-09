USE master
GO
--�����������ݿ�
CREATE DATABASE db_test
ON(
	NAME = db_test_DATA,
	FILENAME = 'c:\db_test.mdf'),
FILEGROUP FG_1(
	NAME = db_test_DATA_1,
	FILENAME = 'c:\db_test_1.ndf')
LOG ON(
	NAME = db_test_LOG,
	FILENAME = 'c:\db_test.ldf')
GO

-- ���ݿⱸ��
BACKUP DATABASE db_test
TO DISK = 'c:\db_test.bak'
WITH FORMAT
GO

-- ����֮�������Ա�
CREATE TABLE db_test.dbo.tb_PRIMARY(
	id int
) ON [PRIMARY]

CREATE TABLE db_test.dbo.tb_FG_1(
	id int
) ON FG_1
GO


-- ֹͣ SQL Server ʵ�����ƻ����е������ļ�
SHUTDOWN

/*-- ������������ϵͳ�н���
1. ɾ���ļ� c:\db_test.mdf��c:\db_test_1.ndf (ģ���ƻ�)
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
FROM DISK = 'c:\db_test.bak'
WITH NORECOVERY

-- ��ԭ���ݿ�β��־
RESTORE LOG db_test 
FROM DISK = 'c:\db_test_log.bak' 
WITH RECOVERY
GO

-- ��ѯ���ݿⱸ��֮�����ĸ������Ƿ���ڣ�����֤�ָ�����ȷ��
SELECT * FROM db_test.dbo.tb_PRIMARY
SELECT * FROM db_test.dbo.tb_FG_1
/*-- ������£���Ϊ���еı����ڣ������������ݳɹ�
id
-----------

(0 ����Ӱ��)

id
-----------

(0 ����Ӱ��)
--*/
GO

-- ɾ�����Ի���
DROP DATABASE db_test