select * from tempdb.dbo.sysfiles 

dump transaction tempdb with no_log 

dbcc shrinkfile ('templog',1) 

select * from tempdb.dbo.sysfiles