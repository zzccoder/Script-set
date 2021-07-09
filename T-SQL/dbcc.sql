use master 
declare @databasename varchar(255) 
set @databasename='需要修复的数据库实体的名称' 
exec sp_dboption @databasename, N'single', N'true' --将目标数据库置为单用户状态 

dbcc checkdb(@databasename,REPAIR_ALLOW_DATA_LOSS) 

dbcc checkdb(@databasename,REPAIR_REBUILD) 
exec sp_dboption @databasename, N'single', N'false'--将目标数据库置为多用户状态 