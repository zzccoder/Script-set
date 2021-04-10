/***
* 不备份数据文件
* 收缩日志文件
* 11/17/2015
*/
 use WSS_Content_80
 declare @curSize float
 -- 当前日志文件大小
 set @curSize = (select convert(float,size) * (8192.0/1024.0)/1024. from WSS_Content_80.dbo.sysfiles where name= 'WSS_Content_80_log')
 -- 如果大于1GB* 80%，收缩操作
 if @curSize > 838860.8
 begin
	-- Truncate the log
	alter database WSS_Content_80
	set recovery SIMPLE;
	-- shrink the truncated log file
	dbcc shrinkfile('WSS_Content_80_log')
	-- reset the database recovery model
	alter database WSS_Content_80
	set recovery FULL;
 end

