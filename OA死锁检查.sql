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


