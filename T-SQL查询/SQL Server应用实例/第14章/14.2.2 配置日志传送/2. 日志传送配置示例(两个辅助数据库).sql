-- =====================================================
-- 主服务器上的操作
-- =====================================================
-- 1. 创建测试用到的目录
--    存放主数据库和辅助数据库的目录
EXEC sys.xp_create_subdir 'c:\LogShip_Test\Data\Primary'
EXEC sys.xp_create_subdir 'c:\LogShip_Test\Data\Secondary'

--    备份及还原文件存放目录
EXEC sys.xp_create_subdir 'c:\LogShip_Test\Backup\Primary_Backup'
EXEC sys.xp_create_subdir 'c:\LogShip_Test\Backup\Secondary_Restore'
GO


-- =====================================================
-- 2. 创建测试数据库
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
-- 3. 初始化辅助数据库
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
-- 4. 设置日志传送配置的主数据库及配置备份作业
DECLARE
	@LS_backup_job_id uniqueidentifier,
	@sp_re int

--     设置日志传送配置的主数据库及备份作业
EXEC @sp_re = dbo.sp_add_log_shipping_primary_database 
	@backup_job_id = @LS_backup_job_id OUTPUT,
	@database = N'DB_LogShip_Test',
	@backup_directory = N'c:\LogShip_Test\Backup\Primary_Backup',
	@backup_share = N'c:\LogShip_Test\Backup\Primary_Backup',
	@backup_job_name = N'LS_Backup_DB_LogShip_Test'

--     备份作业计划设置(这里设置为每分钟1次)
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
-- 5. 在主服务器上添加辅助数据库项
EXEC dbo.sp_add_log_shipping_primary_secondary 
	@primary_database = N'DB_LogShip_Test',
	@secondary_server = N'localhost',
	@secondary_database = N'LS_DB_LogShip_Test'

EXEC dbo.sp_add_log_shipping_primary_secondary 
	@primary_database = N'DB_LogShip_Test',
	@secondary_server = N'localhost',
	@secondary_database = N'LS_DB_LogShip_Test1'
GO


-- ====================================================＝
-- 辅助服务器上的操作
-- =====================================================
-- 6. 在辅助服务器上为指定的主数据库设置主服务器信息
DECLARE 
	@LS_Secondary_copy_job_id AS uniqueidentifier,
	@LS_Secondary_restore_job_id AS uniqueidentifier,
	@sp_re int

--    设置主服务器信息，创建复制作业和还原作业
EXEC @sp_re = dbo.sp_add_log_shipping_secondary_primary 
	@copy_job_id = @LS_Secondary_copy_job_id OUTPUT,
	@restore_job_id = @LS_Secondary_restore_job_id OUTPUT,
	@primary_server = N'localhost',
	@primary_database = N'DB_LogShip_Test',
	@backup_source_directory = N'c:\LogShip_Test\Backup\Primary_Backup',
	@backup_destination_directory = N'c:\LogShip_Test\Backup\Secondary_Restore',
	@copy_job_name = N'LS_Copy_DB_LogShip_Test',
	@restore_job_name = N'LS_Restore_DB_LogShip_Test'

--    设置复制作业和还原作业计划
IF (@@ERROR = 0 AND @sp_re = 0) 
BEGIN 
	-- 复制作业(每分钟一次)
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

	-- 还原作业(每分钟一次)
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
-- 7. 设置辅助数据库
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


-- ====================================================＝
-- 在主服务器上建立表，以测试是否可以同步到辅助服务器
-- =====================================================
-- 8. 建立测试表
CREATE TABLE DB_LogShip_Test.dbo.tb(
	id int)
GO

-- ====================================================＝
-- 在辅助服务器查询，确定是否同步成功
-- =====================================================
-- 9. 查询测试表
-- 延时 5 分钟
RAISERROR(N'延时 5 分钟，以等待同步完成', 10, 1) WITH NOWAIT
WAITFOR DELAY '00:05:00'
SELECT * FROM LS_DB_LogShip_Test.dbo.tb
SELECT * FROM LS_DB_LogShip_Test1.dbo.tb
GO


-- ====================================================＝
-- 在辅助服务器删除日志传送设置
-- =====================================================
-- 10. 删除辅助数据库
--     删除辅助数据库及复制与还原作业
--     复制与还原作业在所有该项目的辅助数据库被删除后自动删除
EXEC dbo.sp_delete_log_shipping_secondary_database
	@secondary_database = N'LS_DB_LogShip_Test'

EXEC dbo.sp_delete_log_shipping_secondary_database
	@secondary_database = N'LS_DB_LogShip_Test1'

-- 删除主服务器的相关信息
EXEC dbo.sp_delete_log_shipping_secondary_primary
	@primary_server = N'localhost',
	@primary_database = N'DB_LogShip_Test'
GO

-- ====================================================＝
-- 在主服务器上删除日志传送设置
-- =====================================================
-- 11. 删除主数据库
--     删除辅助数据库项目
EXEC dbo.sp_delete_log_shipping_primary_secondary
    @primary_database = N'DB_LogShip_Test', 
    @secondary_server = N'localhost', 
    @secondary_database = N'LS_DB_LogShip_Test'
EXEC dbo.sp_delete_log_shipping_primary_secondary
    @primary_database = N'DB_LogShip_Test', 
    @secondary_server = N'localhost', 
    @secondary_database = N'LS_DB_LogShip_Test1'

--     删除主数据库
EXEC dbo.sp_delete_log_shipping_primary_database
	@database = N'DB_LogShip_Test'

--     删除警报作业(监视服务器上执行)
EXEC dbo.sp_delete_log_shipping_alert_job 
GO


-- ====================================================＝
-- 在辅助服务器删除测试数据库
-- =====================================================
-- 12. 删除辅助数据库
DROP DATABASE LS_DB_LogShip_Test
DROP DATABASE LS_DB_LogShip_Test1
GO

-- ====================================================＝
-- 在主服务器上删除主数据库
-- =====================================================
-- 13. 删除主数据库
DROP DATABASE DB_LogShip_Test
GO

-- ====================================================＝
-- 最后，从 sql server 服务器文件系统中删除c:\LogShip_Test 
-- =====================================================
