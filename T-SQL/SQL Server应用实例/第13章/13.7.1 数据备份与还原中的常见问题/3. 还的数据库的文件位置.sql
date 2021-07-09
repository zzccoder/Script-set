-- ����һ���������ݿ�
CREATE DATABASE db_test
ON(
	NAME = db_test_DATA,
	FILENAME = 'c:\db_test.mdf')
LOG ON(
	NAME = db_test_log,
	FILENAME = 'c:\db_test.ldf')
GO

-- ���ݲ�ɾ���������ݿ�
BACKUP DATABASE db_test
TO DISK = 'c:\db_test.bak'
WITH FORMAT

DROP DATABASE db_test
GO

--����һ���ļ��ṹ��ͬ,�������ļ�λ�ò�ͬ�����ݿ�
CREATE DATABASE db_test
ON(
	NAME = db_test_DATA,
	FILENAME = 'd:\db_test.mdf')
LOG ON(
	NAME = db_test_log,
	FILENAME = 'd:\db_test.ldf')
GO

--���½������ݿ���ǿ�ƻ�ԭ����
RESTORE DATABASE db_test
FROM DISK = 'c:\db_test.bak'
WITH REPLACE

--�鿴��ԭ����ļ�λ��
SELECT 
	name, physical_name
FROM db_test.sys.database_files
/* -- ��ѯ������£�(��ԭ���ļ����ƶ����½����ݿ�ʱָ���Ķ�Ӧ�ļ�)
name                 physical_name
-------------------- ----------------
db_test_DATA         d:\db_test.mdf
db_test_log          d:\db_test.ldf

(2 ����Ӱ��)
--*/
GO

--ɾ������
DROP DATABASE db_test
