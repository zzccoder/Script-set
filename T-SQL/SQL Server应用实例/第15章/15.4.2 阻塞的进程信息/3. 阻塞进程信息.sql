-- ===========================================
-- 获取阻塞的 session_id 及阻塞时间
DECLARE @tb_block TABLE(
	top_blocking_session_id smallint,
	session_id smallint,
	blocking_session_id smallint,
	wait_time int,
	Level int,
	blocking_path varchar(8000),
	PRIMARY KEY(
		session_id, blocking_session_id)
)
INSERT @tb_block(
	session_id,
	blocking_session_id,
	wait_time)
SELECT
	session_id,
	blocking_session_id,
	wait_time = MAX(wait_time)
FROM sys.dm_exec_requests
WHERE blocking_session_id > 0
GROUP BY session_id, blocking_session_id

-- ===========================================
-- 处理阻塞的 session_id 之间的关系
DECLARE
	@Level int
SET @Level = 1

INSERT @tb_block(
	session_id, top_blocking_session_id, blocking_session_id,
	Level, blocking_path)
SELECT DISTINCT
	blocking_session_id, blocking_session_id, 0,
	@Level, RIGHT(100000 + blocking_session_id, 5)
FROM @tb_block A
WHERE NOT EXISTS(
		SELECT * FROM @tb_block
		WHERE session_id = A.blocking_session_id)
WHILE @@ROWCOUNT > 0
BEGIN
	SET @Level = @Level + 1
	UPDATE A SET
		top_blocking_session_id = B.top_blocking_session_id,
		Level = @Level,
		blocking_path = B.blocking_path 
			+ RIGHT(100000 + A.session_id, 5)
	FROM @tb_block A, @tb_block B
	WHERE A.blocking_session_id = B.session_id
		AND B.Level = @Level - 1
END

-- ===========================================
-- 如果只要显示阻塞时间超过多少毫秒的记录，可以在这里做一个过滤
-- 这里假设阻塞时间必须超过 1 秒钟(1000毫秒)
DELETE A 
FROM @tb_block A
WHERE NOT EXISTS(
		SELECT * FROM @tb_block
		WHERE top_blocking_session_id =A.top_blocking_session_id
			AND wait_time >= 1000)

-- ===========================================
-- 使用 DBCC INPUTBUFFER 获取阻塞进程的 T-SQL 脚本
DECLARE @tb_block_sql TABLE(
	id int IDENTITY,
	EventType nvarchar(30),
	Parameters int,
	EventInfo nvarchar(4000),
	session_id smallint)
DECLARE
	@session_id smallint
DECLARE tb CURSOR LOCAL STATIC FORWARD_ONLY READ_ONLY
FOR
SELECT DISTINCT
	session_id
FROM @tb_block
OPEN tb
FETCH tb INTO @session_id
WHILE @@FETCH_STATUS = 0
BEGIN
	INSERT @tb_block_sql(
		EventType, Parameters, EventInfo)
	EXEC(N'DBCC INPUTBUFFER(' + @session_id + ') WITH NO_INFOMSGS')
	IF @@ROWCOUNT > 0
		UPDATE @tb_block_sql SET
			session_id = @session_id
		WHERE IDENTITYCOL = @@IDENTITY

	FETCH tb INTO @session_id
END
CLOSE tb
DEALLOCATE tb

-- ===========================================
-- 显示阻塞进程信息
;WITH
BLK AS(
	SELECT
		A.top_blocking_session_id,
		A.session_id,
		A.blocking_session_id,
		A.Level,
		A.blocking_path,
		SQL = B.EventInfo
	FROM @tb_block A
		LEFT JOIN @tb_block_sql B
			ON A.session_id = B.session_id
)
SELECT
--	BlockPath = REPLICATE(' ', Level * 2 - 2)
--			+ '|-- '
--			+ RTRIM(session_id),
	BLK.top_blocking_session_id,
	BLK.session_id,
	BLK.blocking_session_id,
	BLK.Level,
	wait_type = P.waittype,
	wait_time = P.waittime,
	last_wait_type = P.lastwaittype,
	wait_resource = P.waitresource,
	P.login_time,
	P.last_batch,
	P.open_tran,
	P.status,
	host_name = P.hostname,
	P.program_name,
	P.cmd,
	login_name = P.loginame,
	BLK.SQL,
	current_sql = T.text,
	current_run_sql = SUBSTRING(T.text,
			P.stmt_start / 2 + 1,
			CASE
				WHEN P.stmt_end = -1 THEN LEN(T.text)
				ELSE (P.stmt_end - P.stmt_start) / 2+1
			END)
FROM BLK
	-- 简省代码起见，直接引用 sysprocess, 读者可以改为引用前述介绍的“查询进程"的脚本进行替换
	INNER JOIN master.dbo.sysprocesses P
		ON BLK.session_id = P.spid
	OUTER APPLY sys.dm_exec_sql_text(P.sql_handle) T
ORDER BY BLK.top_blocking_session_id, BLK.blocking_path
