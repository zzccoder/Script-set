-- =====================================================
-- ���������ϵĲ���
-- =====================================================
-- 1. ���������õ���Ŀ¼
--    ��������ݿ�͸������ݿ��Ŀ¼
EXEC sys.xp_create_subdir 'c:\LogShip_Test\Data\Primary'
EXEC sys.xp_create_subdir 'c:\LogShip_Test\Data\Secondary'

--    ���ݼ���ԭ�ļ����Ŀ¼
EXEC sys.xp_create_subdir 'c:\LogShip_Test\Backup\Primary_Backup'
EXEC sys.xp_create_subdir 'c:\LogShip_Test\Backup\Secondary_Restore'
GO


-- =====================================================
-- 2. �����������ݿ�
USE master
GO

CREATE DATABASE DB_LogShip_Test
ON(
	NAME = DB_LogShip_Test,
	FILENAME = N'c:\LogShip_Test\Data\Primary\DB_LogShip_Test.mdf')
LOG ON(
	NAME = DB_LogShip_Test_LOG,
	FILENAME = N'c:\LogShip_Test\Data\Primary\DB_LogShip_Test.ldf')
GO


-- =====================================================
-- 3. ��ʼ���������ݿ�
BACKUP DATABASE DB_LogShip_Test
TO DISK = N'c:\LogShip_Test\Backup\DB_LogShip_Test_Init.bak'
WITH FORMAT

RESTORE DATABASE LS_DB_LogShip_Test
FROM DISK = N'c:\LogShip_Test\Backup\DB_LogShip_Test_Init.bak'
WITH REPLACE,
	MOVE N'DB_LogShip_Test' TO N'c:\LogShip_Test\Data\Secondary\LS_DB_LogShip_Test.mdf',
	MOVE N'DB_LogShip_Test_LOG' TO N'c:\LogShip_Test\Data\Secondary\LS_DB_LogShip_Test.ldf',
	STANDBY = N'c:\LogShip_Test\Backup\recovery_LS_DB_LogShip_Test.bak'

RESTORE DATABASE LS_DB_LogShip_Test1
FROM DISK = N'c:\LogShip_Test\Backup\DB_LogShip_Test_Init.bak'
WITH REPLACE,
	MOVE N'DB_LogShip_Test' TO N'c:\LogShip_Test\Data\Secondary\LS_DB_LogShip_Test1.mdf',
	MOVE N'DB_LogShip_Test_LOG' TO N'c:\LogShip_Test\Data\Secondary\LS_DB_LogShip_Test1.ldf',
	STANDBY = N'c:\LogShip_Test\Backup\recovery_LS_DB_LogShip_Test1.bak'
GO


-- =====================================================
-- 4. ������־�������õ������ݿ⼰���ñ�����ҵ
DECLARE
	@LS_backup_job_id uniqueidentifier,
	@sp_re int

--     ������־�������õ������ݿ⼰������ҵ
EXEC @sp_re = dbo.sp_add_log_shipping_primary_database 
	@backup_job_id = @LS_backup_job_id OUTPUT,
	@database = N'DB_LogShip_Test',
	@backup_directory = N'c:\LogShip_Test\Backup\Primary_Backup',
	@backup_share = N'c:\LogShip_Test\Backup\Primary_Backup',
	@backup_job_name = N'LS_Backup_DB_LogShip_Test'

--     ������ҵ�ƻ�����(��������Ϊÿ����1��)
IF (@@ERROR = 0 AND @sp_re = 0) 
BEGIN 
	EXEC msdb.dbo.sp_add_jobschedule 
		@job_id = @LS_backup_job_id,
		@name =N'LS_Backup_DB_LogShip_Test',
		@enabled = 1,
		@freq_type = 4,
		@freq_interval = 1,
		@freq_subday_type = 4,
		@freq_subday_interval = 1,
		@freq_recurrence_factor = 0,
		@active_start_date = 19900101,
		@active_end_date = 99991231,
		@active_start_time = 0,
		@active_end_time = 235900

	EXEC msdb.dbo.sp_update_job 
		@job_id = @LS_backup_job_id,
		@enabled = 1 
END 
GO

-- =====================================================
-- 5. ��������������Ӹ������ݿ���
EXEC dbo.sp_add_log_shipping_primary_secondary 
	@primary_database = N'DB_LogShip_Test',
	@secondary_server = N'localhost',
	@secondary_database = N'LS_DB_LogShip_Test'

EXEC dbo.sp_add_log_shipping_primary_secondary 
	@primary_database = N'DB_LogShip_Test',
	@secondary_server = N'localhost',
	@secondary_database = N'LS_DB_LogShip_Test1'
GO


-- ====================================================��
-- �����������ϵĲ���
-- =====================================================
-- 6. �ڸ�����������Ϊָ���������ݿ���������������Ϣ
DECLARE 
	@LS_Secondary_copy_job_id AS uniqueidentifier,
	@LS_Secondary_restore_job_id AS uniqueidentifier,
	@sp_re int

--    ��������������Ϣ������������ҵ�ͻ�ԭ��ҵ
EXEC @sp_re = dbo.sp_add_log_shipping_secondary_primary 
	@copy_job_id = @LS_Secondary_copy_job_id OUTPUT,
	@restore_job_id = @LS_Secondary_restore_job_id OUTPUT,
	@primary_server = N'localhost',
	@primary_database = N'DB_LogShip_Test',
	@backup_source_directory = N'c:\LogShip_Test\Backup\Primary_Backup',
	@backup_destination_directory = N'c:\LogShip_Test\Backup\Secondary_Restore',
	@copy_job_name = N'LS_Copy_DB_LogShip_Test',
	@restore_job_name = N'LS_Restore_DB_LogShip_Test'

--    ���ø�����ҵ�ͻ�ԭ��ҵ�ƻ�
IF (@@ERROR = 0 AND @sp_re = 0) 
BEGIN 
	-- ������ҵ(ÿ����һ��)
	EXEC msdb.dbo.sp_add_jobschedule 
		@job_id = @LS_Secondary_copy_job_id,
		@name =N'LS_Copy_DB_LogShip_Test',
		@enabled = 1,
		@freq_type = 4,
		@freq_interval = 1,
		@freq_subday_type = 4,
		@freq_subday_interval = 1,
		@freq_recurrence_factor = 0,
		@active_start_date = 19900101,
		@active_end_date = 99991231,
		@active_start_time = 0,
		@active_end_time = 235900

	EXEC msdb.dbo.sp_update_job 
		@job_id = @LS_Secondary_copy_job_id,
		@enabled = 1 

	-- ��ԭ��ҵ(ÿ����һ��)
	EXEC msdb.dbo.sp_add_jobschedule 
		@job_id = @LS_Secondary_restore_job_id,
		@name =N'LS_Restore_DB_LogShip_Test',
		@enabled = 1,
		@freq_type = 4,
		@freq_interval = 1,
		@freq_subday_type = 4,
		@freq_subday_interval = 1,
		@freq_recurrence_factor = 0,
		@active_start_date = 19900101,
		@active_end_date = 99991231,
		@active_start_time = 0,
		@active_end_time = 235900

	EXEC msdb.dbo.sp_update_job 
		@job_id = @LS_Secondary_restore_job_id,
		@enabled = 1 
END 
GO

-- =====================================================
-- 7. ���ø������ݿ�
EXEC dbo.sp_add_log_shipping_secondary_database 
	@secondary_database = N'LS_DB_LogShip_Test',
	@primary_server = N'localhost', 
	@primary_database = N'DB_LogShip_Test',
	@restore_delay = 0,
	@restore_mode = 1

EXEC dbo.sp_add_log_shipping_secondary_database 
	@secondary_database = N'LS_DB_LogShip_Test1',
	@primary_server = N'localhost', 
	@primary_database = N'DB_LogShip_Test',
	@restore_delay = 0,
	@restore_mode = 1
GO


-- ====================================================��
-- �����������Ͻ������Բ����Ƿ����ͬ��������������
-- =====================================================
-- 8. �������Ա�
CREATE TABLE DB_LogShip_Test.dbo.tb(
	id int)
GO

-- ====================================================��
-- �ڸ�����������ѯ��ȷ���Ƿ�ͬ���ɹ�
-- =====================================================
-- 9. ��ѯ���Ա�
-- ��ʱ 5 ����
RAISERROR(N'��ʱ 5 ���ӣ��Եȴ�ͬ�����', 10, 1) WITH NOWAIT
WAITFOR DELAY '00:05:00'
SELECT * FROM LS_DB_LogShip_Test.dbo.tb
SELECT * FROM LS_DB_LogShip_Test1.dbo.tb
GO


-- ====================================================��
-- �ڸ���������ɾ����־��������
-- =====================================================
-- 10. ɾ���������ݿ�
--     ɾ���������ݿ⼰�����뻹ԭ��ҵ
--     �����뻹ԭ��ҵ�����и���Ŀ�ĸ������ݿⱻɾ�����Զ�ɾ��
EXEC dbo.sp_delete_log_shipping_secondary_database
	@secondary_database = N'LS_DB_LogShip_Test'

EXEC dbo.sp_delete_log_shipping_secondary_database
	@secondary_database = N'LS_DB_LogShip_Test1'

-- ɾ�����������������Ϣ
EXEC dbo.sp_delete_log_shipping_secondary_primary
	@primary_server = N'localhost',
	@primary_database = N'DB_LogShip_Test'
GO

-- ====================================================��
-- ������������ɾ����־��������
-- =====================================================
-- 11. ɾ�������ݿ�
--     ɾ���������ݿ���Ŀ
EXEC dbo.sp_delete_log_shipping_primary_secondary
    @primary_database = N'DB_LogShip_Test', 
    @secondary_server = N'localhost', 
    @secondary_database = N'LS_DB_LogShip_Test'
EXEC dbo.sp_delete_log_shipping_primary_secondary
    @primary_database = N'DB_LogShip_Test', 
    @secondary_server = N'localhost', 
    @secondary_database = N'LS_DB_LogShip_Test1'

--     ɾ�������ݿ�
EXEC dbo.sp_delete_log_shipping_primary_database
	@database = N'DB_LogShip_Test'

--     ɾ��������ҵ(���ӷ�������ִ��)
EXEC dbo.sp_delete_log_shipping_alert_job 
GO


-- ====================================================��
-- �ڸ���������ɾ���������ݿ�
-- =====================================================
-- 12. ɾ���������ݿ�
DROP DATABASE LS_DB_LogShip_Test
DROP DATABASE LS_DB_LogShip_Test1
GO

-- ====================================================��
-- ������������ɾ�������ݿ�
-- =====================================================
-- 13. ɾ�������ݿ�
DROP DATABASE DB_LogShip_Test
GO

-- ====================================================��
-- ��󣬴� sql server �������ļ�ϵͳ��ɾ��c:\LogShip_Test 
-- =====================================================
