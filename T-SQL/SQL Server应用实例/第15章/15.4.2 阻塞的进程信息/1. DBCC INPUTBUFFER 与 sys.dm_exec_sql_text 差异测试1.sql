DECLARE 
	@session_id smallint
SELECT
	@session_id = @@SPID

-- 这个将返回当前执行的全部 T-SQL 编码
DBCC INPUTBUFFER(@session_id)

-- 这个只返回当前正在执行的这一段，即下面的这个查询部分
SELECT 
	current_sql = SUBSTRING(T.text,
			R.statement_start_offset / 2 + 1,
			CASE
				WHEN statement_end_offset = -1 THEN LEN(T.text)
				ELSE (R.statement_end_offset - statement_start_offset) / 2+1
			END)
FROM sys.dm_exec_requests R
	OUTER APPLY sys.dm_exec_sql_text(R.sql_handle) T
WHERE R.session_id = @session_id