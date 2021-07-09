-- 只能在分发服务器上执行
-- 切换到分发数据库
USE Distribution
GO

WITH
PUB AS(
	-- 此部分为发布及发布表信息
	SELECT
		publication_id = PUB.publication_id,
		publication_name = PUB.publication,
		publication_type = PUB.publication_type,

		PUB.publisher_id,
		publisher_database = PUB.publisher_db,

		article_id = ART.article_id,
		publisher_schema = ART.source_owner,
		publisher_table = ART.source_object,
		subscriber_schema = ART.destination_owner,
		subscriber_table = ART.destination_object
	FROM dbo.MSpublications PUB
		INNER JOIN dbo.MsArticles ART
			ON PUB.publication_id = ART.publication_id
),
SUB_TS AS(
	-- 此部分为事务和快照复制的信息
	SELECT
		PUB.publication_id,
		PUB.publication_name,
		PUB.publication_type,

		PUB.publisher_id,
		PUB.publisher_database,
		PUB.publisher_schema,
		PUB.publisher_table,

		SUB.subscription_type,
		SUB.subscriber_id,
		subscriber_database = SUB.subscriber_db,
		PUB.subscriber_schema,
		PUB.subscriber_table
	FROM PUB
		INNER JOIN dbo.MSsubscriptions SUB
			ON PUB.publication_id = SUB.publication_id
				AND PUB.article_id = SUB.article_id
),
SUB_M AS(
	-- 此部分为合并复制的信息
	SELECT
		PUB.publication_id,
		PUB.publication_name,
		PUB.publication_type,

		PUB.publisher_id,
		PUB.publisher_database,
		PUB.publisher_schema,
		PUB.publisher_table,

		SUB.subscription_type,
		SUB.subscriber_id,
		subscriber_database = SUB.subscriber_db,
		PUB.subscriber_schema,
		PUB.subscriber_table
	FROM PUB
		INNER JOIN dbo.MSmerge_subscriptions SUB
			ON PUB.publication_id = SUB.publication_id
),
REPL AS(
	SELECT * FROM SUB_TS
	UNION ALL
	SELECT * FROM SUB_M
),
REPL_RE AS(
	SELECT
		REPL.publication_id,
		REPL.publication_name,
		REPL.publication_type,

		publisher_server = PSRV.name,
		REPL.publisher_database,
		REPL.publisher_schema,
		REPL.publisher_table,

		REPL.subscription_type,
		subscriber_server = SSRV.name, 
		REPL.subscriber_database,
		REPL.subscriber_schema,
		REPL.subscriber_table,

		distributor_server = CONVERT(sysname, SERVERPROPERTY(N'ServerName'))
	FROM REPL
		INNER JOIN sys.servers PSRV
			ON REPL.publisher_id = PSRV.server_id
		INNER JOIN sys.servers SSRV
			ON REPL.subscriber_id = SSRV.server_id
)
SELECT * FROM REPL_RE
ORDER BY publisher_server, publisher_database, publisher_schema, publisher_table
