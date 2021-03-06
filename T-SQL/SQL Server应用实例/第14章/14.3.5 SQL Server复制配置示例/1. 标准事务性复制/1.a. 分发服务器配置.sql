--=========================================================
-- 在分发服务器上执行
--=========================================================
USE master
GO

--============================================
-- 1. 将服务器标记为分发服务器
DECLARE
	@server_name sysname
SELECT
	@server_name = @@SERVERNAME

EXEC sp_adddistributor
	@distributor = @server_name,
	@password = N'abc.124'     -- distributor_admin 登录名的密码
GO

--============================================
-- 2. 创建新的分发数据库并安装分发服务器架构
EXEC sp_adddistributiondb
	@database = N'distribution',
	@min_distretention = 0,    -- 事务从分发数据库中删除前的最小保持期（小时）
	@max_distretention = 72,   -- 事务删除前的最大保持期（小时）
	@history_retention = 48,   -- 保留历史记录的小时数
	@security_mode = 1,        -- 连接到分发服务器时使用的安全模式。0=SQL Server身份验证；1=Windows集成身份验证
	@login = NULL,             -- 连接到分发服务器的登录名,如果 @security_mode 设置为0,则需要此参数及@password
	@password = NULL
GO


--============================================
-- 3. 注册发布服务器以使用指定的分发数据库
EXEC sp_adddistpublisher
	@publisher = N'SrvA',             -- 发布服务器名称
	@distribution_db = N'distribution', 
	@security_mode = 1,               -- 所实现的安全模式。该参数仅供复制代理用于连接到排队更新订阅的发布服务器或非 SQL Server 发布服务器
--	@login = N'login',                -- 登录名, security_mode 为 0 时需提供此参数以连接到发布服务器
--	@password = N'password'           -- 登录密码, security_mode 为 0 时需提供此参数以连接到发布服务器
--	@working_directory = N'c:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\ReplData', 
	                                  -- 用来存储发布的数据和架构文件的工作目录的名称, 默认值为该 SQL Server 实例的 ReplData 文件夹
	@thirdparty_flag = 0,             -- 发布服务器是否不是 SQL Server, 0 是, 1 不是
	@publisher_type = N'MSSQLSERVER'  -- 发布服务器类型(MSSQLSERVER, ORACLE, ORACLE GATEWAY)
GO
