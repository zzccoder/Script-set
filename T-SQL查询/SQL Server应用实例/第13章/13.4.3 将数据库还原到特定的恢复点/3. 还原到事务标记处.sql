USE master
GO
-- ��������ȫ���ݲ������ݿ�
CREATE DATABASE db_test
BACKUP DATABASE db_test
TO DISK = 'c:\db_test.bak'
WITH FORMAT
GO

-- ���������
BEGIN TRANSACTION Tran1 WITH MARK

CREATE TABLE db_test.dbo.tb(
	id int)

COMMIT TRAN Tran1

-- ������ɺ��������
INSERT db_test.dbo.tb(
	id)
SELECT 
	object_id 
FROM sys.objects
GO

-- ����������־
BACKUP LOG db_test
TO DISK = 'c:\db_test_log.bak'
WITH FORMAT
GO

-- ��ԭ���ݵ������� Tran1 ǰ
-- ��ԭ��ȫ����
RESTORE DATABASE db_test
FROM DISK = 'c:\db_test.bak'
WITH NORECOVERY,
	REPLACE

-- ��ԭ��־
RESTORE LOG db_test
FROM DISK='c:\db_test_log.bak'
WITH STOPBEFOREMARK = 'Tran1',
	STANDBY = 'C:\db_test_redo.bak'

-- ������ Tran1 ǰû�д��������ñ��Ƿ���ڣ�����֤�ĵ��Ƿ���ȷ
SELECT OBJECT_ID(N'db_test.dbo.tb')
/* -- ���:
-----------
NULL

(1 ����Ӱ��)
--*/
GO

-- ��ԭ���ݿ⵽������ Tran1 ��
RESTORE LOG db_test
FROM DISK = 'c:\db_test_log.bak'
WITH STOPATMARK = 'Tran1'

-- �����Ա��Ƿ���ڣ�����֤�ĵ��Ƿ���ȷ
SELECT 
	OBJECT_ID(N'db_test.dbo.tb'), COUNT(*)
FROM db_test.dbo.tb
/*-- ���
----------- -----------
2073058421  0
--*/
GO

-- ɾ������
DROP DATABASE db_test
