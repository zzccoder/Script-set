-- 1. 创建一个演示用的数据库(主数据库)
CREATE DATABASE db_test
ON(
	NAME = db_test_DATA,
	FILENAME = 'c:\db_test.mdf')
LOG ON (
	NAME = db_test_LOG,
	FILENAME = 'c:\db_test.ldf')
GO


-- 2. 初始化备用数据库
--    a. 对数据库进行备份
BACKUP DATABASE db_test
TO DISK = 'c:\db_test.bak'
WITH FORMAT
GO

--    b. 在备用服务器上还原主数据库备份
--       在本示例中，主数据库和备用数据库在同一个实例下
RESTORE DATABASE db_test_bak 
FROM DISK = 'c:\db_test.bak' 
WITH REPLACE,
	STANDBY = 'c:\db_test_redo.bak',
	MOVE 'db_test_DATA' TO 'c:\db_test_bak.mdf',
	MOVE 'db_test_LOG' TO 'c:\db_test_bak.ldf'
GO


-- 3. 同步主数据库与备用数据库
--    a. 启动 SQL Agent 服务
DECLARE @tb_AgentStatus TABLE(
	status varchar(50))
INSERT @tb_AgentStatus 
EXEC master.dbo.xp_servicecontrol N'QUERYSTATE', N'SQLSERVERAGENT'
IF NOT EXISTS(
		SELECT * FROM @tb_AgentStatus
		WHERE status = 'Running.')
	EXEC master.dbo.xp_servicecontrol N'START', N'SQLSERVERAGENT'
GO

--    b. 创建主服务器数据库与备用服务器数据库之间同步的作业
--       实际应用时，主数据库/备用数据库一般在不同实例, 则应该在主服务器上建立备份的作业，备用服务器上建立还原的作业, 并且备份文件应该放在主服务器和备用都能访问的共享目录中
DECLARE
	@job_id uniqueidentifier
EXEC msdb.dbo.sp_add_job
	@job_id = @job_id OUTPUT,
	@job_name = N'_数据同步处理测试'

-- 创建同步处理步骤
EXEC msdb..sp_add_jobstep 
	@job_id = @job_id,
	@step_name = N'数据同步',
	@subsystem = 'TSQL',
	@command = N'
-- 主数据库中进行日志备份
BACKUP LOG db_test
TO DISK = N''c:\db_test_log.bak''
WITH FORMAT

-- 备用数据库中还原主数据库的日志备份(应用主数据库中的最新变化
RESTORE LOG db_test_bak
FROM DISK = N''c:\db_test_log.bak''
WITH STANDBY = N''c:\db_test_redo.bak''
',
	@retry_attempts = 5,
	@retry_interval = 1

-- 创建调度(每分钟执行一次)
EXEC msdb.dbo.sp_add_jobschedule
	@job_id = @job_id,
	@name = N'时间安排',
	@freq_type = 4,
	@freq_interval = 1,
	@freq_subday_type = 0x4,
	@freq_subday_interval = 1,
	@freq_recurrence_factor = 1

-- 添加目标服务器
EXEC msdb.dbo.sp_add_jobserver 
	@job_id = @job_id,
	@server_name = N'(local)' 
GO

-- 4. 测试同步是否实现
--    通过上述处理,主数据库与备用数据库之间的同步关系已经设置完成
--    下面开始测试是否能实现同步

--    a.在主数据库中创建一个测试用的表
CREATE TABLE db_test.dbo.tb_test(
	ID int)
GO

--    b. 等待2分钟（由于同步的时间间隔设置为1分钟,所以要延时才能看到效果）
WAITFOR DELAY '00:02:30'
GO

--    c. 查询一下备用数据库,看看同步是否成功
SELECT * FROM db_test_bak.dbo.tb_test
/*--结果如下，说明测试成功
ID
-----------

(0 行受影响)
--*/
GO

--最后删除所有的测试
EXEC msdb.dbo.sp_delete_job
	@job_name = N'_数据同步处理测试'
DROP DATABASE db_test, db_test_bak
