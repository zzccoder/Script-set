USE master
GO
-- �����������ݿ�
CREATE DATABASE db_test
GO

-- �����ݿ���б���
BACKUP DATABASE db_test
TO DISK = 'c:\db_test.bak'
WITH FORMAT
GO

-- �������Ա�
CREATE TABLE db_test.dbo.tb_test(
	ID int)

-- ��ʱ 2 ����,�ٽ��к���Ĳ���(��������SQL Server��ʱ�侫�����Ϊ�ٷ�֮����,����ʱ�Ļ�,���ܻᵼ�»�ԭ��ʱ���Ĳ���ʧ��)
WAITFOR DELAY '00:00:02'
GO

-- �����������������ɾ���� db_test.dbo.tb_test �����
DROP TABLE db_test.dbo.tb_test

--����ɾ�����ʱ��
SELECT dt = GETDATE() INTO #
GO

--��ɾ��������,���ֲ�Ӧ��ɾ���� db_test.dbo.tb_test

--������ʾ����λָ������ɾ���ı� db_test.dbo.tb_test

--����,����������־(ʹ��������־���ܻ�ԭ��ָ����ʱ���)
BACKUP LOG db_test
TO DISK = 'c:\db_test_log.bak'
WITH FORMAT
GO

-- ������,����Ҫ�Ȼ�ԭ��ȫ����(��ԭ��־�����ڻ�ԭ��ȫ���ݵĻ����Ͻ���)
RESTORE DATABASE db_test
FROM DISK = 'c:\db_test.bak'
WITH REPLACE, 
	NORECOVERY
GO

--��������־��ԭ��ɾ������ǰ�������ʱ���Ӧ�����ɾ��ʱ�䣬����ɾ��ʱ������
DECLARE 
	@dt datetime
SELECT 
	@dt = DATEADD(ms, - 20, dt)
FROM #  --��ȡ�ȱ�ɾ����ʱ�������ʱ��
RESTORE LOG db_test
FROM DISK = 'c:\db_test_log.bak'
WITH RECOVERY,
	STOPAT = @dt
GO

--��ѯһ��,�����Ƿ�ָ�
SELECT * FROM db_test.dbo.tb_test

/*--���:
ID          
----------- 

����Ӱ�������Ϊ 0 �У�
--*/

--���Գɹ�
GO

--���ɾ���������Ĳ��Ի���
DROP DATABASE db_test
DROP TABLE #
