USE tempdb
GO

-- 用于记录DDL事件的表
CREATE TABLE dbo.tb_DDL_Event(
	id int IDENTITY PRIMARY KEY,
	Date datetime,
	Spid int,
	EventType sysname,
	SQLCommand nvarchar(max),
	EventData xml)
GO

-- DDL触发器, 通过 DDL_DATABASE_LEVEL_EVENTS 事件组,指定捕获当前库的所有的DDL事件
CREATE TRIGGER TR_DDL_Test
	ON DATABASE
FOR DDL_DATABASE_LEVEL_EVENTS
AS
	DECLARE @EventData xml
	SET @EventData = EVENTDATA()
	INSERT dbo.tb_DDL_Event(
		Date, Spid, EventType, SQLCommand, EventData)
	SELECT
		Date = T.c.value('(/EVENT_INSTANCE/PostTime)[1]', 'datetime'),
		Spid = T.c.value('(/EVENT_INSTANCE/SPID)[1]', 'int'),
		EventType = T.c.value('(/EVENT_INSTANCE/EventType)[1]', 'sysname'),
		SQLCommand = T.c.value('(/EVENT_INSTANCE//TSQLCommand/CommandText)[1]', 'sysname'),
		@EventData
	FROM @EventData.nodes('.') T(c)
GO

-- 测试触发器
CREATE TABLE dbo.tb_test(
	id int)
CREATE INDEX IX_id 
	ON dbo.tb_test(id)
SELECT * FROM dbo.tb_DDL_Event
GO

-- 删除演示环境
DROP TRIGGER TR_DDL_Test
	ON DATABASE
DROP TABLE dbo.tb_DDL_Event, dbo.tb_test
