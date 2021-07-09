--=========================================================
-- �ڷ�����������ִ��
--=========================================================

--============================================
-- 1. ��Ƿַ�������
USE master
GO

EXEC sp_adddistributor
	@distributor = N'SrvB',  -- �ַ�����������
	@password = N'abc.124'   -- distributor_admin ��¼��������
GO


--============================================
-- 2. �����ݿ���Ϊ�������ݿ�
USE AdventureWorks
GO

DECLARE
	@db_name sysname
SELECT
	@db_name = DB_NAME()

EXEC sp_replicationdboption
	@dbname = @db_name,	
	@optname = N'publish',	
	@value = N'true'
GO


--============================================
-- 3. ������񷢲�
USE AdventureWorks
GO

DECLARE
	@publication_table_name sysname,
	@publication_name sysname
	
SELECT
	-- Ҫ�����ı���
	@publication_table_name = N'Person.Address',
	-- ����Ҫ�����ı����Զ����ɷ�������
	@publication_name = N'RP_' + DB_NAME() 
			+ N'.' + ISNULL(PARSENAME(@publication_table_name, 2), N'dbo')
			+ N'.' + PARSENAME(@publication_table_name, 1)

-- a. ��������(�½��ķ����������κ���Ŀ,��Ҫ�ں���Ĳ�������ӷ�����Ŀ)
EXEC sp_addpublication 
	@publication = @publication_name,	
	@sync_method = N'concurrent',   -- ͬ��ģʽ(�������б�ı���ģʽ���������Ƴ������)
	@repl_freq = N'continuous',     -- ����Ƶ��(continuous �����������ṩ���л�����־����������)
	@retention = 0,                 -- ���Ļ�ı�����(0 ������������)
	@allow_push = N'true',          -- ���������Ͷ���
	@allow_pull = N'true',          -- ������������
	@allow_anonymous = N'false',    -- ����������������
	@status = N'active',            -- �������ݿ��������ڶ��ķ�������
	@allow_sync_tran = N'false',    -- ָ���Ƿ�����Է�����ʱ���¶���
	@allow_queued_tran = N'false',  -- �ڶ��ķ����������û���ø��ĵĶ��У�ֱ�����ڷ�����������Ӧ����Щ����Ϊֹ
	@replicate_ddl = 1,             -- ָʾ�÷����Ƿ�֧�ּܹ�����
	@enabled_for_p2p = N'false',    -- �Ƿ������������ڶԵȸ���������
	@enabled_for_het_sub = N'false',-- �Ƿ�ʹ����֧�ַ� SQL Server ���ķ�����
	@independent_agent = N'true'    -- ָ���÷����Ƿ��ж����ַ�����

-- b. �������մ���
DECLARE
	@active_start_date int,
	@active_start_time_of_day int
-- ���ÿ��մ����ڽ����� 10 ��������һ��, �Ա�ʹ��ʼ�����տ���
SELECT
	@active_start_date = CONVERT(char(8), GETDATE(), 112),
	@active_start_time_of_day  = REPLACE(CONVERT(char(8), DATEADD(Second, 10, GETDATE()), 108), ':', '')
EXEC sp_addpublication_snapshot
	@publication = @publication_name,
	@publisher_security_mode = 1, -- ���ӷ���������ʱ����ʹ�õİ�ȫģʽ(1.Windows�����֤)
	@job_login = null,            -- ���ӵ�����������ʱ��ʹ�õĵ�¼��. @publisher_security_mode Ϊ0��,��Ҫָ���˲�����@job_password
	@job_password = null,
    -- ���²��ֶ������ִ�мƻ�
	@frequency_type = 1,
	@frequency_interval = 1,
	@frequency_relative_interval = 1,
	@frequency_recurrence_factor = 0,
	@active_start_date = @active_start_date,
	@active_start_time_of_day = @active_start_time_of_day

-- c. �ڷ�������ӷ�����Ŀ(��/��ͼ/�洢����/�û����庯��)
DECLARE
	@schema_name sysname,
	@object_name sysname,
	@ins_cmd nvarchar(255),
	@del_cmd nvarchar(255),
	@upd_cmd nvarchar(255)

-- ���ݷ��������Զ�������ӷ�����Ҫ��һЩ��Ϣ
SELECT
	@schema_name = ISNULL(PARSENAME(@publication_table_name, 2), N'dbo'),
	@object_name = PARSENAME(@publication_table_name, 1),
	@ins_cmd = N'CALL sp_MSins_' + @schema_name + @object_name,
	@del_cmd = N'CALL sp_MSdel_' + @schema_name + @object_name,
	@upd_cmd = N'SCALL sp_MSupd_' + @schema_name + @object_name

EXEC sp_addarticle
	@publication = @publication_name,
	@article = @object_name,         -- ��Ŀ����
	@source_owner = @schema_name,    -- ��������ļܹ�����
	@source_object = @object_name,   -- ������������
	@type = N'logbased',             -- ������Ŀ����
	@pre_creation_cmd = N'none',     -- Ӧ�ÿ���ʱ, ���ķ��������ڶ��ı�ʱ�Ĵ���ʽ(none�����Ѿ����ڵĶ��ı�,��������)
	@schema_option = 0x000000000803509F,        -- ������Ŀ�ļܹ�����ѡ���λ����
	@identityrangemanagementoption = N'manual', -- ָ����δ�����Ŀ�ı�ʶ��Χ����
	@destination_owner = @schema_name,  -- ���ı�ܹ�����
	@destination_table = @object_name,  -- ���ı�����
	@vertical_partition = N'false',     -- ���û���öԱ���Ŀ����ɸѡ
	@ins_cmd = @ins_cmd,
	@del_cmd = @del_cmd,
	@upd_cmd = @upd_cmd
GO


--============================================
-- 4. ����
-- �������Ͷ��ĺ����������ַ�ʽ����ѡһ��
--============================================
-- ���Ͷ���
-- 4. ��Ӷ���
USE AdventureWorks
GO

DECLARE
	@publication_table_name sysname,
	@publication_name sysname,
	@subscriber_server sysname,
	@subscriber_db sysname

SELECT
	-- Ҫ�����ı���
	@publication_table_name = N'Person.Address',
	-- ����Ҫ�����ı����Զ����ɷ�������
	@publication_name = N'RP_' + DB_NAME() 
			+ N'.' + ISNULL(PARSENAME(@publication_table_name, 2), N'dbo')
			+ N'.' + PARSENAME(@publication_table_name, 1),
	@subscriber_db = DB_NAME(),           -- �������ݿ�����(�����뷢�����ݿ�һ��)
	@subscriber_server = N'SrvC'          -- ���ķ���������

-- a. ��Ӷ���
EXEC sp_addsubscription 
	@publication = @publication_name,
	@subscriber = @subscriber_server,
	@destination_db = @subscriber_db,
	@subscription_type = N'Push',  -- ���ĵ�����(Push ���Ͷ���, Pull ������)
--	@sync_type = N'automatic',     -- ����ͬ������(automatic �ѷ�����ļܹ��ͳ�ʼ���ݽ����ȴ��䵽���ķ�����)
	@sync_type = N'replication support only',     -- ���ڶ��ķ����������ɷ�����Ŀ�Զ���洢���̺�֧�ָ��¶��ĵĴ�����(�ٶ����ķ������Ѿ������ѷ�����ļܹ��ͳ�ʼ����)
	@article = N'all',             -- ���ĵ���Ŀ, all ��ʾ����������Ŀ(�����Ժ��ڴ˷�������������Ŀ)
	@update_mode = N'read only'    -- ��������(read only ֻ��,���ķ������ĸ��²�����������������)

-- b. �����ַ�����
EXEC sp_addpushsubscription_agent 
	@publication = @publication_name,
	@subscriber = @subscriber_server,
	@subscriber_db = @subscriber_db,
	@subscriber_security_mode = 1, -- ���ӵ����ķ�������ʹ�õİ�ȫģʽ(1.Windows�����֤)
	@job_login = null,            -- ���ӵ����ķ�����ʱ��ʹ�õĵ�¼��. @subscriber_security_mode Ϊ0��,��Ҫָ���˲�����@job_password
	@job_password = null,
    -- ���²����������ִ�мƻ�
	@frequency_type = 64,
	@frequency_interval = 0,
	@frequency_relative_interval = 0,
	@frequency_recurrence_factor = 0,
	@frequency_subday = 0,
	@frequency_subday_interval = 0,
	@active_start_time_of_day = 0,
	@active_end_time_of_day = 235959,
	@active_start_date = 20071120,
	@active_end_date = 99991231
GO



--============================================
--============================================
-- 4. ������

--========================================
-- 1. �ڷ�����������ִ��
USE AdventureWorks
GO

DECLARE
	@publication_table_name sysname,
	@publication_name sysname,
	@subscriber_server sysname,
	@subscriber_db sysname

SELECT
	-- Ҫ�����ı���
	@publication_table_name = N'Person.Address',
	-- ����Ҫ�����ı����Զ����ɷ�������
	@publication_name = N'RP_' + DB_NAME() 
			+ N'.' + ISNULL(PARSENAME(@publication_table_name, 2), N'dbo')
			+ N'.' + PARSENAME(@publication_table_name, 1),
	@subscriber_db = DB_NAME(),           -- �������ݿ�����(�����뷢�����ݿ�һ��)
	@subscriber_server = N'SrvC'   -- ���ķ���������

-- a. ���������
EXEC sp_addsubscription 
	@publication = @publication_name,
	@subscriber = @subscriber_server,
	@destination_db = @subscriber_db,
	@subscription_type = N'pull',  -- ���ĵ�����(Push ���Ͷ���, Pull ������)
--	@sync_type = N'automatic',     -- ����ͬ������(automatic �ѷ�����ļܹ��ͳ�ʼ���ݽ����ȴ��䵽���ķ�����)
	@sync_type = N'replication support only',     -- ���ڶ��ķ����������ɷ�����Ŀ�Զ���洢���̺�֧�ָ��¶��ĵĴ�����(�ٶ����ķ������Ѿ������ѷ�����ļܹ��ͳ�ʼ����)
	@update_mode = N'read only'    -- ��������(read only ֻ��,���ķ������ĸ��²�����������������)
GO


--========================================
-- 2. �ڶ��ķ�������ִ��
USE AdventureWorks
GO

DECLARE
	@publication_table_name sysname,
	@publication_name sysname,
	@publication_server sysname,
	@publication_db sysname,
	@distributor_srver sysname

SELECT
	-- Ҫ�����ı���
	@publication_table_name = N'Person.Address',
	-- ����Ҫ�����ı����Զ����ɷ�������
	@publication_name = N'RP_' + DB_NAME() 
			+ N'.' + ISNULL(PARSENAME(@publication_table_name, 2), N'dbo')
			+ N'.' + PARSENAME(@publication_table_name, 1),
	@publication_db = DB_NAME(),    -- �������ݿ�����(�����붩�����ݿ�һ��)
	@publication_server = N'SrvA',  -- ��������������
	@distributor_srver = N'SrvB'    -- �ַ�����������

-- a. ���������
EXEC sp_addpullsubscription
	@publication = @publication_name,
	@publisher = @publication_server,
	@publisher_db = @publication_db,
	@subscription_type = N'pull',
	@update_mode = N'read only',
	@immediate_sync = 0

-- b. �����ַ�����
EXEC sp_addpullsubscription_agent
	@publication = @publication_name,
	@publisher = @publication_server,
	@publisher_db = @publication_db,
	@distributor = @distributor_srver,
	@distributor_security_mode = 1, -- ���ӷַ�������ʱ����ʹ�õİ�ȫģʽ(1.Windows�����֤)
	@job_login = null,              -- ���ӵ��ַ�������ʱ��ʹ�õĵ�¼��. @publisher_security_mode Ϊ0��,��Ҫָ���˲�����@job_password
	@job_password = null,
    -- ���²����������ִ�мƻ�
	@frequency_type = 64,
	@frequency_interval = 0,
	@frequency_relative_interval = 0,
	@frequency_recurrence_factor = 0,
	@frequency_subday = 0,
	@frequency_subday_interval = 0,
	@active_start_time_of_day = 0,
	@active_end_time_of_day = 235959,
	@active_start_date = 20071120,
	@active_end_date = 99991231
GO
