USE tempdb
GO

-- ���ڼ�¼DDL�¼��ı�
CREATE TABLE dbo.tb_DDL_Event(
	id int IDENTITY PRIMARY KEY,
	Date datetime,
	Spid int,
	EventType sysname,
	SQLCommand nvarchar(max),
	EventData xml)
GO

-- DDL������, ͨ�� DDL_DATABASE_LEVEL_EVENTS �¼���,ָ������ǰ������е�DDL�¼�
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

-- ���Դ�����
CREATE TABLE dbo.tb_test(
	id int)
CREATE INDEX IX_id 
	ON dbo.tb_test(id)
SELECT * FROM dbo.tb_DDL_Event
GO

-- ɾ����ʾ����
DROP TRIGGER TR_DDL_Test
	ON DATABASE
DROP TABLE dbo.tb_DDL_Event, dbo.tb_test
