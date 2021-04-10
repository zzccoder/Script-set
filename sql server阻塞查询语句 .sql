---查询阻塞
WITH    CTE_SID ( BSID, SID, sql_handle )
          AS ( SELECT   blocking_session_id ,
                        session_id ,
                        sql_handle
               FROM     sys.dm_exec_requests
               WHERE    blocking_session_id <> 0
               UNION ALL
               SELECT   A.blocking_session_id ,
                        A.session_id ,
                        A.sql_handle
               FROM     sys.dm_exec_requests A
                        JOIN CTE_SID B ON A.SESSION_ID = B.BSID
             )
    SELECT  C.BSID ,
            C.SID ,
            S.login_name ,
            S.host_name ,
            S.status ,
            S.cpu_time ,
            S.memory_usage ,
            S.last_request_start_time ,
            S.last_request_end_time ,
            S.logical_reads ,
            S.row_count ,
            q.text
    FROM    CTE_SID C 
            JOIN sys.dm_exec_sessions S ON C.sid = s.session_id
            CROSS APPLY sys.dm_exec_sql_text(C.sql_handle) Q
ORDER BY sid
 











select bl.spid blocking_session,bl.blocked blocked_session,st.text blockedtext from (SELECT   spid ,blocked
   FROM (SELECT * FROM sys.sysprocesses WHERE   blocked>0 ) a 
   WHERE not exists(SELECT * 
                    FROM (SELECT * 
                          FROM sys.sysprocesses 
                          WHERE   blocked>0 ) b 
                    WHERE a.blocked=spid)
   union SELECT spid,blocked 
         FROM sys.sysprocesses 
         WHERE   blocked>0) bl,(SELECT t.text ,c.session_id 
         FROM sys.dm_exec_connections c  
         CROSS APPLY sys.dm_exec_sql_text (c.most_recent_sql_handle) t) st
 where bl.blocked = st.session_id

 --语句二
SELECT a.blocking_session_id, a.wait_duration_ms, a.session_id,b.text
FROM sys.dm_os_waiting_tasks a,
(SELECT t.text ,c.session_id 
FROM sys.dm_exec_connections c  
CROSS APPLY sys.dm_exec_sql_text (c.most_recent_sql_handle) t) b  
WHERE  a.session_id = b.session_id and a.blocking_session_id IS NOT NULL


--语句三，包含阻塞与被阻塞的sql脚本
select bl.spid blocking_session,bl.blocked blocked_session,st.text blockedtext,sb.text blockingtext 
from 
(SELECT   spid ,blocked
   FROM (SELECT * FROM sys.sysprocesses WHERE   blocked>0 ) a 
   WHERE not exists(SELECT * 
                    FROM (SELECT * 
                          FROM sys.sysprocesses 
                          WHERE   blocked>0 ) b 
                    WHERE a.blocked=spid)
   union 
 SELECT spid,blocked 
         FROM sys.sysprocesses 
         WHERE   blocked>0) bl,
(SELECT t.text ,c.session_id 
         FROM sys.dm_exec_connections c  
         CROSS APPLY sys.dm_exec_sql_text (c.most_recent_sql_handle) t) st,
(SELECT t.text ,c.session_id 
         FROM sys.dm_exec_connections c  
         CROSS APPLY sys.dm_exec_sql_text (c.most_recent_sql_handle) t) sb
 where bl.blocked = st.session_id and bl.spid = sb.session_id
 
 --查询死锁
select *
   from master..SysProcesses
  where db_Name(dbID) = '数据库名'
    and spId <> @@SpId
    and dbID <> 0
    and blocked >0;