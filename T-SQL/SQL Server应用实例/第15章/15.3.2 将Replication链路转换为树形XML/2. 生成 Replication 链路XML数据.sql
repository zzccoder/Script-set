IF OBJECT_ID(N'dbo.f_Replication', 'Function') IS NOT NULL
	DROP FUNCTION dbo.f_Replication
GO

-- ���еĲ���Ϊ������Ƕ�׵�����ʹ�ã��û�����ʱȫ��ָ�� NULL ֵ
CREATE FUNCTION dbo.f_Replication(
	@subscriber_server sysname,
	@subscriber_database sysname,
	@subscriber_schema sysname,
	@subscriber_table sysname
) RETURNS xml
AS
BEGIN
	DECLARE @re xml
	;WITH 
	DATA AS(
		-- ���� Replication ��·��������
		SELECT *
		FROM dbo.tb_ReplicationInfo A
		WHERE @subscriber_server IS NULL
			AND NOT EXISTS(
					SELECT * FROM dbo.tb_ReplicationInfo
					WHERE subscriber_server = A.publisher_server
						AND subscriber_database = A.publisher_database
						AND (subscriber_schema = A.publisher_schema OR subscriber_schema IS NULL)
						AND subscriber_table = A.publisher_table)
		UNION ALL
		-- ָ�� Replication �����һ�㷢������
		SELECT *
		FROM dbo.tb_ReplicationInfo A
		WHERE @subscriber_server IS NOT NULL
			AND publisher_server = @subscriber_server
			AND publisher_database = @subscriber_database
			AND (publisher_schema = @subscriber_schema OR @subscriber_schema IS NULL)
			AND publisher_table = @subscriber_table
	),
	SRV AS(
		SELECT DISTINCT
			publisher_server
		FROM DATA
	),
	DB AS(
		SELECT DISTINCT
			publisher_server, publisher_database
		FROM DATA
	)
	SELECT @re = (
		SELECT 
			[@name] = publisher_server,
			[*] = B.db
		FROM SRV
			CROSS APPLY(
				-- �������ݿ⼶�� xml ��Ϣ
				SELECT DB = (
					SELECT 
						[@name] = publisher_database,
						[*] = C.ReplicationChain
					FROM DB
						CROSS APPLY(
							-- ����Դͷ��Ŀ���� xml ��Ϣ
							-- ͬʱ��������������һ����Replication��·xml����
							SELECT 
								ReplicationChain = (
									SELECT
										publisher_server 
											+ N'.' + publisher_database
											+ N'.' + publisher_schema
											+ N'.' + publisher_table
											+ N'->'
											+ subscriber_server
											+ N'.' + subscriber_database
											+ N'.' + ISNULL(subscriber_schema, publisher_schema)
											+ N'.' + subscriber_table,
										[*] = dbo.f_Replication(subscriber_server, subscriber_database, subscriber_schema, subscriber_table)
									FROM DATA
									WHERE publisher_server = DB.publisher_server
										AND publisher_database = DB.publisher_database
									FOR XML PATH('Replication'), TYPE
								)
						)C
					WHERE publisher_server = SRV.publisher_server
					FOR XML PATH('Database'), TYPE
				)
			)B
		FOR XML PATH('Server'), TYPE
	)
	RETURN(@re)
END
GO

-- ����ʾ��
SELECT 
	[@GeneraDate] = GETDATE(),
	dbo.f_Replication(NULL, NULL, NULL, NULL)
FOR XML PATH('Serers'), TYPE
