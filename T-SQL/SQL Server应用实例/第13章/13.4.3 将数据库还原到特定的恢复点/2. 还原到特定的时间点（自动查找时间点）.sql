USE master
GO
-- 创建测试数据库
CREATE DATABASE db_test
GO

-- 对数据库进行备份
BACKUP DATABASE db_test
TO DISK = 'c:\db_test.bak'
WITH FORMAT
GO

-- 创建测试表
CREATE TABLE db_test.dbo.tb_test(
	ID int)

-- 延时 1 秒钟,再进行后面的操作(这是由于SQL Server的时间精度最大为百分之三秒,不延时的话,可能会导致还原到时间点的操作失败)
WAITFOR DELAY '00:00:01'
GO

-- 假设我们现在误操作删除了 db_test.dbo.tb_test 这个表
DROP TABLE db_test.dbo.tb_test
GO

--在删除操作后,发现不应该删除表 db_test.dbo.tb_test

--下面演示了如何恢复这个误删除的表 db_test.dbo.tb_test

--首先,备份事务日志(使用事务日志才能还原到指定的时间点)
BACKUP LOG db_test
TO DISK = 'c:\db_test_log.bak'
WITH FORMAT
GO

-- 获取可尝试的时间范围
IF OBJECT_ID(N'tempdb..#') IS NOT NULL
	DROP TABLE #
CREATE TABLE #(
	BackupName nvarchar(128) ,
	BackupDescription nvarchar(255) ,
	BackupType smallint ,
	ExpirationDate datetime ,
	Compressed tinyint ,
	Position smallint ,
	DeviceType tinyint ,
	UserName nvarchar(128) ,
	ServerName nvarchar(128) ,
	DatabaseName nvarchar(128) ,
	DatabaseVersion int ,
	DatabaseCreationDate datetime ,
	BackupSize numeric(20,0) ,
	FirstLSN numeric(25,0) ,
	LastLSN numeric(25,0) ,
	CheckpointLSN numeric(25,0) ,
	DatabaseBackupLSN numeric(25,0) ,
	BackupStartDate datetime ,
	BackupFinishDate datetime ,
	SortOrder smallint ,
	CodePage smallint ,
	UnicodeLocaleId int ,
	UnicodeComparisonStyle int ,
	CompatibilityLevel tinyint ,
	SoftwareVendorId int ,
	SoftwareVersionMajor int ,
	SoftwareVersionMinor int ,
	SoftwareVersionBuild int ,
	MachineName nvarchar(128) ,
	Flags int ,
	BindingID uniqueidentifier ,
	RecoveryForkID uniqueidentifier ,
	Collation nvarchar(128) ,
	FamilyGUID uniqueidentifier ,
	HasBulkLoggedData bit ,
	IsSnapshot bit ,
	IsReadOnly bit ,
	IsSingleUser bit ,
	HasBackupChecksums bit ,
	IsDamaged bit ,
	BeginsLogChain bit ,
	HasIncompleteMetaData bit ,
	IsForceOffline bit ,
	IsCopyOnly bit ,
	FirstRecoveryForkID uniqueidentifier ,
	ForkPointLSN numeric(25,0) NULL,
	RecoveryModel nvarchar(60) ,
	DifferentialBaseLSN numeric(25,0) NULL,
	DifferentialBaseGUID uniqueidentifier ,
	BackupTypeDescription nvarchar(60) ,
	BackupSetGUID uniqueidentifier NULL
)
INSERT # EXEC(N'
RESTORE HEADERONLY
FROM DISK = ''c:\db_test.bak''
WITH FILE = 1
RESTORE HEADERONLY
FROM DISK = ''c:\db_test_log.bak''
WITH FILE = 1
')
--SELECT 
--	* 
--FROM #

-- 定义尝试的时间范围，以及尝试时间点的间隔
DECLARE
	@start_date datetime,
	@stop_date datetime,
	@try_step_millsecond int,
	@msg nvarchar(1000)
SELECT
	@start_date = MIN(BackupFinishDate),  -- 尝试查找误删除数据的开始时间
	@stop_date = MAX(BackupFinishDate),   -- 尝试查找误删除数据的结束时间
	@try_step_millsecond = 500            -- 每 500 毫秒为一个时间点找一次数据
FROM #

-- 还原完全备份
RESTORE DATABASE db_test
FROM DISK = 'c:\db_test.bak'
WITH REPLACE, 
	NORECOVERY

-- 还原日志备份到各点，以寻找出所需数据
WHILE @start_date < @stop_date
BEGIN
	SELECT
		@start_date = DATEADD(ms, @try_step_millsecond, @start_date),
		@msg = N'尝试时间点: ' + CONVERT(varchar(50), @start_date, 121)

	RAISERROR(@msg, 10, 1) WITH NOWAIT
	BEGIN TRY
		-- 还原日志到指定的点，并通过 STANDBY 使数据库能只读访问
		RESTORE LOG db_test
		FROM DISK = 'c:\db_test_log.bak'
		WITH STOPAT = @start_date,
			STANDBY = 'c:\db_test_redo.bak'

		-- 检查需要的数据是否存在
		IF OBJECT_ID(N'db_test.dbo.tb_test') IS NOT NULL
		BEGIN
			-- 显示还原的时间点
			SELECT Restoreto = @start_date
			-- 完成数据库还原，使数据库可读写
			RESTORE LOG db_test
			WITH RECOVERY

			SELECT
				@start_date = @stop_date
		END
	END TRY
	BEGIN CATCH
	END CATCH
END
GO

--最后删除测试环境
DROP DATABASE db_test
DROP TABLE #
