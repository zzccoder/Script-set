
查正在运行的进程信息：
select * from  master..sysprocesses
where DB_NAME(dbid)='reserve'
and spid<>@@SPID 
and spid<>0
and loginame='val456' 
order by login_time desc


查当前会话：
select * from sys.dm_exec_sessions where login_name='val456' and status='sleeping'
exec ('Kill 58 ')