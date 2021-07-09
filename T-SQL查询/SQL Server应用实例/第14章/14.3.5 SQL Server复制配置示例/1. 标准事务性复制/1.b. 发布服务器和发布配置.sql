--=========================================================
-- 在发布服务器上执行
--=========================================================

--============================================
-- 1. 标记分发服务器
USE master
GO

EXEC sp_adddistributor
	@distributor = N'SrvB',  -- 分发服务器名称
	@password = N'abc.124'   -- distributor_admin 登录名的密码
GO


--============================================
-- 2. 将数据库标记为发布数据库
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
-- 3. 添加事务发布
USE AdventureWorks
GO

DECLARE
	@publication_table_name sysname,
	@publication_name sysname
	
SELECT
	-- 要发布的表名
	@publication_table_name = N'Person.Address',
	-- 根据要发布的表名自动生成发布名称
	@publication_name = N'RP_' + DB_NAME() 
			+ N'.' + ISNULL(PARSENAME(@publication_table_name, 2), N'dbo')
			+ N'.' + PARSENAME(@publication_table_name, 1)

-- a. 创建发布(新建的发布不包括任何项目,需要在后面的步骤中添加发布项目)
EXEC sp_addpublication 
	@publication = @publication_name,	
	@sync_method = N'concurrent',   -- 同步模式(生成所有表的本机模式大容量复制程序输出)
	@repl_freq = N'continuous',     -- 复制频率(continuous 发布服务器提供所有基于日志的事务的输出)
	@retention = 0,                 -- 订阅活动的保持期(0 订阅永不过期)
	@allow_push = N'true',          -- 允许建立推送订阅
	@allow_pull = N'true',          -- 允许建立请求订阅
	@allow_anonymous = N'false',    -- 不允许建立匿名订阅
	@status = N'active',            -- 发布数据可立即用于订阅服务器。
	@allow_sync_tran = N'false',    -- 指定是否允许对发布即时更新订阅
	@allow_queued_tran = N'false',  -- 在订阅服务器上启用或禁用更改的队列，直到可在发布服务器上应用这些更改为止
	@replicate_ddl = 1,             -- 指示该发布是否支持架构复制
	@enabled_for_p2p = N'false',    -- 是否允许将发布用于对等复制拓扑中
	@enabled_for_het_sub = N'false',-- 是否使发布支持非 SQL Server 订阅服务器
	@independent_agent = N'true'    -- 指定该发布是否有独立分发代理

-- b. 创建快照代理
DECLARE
	@active_start_date int,
	@active_start_time_of_day int
-- 设置快照代理在建立后 10 秒钟运行一次, 以便使初始化快照可用
SELECT
	@active_start_date = CONVERT(char(8), GETDATE(), 112),
	@active_start_time_of_day  = REPLACE(CONVERT(char(8), DATEADD(Second, 10, GETDATE()), 108), ':', '')
EXEC sp_addpublication_snapshot
	@publication = @publication_name,
	@publisher_security_mode = 1, -- 连接发布服务器时代理使用的安全模式(1.Windows身份验证)
	@job_login = null,            -- 连接到发布服务器时所使用的登录名. @publisher_security_mode 为0是,需要指定此参数及@job_password
	@job_password = null,
    -- 以下部分定义代理执行计划
	@frequency_type = 1,
	@frequency_interval = 1,
	@frequency_relative_interval = 1,
	@frequency_recurrence_factor = 0,
	@active_start_date = @active_start_date,
	@active_start_time_of_day = @active_start_time_of_day

-- c. 在发布中添加发布项目(表/视图/存储过程/用户定义函数)
DECLARE
	@schema_name sysname,
	@object_name sysname,
	@ins_cmd nvarchar(255),
	@del_cmd nvarchar(255),
	@upd_cmd nvarchar(255)

-- 根据发布表名自动生成添加发布需要的一些信息
SELECT
	@schema_name = ISNULL(PARSENAME(@publication_table_name, 2), N'dbo'),
	@object_name = PARSENAME(@publication_table_name, 1),
	@ins_cmd = N'CALL sp_MSins_' + @schema_name + @object_name,
	@del_cmd = N'CALL sp_MSdel_' + @schema_name + @object_name,
	@upd_cmd = N'SCALL sp_MSupd_' + @schema_name + @object_name

EXEC sp_addarticle
	@publication = @publication_name,
	@article = @object_name,         -- 项目名称
	@source_owner = @schema_name,    -- 发布对象的架构名称
	@source_object = @object_name,   -- 发布对象名称
	@type = N'logbased',             -- 发布项目类型
	@pre_creation_cmd = N'none',     -- 应用快照时, 订阅服务器存在订阅表时的处理方式(none保持已经存在的订阅表,不做处理)
	@schema_option = 0x000000000803509F,        -- 给定项目的架构生成选项的位掩码
	@identityrangemanagementoption = N'manual', -- 指定如何处理项目的标识范围管理
	@destination_owner = @schema_name,  -- 订阅表架构名称
	@destination_table = @object_name,  -- 订阅表名称
	@vertical_partition = N'false',     -- 启用或禁用对表项目的列筛选
	@ins_cmd = @ins_cmd,
	@del_cmd = @del_cmd,
	@upd_cmd = @upd_cmd
GO


--============================================
-- 4. 订阅
-- 可在推送订阅和请求订阅两种方式中任选一种
--============================================
-- 推送订阅
-- 4. 添加订阅
USE AdventureWorks
GO

DECLARE
	@publication_table_name sysname,
	@publication_name sysname,
	@subscriber_server sysname,
	@subscriber_db sysname

SELECT
	-- 要发布的表名
	@publication_table_name = N'Person.Address',
	-- 根据要发布的表名自动生成发布名称
	@publication_name = N'RP_' + DB_NAME() 
			+ N'.' + ISNULL(PARSENAME(@publication_table_name, 2), N'dbo')
			+ N'.' + PARSENAME(@publication_table_name, 1),
	@subscriber_db = DB_NAME(),           -- 订阅数据库名称(假设与发布数据库一致)
	@subscriber_server = N'SrvC'          -- 订阅服务器名称

-- a. 添加订阅
EXEC sp_addsubscription 
	@publication = @publication_name,
	@subscriber = @subscriber_server,
	@destination_db = @subscriber_db,
	@subscription_type = N'Push',  -- 订阅的类型(Push 推送订阅, Pull 请求订阅)
--	@sync_type = N'automatic',     -- 订阅同步类型(automatic 已发布表的架构和初始数据将首先传输到订阅服务器)
	@sync_type = N'replication support only',     -- 仅在订阅服务器上生成发布项目自定义存储过程和支持更新订阅的触发器(假定订阅服务器已经具有已发布表的架构和初始数据)
	@article = N'all',             -- 订阅的项目, all 表示订阅所有项目(包括以后在此发布中新增的项目)
	@update_mode = N'read only'    -- 更新类型(read only 只读,订阅服务器的更新不传播到发布服务器)

-- b. 创建分发代理
EXEC sp_addpushsubscription_agent 
	@publication = @publication_name,
	@subscriber = @subscriber_server,
	@subscriber_db = @subscriber_db,
	@subscriber_security_mode = 1, -- 连接到订阅服务器所使用的安全模式(1.Windows身份验证)
	@job_login = null,            -- 连接到订阅服务器时所使用的登录名. @subscriber_security_mode 为0是,需要指定此参数及@job_password
	@job_password = null,
    -- 以下参数定义代理执行计划
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
-- 4. 请求订阅

--========================================
-- 1. 在发布服务器上执行
USE AdventureWorks
GO

DECLARE
	@publication_table_name sysname,
	@publication_name sysname,
	@subscriber_server sysname,
	@subscriber_db sysname

SELECT
	-- 要发布的表名
	@publication_table_name = N'Person.Address',
	-- 根据要发布的表名自动生成发布名称
	@publication_name = N'RP_' + DB_NAME() 
			+ N'.' + ISNULL(PARSENAME(@publication_table_name, 2), N'dbo')
			+ N'.' + PARSENAME(@publication_table_name, 1),
	@subscriber_db = DB_NAME(),           -- 订阅数据库名称(假设与发布数据库一致)
	@subscriber_server = N'SrvC'   -- 订阅服务器名称

-- a. 添加请求订阅
EXEC sp_addsubscription 
	@publication = @publication_name,
	@subscriber = @subscriber_server,
	@destination_db = @subscriber_db,
	@subscription_type = N'pull',  -- 订阅的类型(Push 推送订阅, Pull 请求订阅)
--	@sync_type = N'automatic',     -- 订阅同步类型(automatic 已发布表的架构和初始数据将首先传输到订阅服务器)
	@sync_type = N'replication support only',     -- 仅在订阅服务器上生成发布项目自定义存储过程和支持更新订阅的触发器(假定订阅服务器已经具有已发布表的架构和初始数据)
	@update_mode = N'read only'    -- 更新类型(read only 只读,订阅服务器的更新不传播到发布服务器)
GO


--========================================
-- 2. 在订阅服务器上执行
USE AdventureWorks
GO

DECLARE
	@publication_table_name sysname,
	@publication_name sysname,
	@publication_server sysname,
	@publication_db sysname,
	@distributor_srver sysname

SELECT
	-- 要发布的表名
	@publication_table_name = N'Person.Address',
	-- 根据要发布的表名自动生成发布名称
	@publication_name = N'RP_' + DB_NAME() 
			+ N'.' + ISNULL(PARSENAME(@publication_table_name, 2), N'dbo')
			+ N'.' + PARSENAME(@publication_table_name, 1),
	@publication_db = DB_NAME(),    -- 发布数据库名称(假设与订阅数据库一致)
	@publication_server = N'SrvA',  -- 发布服务器名称
	@distributor_srver = N'SrvB'    -- 分发服务器名称

-- a. 添加请求订阅
EXEC sp_addpullsubscription
	@publication = @publication_name,
	@publisher = @publication_server,
	@publisher_db = @publication_db,
	@subscription_type = N'pull',
	@update_mode = N'read only',
	@immediate_sync = 0

-- b. 创建分发代理
EXEC sp_addpullsubscription_agent
	@publication = @publication_name,
	@publisher = @publication_server,
	@publisher_db = @publication_db,
	@distributor = @distributor_srver,
	@distributor_security_mode = 1, -- 连接分发服务器时代理使用的安全模式(1.Windows身份验证)
	@job_login = null,              -- 连接到分发服务器时所使用的登录名. @publisher_security_mode 为0是,需要指定此参数及@job_password
	@job_password = null,
    -- 以下参数定义代理执行计划
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
