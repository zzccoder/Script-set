USE distribution
SELECT 
	DistributionDBName = DB_NAME(),
	PUB.distribution_agent,
	status = CASE HST.status
				WHEN 5 THEN N'ÖØÊÔ'
				WHEN 6 THEN N'´íÎó'
				ELSE RTRIM(HST.status)
			END,
	publisher = SRV.srvname,
	PUB.publisher_db,
	PUB.publication,
	subscriber = ISNULL(PUB.subscriber_name, (
						SELECT TOP 1 srvname FROM master.dbo.sysservers WITH(NOLOCK) 
						WHERE srvid = PUB.subscriber_id)),
	subscriber_db = CASE
			WHEN PUB.subscriber_name IS NULL THEN PUB.subscriber_db
			ELSE PUB.subscriber_db + '-' + CONVERT(nvarchar(12), PUB.agent_id) END,
    HST.start_time,
	HST.time,
	HST.duration,
	HST.comments,
	HST.delivery_time,
	HST.delivered_transactions,
	HST.delivered_commands,
	HST.average_commands,
	HST.delivery_rate,
	HST.delivery_latency,
	HST.error_id,
	PUB.profile_id,
	PUB.job_id, 
	PUB.local_job,
	PUB.agent_id,
	HST.last_timestamp,
	PUB.offload_enabled, 
	PUB.offload_server
FROM(
	SELECT 
		agent_id = id, distribution_agent = name, 
		publisher_id, publisher_db, publication, 
		subscriber_id, subscriber_db, subscription_type, subscriber_name,
		local_job, job_id,
		profile_id, offload_enabled, offload_server
	FROM dbo.MSdistribution_agents WITH(NOLOCK)
	WHERE (subscriber_id IS NULL OR subscriber_id >= 0)
		AND anonymous_agent_id IS NULL
)PUB
	INNER JOIN(
		SELECT
			agent_id = A.agent_id,
			status = A.runstatus,
			start_time = A.start_time,
			time = A.time,
			duration = duration, 
			comments = A.comments,
			delivery_time = 0, 
			delivered_transactions = A.delivered_transactions,
			delivered_commands = A.delivered_commands, 
			average_commands = A.average_commands,
			delivery_rate = A.delivery_rate,
			delivery_latency = A.delivery_latency,
			error_id = A.error_id, 
			last_timestamp = A.timestamp
		FROM dbo.MSdistribution_history A WITH(NOLOCK)
			INNER JOIN(
				SELECT
					agent_id, timestamp = MAX(timestamp)
				FROM dbo.MSdistribution_history WITH(NOLOCK)
				GROUP BY agent_id
			)B 
				ON A.timestamp= B.timestamp
					AND A.agent_id = B.agent_id
		WHERE A.runstatus IN(5, 6)
	)HST
		ON PUB.agent_id = HST.agent_id
	LEFT JOIN master.dbo.sysservers SRV WITH(NOLOCK)
		ON PUB.publisher_id = SRV.srvid
