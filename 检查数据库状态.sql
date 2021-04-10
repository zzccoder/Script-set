检查日志使用百分比、恢复模式和日志重用等待状态。
DBCC SQLPERF(LOGSPACE)  
GO  
SELECT name,recovery_model_desc,log_reuse_wait,log_reuse_wait_desc  
FROM sys.databases  
GO  

检查最久的活动事务：
SELECT  *  
FROM    sys.dm_exec_sessions AS t2,
        sys.dm_exec_connections AS t1  
        --CROSS APPLY sys.dm_exec_sql_text(t1.most_recent_sql_handle) AS st  
WHERE   t1.session_id = t2.session_id   
        AND t1.session_id > 50   and status='running' Order by login_time desc 
        ssion_id > 50  


当前请求连接：
SELECT * FROM sys.dm_exec_sessions WHERE host_name IS NOT NULL 

SELECT COUNT(*) AS CONNECTIONS FROM master..sysprocesses