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

-- ��ʱ 1 ����,�ٽ��к���Ĳ���(��������SQL Server��ʱ�侫�����Ϊ�ٷ�֮����,����ʱ�Ļ�,���ܻᵼ�»�ԭ��ʱ���Ĳ���ʧ��)
WAITFOR DELAY '00:00:01'
GO

-- �����������������ɾ���� db_test.dbo.tb_test �����
DROP TABLE db_test.dbo.tb_test
GO

--��ɾ��������,���ֲ�Ӧ��ɾ���� db_test.dbo.tb_test

--������ʾ����λָ������ɾ���ı� db_test.dbo.tb_test

--����,����������־(ʹ��������־���ܻ�ԭ��ָ����ʱ���)
BACKUP LOG db_test
TO DISK = 'c:\db_test_log.bak'
WITH FORMAT
GO

-- ��ȡ�ɳ��Ե�ʱ�䷶Χ
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

-- ���峢�Ե�ʱ�䷶Χ���Լ�����ʱ���ļ��
DECLARE
	@start_date datetime,
	@stop_date datetime,
	@try_step_millsecond int,
	@msg nvarchar(1000)
SELECT
	@start_date = MIN(BackupFinishDate),  -- ���Բ�����ɾ�����ݵĿ�ʼʱ��
	@stop_date = MAX(BackupFinishDate),   -- ���Բ�����ɾ�����ݵĽ���ʱ��
	@try_step_millsecond = 500            -- ÿ 500 ����Ϊһ��ʱ�����һ������
FROM #

-- ��ԭ��ȫ����
RESTORE DATABASE db_test
FROM DISK = 'c:\db_test.bak'
WITH REPLACE, 
	NORECOVERY

-- ��ԭ��־���ݵ����㣬��Ѱ�ҳ���������
WHILE @start_date < @stop_date
BEGIN
	SELECT
		@start_date = DATEADD(ms, @try_step_millsecond, @start_date),
		@msg = N'����ʱ���: ' + CONVERT(varchar(50), @start_date, 121)

	RAISERROR(@msg, 10, 1) WITH NOWAIT
	BEGIN TRY
		-- ��ԭ��־��ָ���ĵ㣬��ͨ�� STANDBY ʹ���ݿ���ֻ������
		RESTORE LOG db_test
		FROM DISK = 'c:\db_test_log.bak'
		WITH STOPAT = @start_date,
			STANDBY = 'c:\db_test_redo.bak'

		-- �����Ҫ�������Ƿ����
		IF OBJECT_ID(N'db_test.dbo.tb_test') IS NOT NULL
		BEGIN
			-- ��ʾ��ԭ��ʱ���
			SELECT Restoreto = @start_date
			-- ������ݿ⻹ԭ��ʹ���ݿ�ɶ�д
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

--���ɾ�����Ի���
DROP DATABASE db_test
DROP TABLE #
