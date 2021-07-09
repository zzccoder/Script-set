-- 1. ����һ����ʾ�õ����ݿ�(�����ݿ�)
CREATE DATABASE db_test
ON(
	NAME = db_test_DATA,
	FILENAME = 'c:\db_test.mdf')
LOG ON (
	NAME = db_test_LOG,
	FILENAME = 'c:\db_test.ldf')
GO


-- 2. ��ʼ���������ݿ�
--    a. �����ݿ���б���
BACKUP DATABASE db_test
TO DISK = 'c:\db_test.bak'
WITH FORMAT
GO

--    b. �ڱ��÷������ϻ�ԭ�����ݿⱸ��
--       �ڱ�ʾ���У������ݿ�ͱ������ݿ���ͬһ��ʵ����
RESTORE DATABASE db_test_bak 
FROM DISK = 'c:\db_test.bak' 
WITH REPLACE,
	STANDBY = 'c:\db_test_redo.bak',
	MOVE 'db_test_DATA' TO 'c:\db_test_bak.mdf',
	MOVE 'db_test_LOG' TO 'c:\db_test_bak.ldf'
GO


-- 3. ͬ�������ݿ��뱸�����ݿ�
--    a. ���� SQL Agent ����
DECLARE @tb_AgentStatus TABLE(
	status varchar(50))
INSERT @tb_AgentStatus 
EXEC master.dbo.xp_servicecontrol N'QUERYSTATE', N'SQLSERVERAGENT'
IF NOT EXISTS(
		SELECT * FROM @tb_AgentStatus
		WHERE status = 'Running.')
	EXEC master.dbo.xp_servicecontrol N'START', N'SQLSERVERAGENT'
GO

--    b. ���������������ݿ��뱸�÷��������ݿ�֮��ͬ������ҵ
--       ʵ��Ӧ��ʱ�������ݿ�/�������ݿ�һ���ڲ�ͬʵ��, ��Ӧ�������������Ͻ������ݵ���ҵ�����÷������Ͻ�����ԭ����ҵ, ���ұ����ļ�Ӧ�÷������������ͱ��ö��ܷ��ʵĹ���Ŀ¼��
DECLARE
	@job_id uniqueidentifier
EXEC msdb.dbo.sp_add_job
	@job_id = @job_id OUTPUT,
	@job_name = N'_����ͬ���������'

-- ����ͬ��������
EXEC msdb..sp_add_jobstep 
	@job_id = @job_id,
	@step_name = N'����ͬ��',
	@subsystem = 'TSQL',
	@command = N'
-- �����ݿ��н�����־����
BACKUP LOG db_test
TO DISK = N''c:\db_test_log.bak''
WITH FORMAT

-- �������ݿ��л�ԭ�����ݿ����־����(Ӧ�������ݿ��е����±仯
RESTORE LOG db_test_bak
FROM DISK = N''c:\db_test_log.bak''
WITH STANDBY = N''c:\db_test_redo.bak''
',
	@retry_attempts = 5,
	@retry_interval = 1

-- ��������(ÿ����ִ��һ��)
EXEC msdb.dbo.sp_add_jobschedule
	@job_id = @job_id,
	@name = N'ʱ�䰲��',
	@freq_type = 4,
	@freq_interval = 1,
	@freq_subday_type = 0x4,
	@freq_subday_interval = 1,
	@freq_recurrence_factor = 1

-- ���Ŀ�������
EXEC msdb.dbo.sp_add_jobserver 
	@job_id = @job_id,
	@server_name = N'(local)' 
GO

-- 4. ����ͬ���Ƿ�ʵ��
--    ͨ����������,�����ݿ��뱸�����ݿ�֮���ͬ����ϵ�Ѿ��������
--    ���濪ʼ�����Ƿ���ʵ��ͬ��

--    a.�������ݿ��д���һ�������õı�
CREATE TABLE db_test.dbo.tb_test(
	ID int)
GO

--    b. �ȴ�2���ӣ�����ͬ����ʱ��������Ϊ1����,����Ҫ��ʱ���ܿ���Ч����
WAITFOR DELAY '00:02:30'
GO

--    c. ��ѯһ�±������ݿ�,����ͬ���Ƿ�ɹ�
SELECT * FROM db_test_bak.dbo.tb_test
/*--������£�˵�����Գɹ�
ID
-----------

(0 ����Ӱ��)
--*/
GO

--���ɾ�����еĲ���
EXEC msdb.dbo.sp_delete_job
	@job_name = N'_����ͬ���������'
DROP DATABASE db_test, db_test_bak
