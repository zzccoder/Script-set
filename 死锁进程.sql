
/*
USE [master]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[p_lockinfo]
		@kill_lock_spid = 1,
		@show_spid_if_nolock = 0

SELECT	'Return Value' = @return_value

GO

*/


SELECT    标志 = '死锁的进程' ,
	spid ,DB_NAME(a.dbid),Text,
	kpid , a.blocked , a.dbid , uid , loginame , cpu , login_time , open_tran , status , hostname , 
	program_name , hostprocess , nt_domain , net_address , sql_handle , s1 = a.spid , s2 = 0
FROM      master..sysprocesses a
        JOIN ( SELECT   blocked
                FROM     master..sysprocesses
                GROUP BY blocked
                ) b ON a.spid = b.blocked
				cross apply sys.dm_exec_sql_text(sql_handle) t  
WHERE     a.blocked = 0
--AND t.dbid= DB_ID('sinopecgdec')  --指定数据库
ORDER BY a.cpu DESC --按累计 cpu 时间排序从高到低

--sp_who_lock;

