DECLARE 
	@session_id smallint
SELECT
	@session_id = @@SPID

-- ��������ص�ǰִ�е�ȫ�� T-SQL ����
DBCC INPUTBUFFER(@session_id)

-- ���ֻ���ص�ǰ����ִ�е���һ�Σ�������������ѯ����
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