-- 创建 Replication 测试数据
USE tempdb
GO

IF OBJECT_ID(N'dbo.tb_ReplicationInfo', N'Table') IS NOT NULL
	DROP TABLE dbo.tb_ReplicationInfo
GO

CREATE TABLE dbo.tb_ReplicationInfo(
	publication_id int NOT NULL,
	publication_name sysname NOT NULL,
	publication_type int NOT NULL,
	publisher_server sysname NOT NULL,
	publisher_database sysname NULL,
	publisher_schema sysname NULL,
	publisher_table sysname NULL,
	subscription_type int NULL,
	subscriber_server sysname NOT NULL,
	subscriber_database sysname NULL,
	subscriber_schema sysname NULL,
	subscriber_table sysname NULL,
	distributor_server sysname NULL
)
GO

-- 测试数据
INSERT INTO dbo.tb_ReplicationInfo(
	publication_id, publication_name, publication_type,
	publisher_server, publisher_database, publisher_schema, publisher_table,
	subscription_type,
	subscriber_server, subscriber_database, subscriber_schema, subscriber_table,
	distributor_server)
SELECT 
	1, '', 1,
	N'ServerA', 'DatabaseA', 'dbo', 'tb1',
	1,
	'ServerB', 'DatabaseB', 'dbo', 'tb1',
	'distributor_server'
UNION ALL
SELECT 
	1, '', 1,
	N'ServerA', 'DatabaseA', 'dbo', 'tb1',
	1,
	'ServerB', 'DatabaseB', 'dbo', 'tb2',
	'distributor_server'
UNION ALL
SELECT 
	1, '', 1,
	N'ServerB', 'DatabaseB', 'dbo', 'tb1',
	1,
	'ServerC', 'DatabaseC', 'dbo', 'tb1',
	'distributor_server'
UNION ALL
SELECT 
	1, '', 1,
	N'ServerC', 'DatabaseC', 'dbo', 'tb1',
	1,
	'ServerC', 'DatabaseC', 'dbo', 'tb3',
	'distributor_server'
UNION ALL
SELECT 
	1, '', 1,
	N'ServerA', 'DatabaseA', 'dbo', 'tb1',
	1,
	'ServerD', 'DatabaseD', 'dbo', 'tb2',
	'distributor_server'
UNION ALL
SELECT 
	1, '', 1,
	N'ServerB', 'DatabaseB', 'dbo', 'tb',
	1,
	'ServerC', 'DatabaseC', 'dbo', 'tb',
	'distributor_server'
GO
