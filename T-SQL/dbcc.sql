use master 
declare @databasename varchar(255) 
set @databasename='��Ҫ�޸������ݿ�ʵ�������' 
exec sp_dboption @databasename, N'single', N'true' --��Ŀ�����ݿ���Ϊ���û�״̬ 

dbcc checkdb(@databasename,REPAIR_ALLOW_DATA_LOSS) 

dbcc checkdb(@databasename,REPAIR_REBUILD) 
exec sp_dboption @databasename, N'single', N'false'--��Ŀ�����ݿ���Ϊ���û�״̬ 