USE [master]
GO
--ALTER DATABASE [BJ_Content_10] MODIFY FILE ( NAME = N'BJ_Content_10_log', MAXSIZE = 1073741824KB )
GO



DECLARE @sql NVARCHAR(500)  
DECLARE @dbname NVARCHAR(200)  
DECLARE @ldfname NVARCHAR(200)  
DECLARE @count NVARCHAR(10)  
DECLARE @n int  
SET @n=1 
WHILE @n<101
 BEGIN   
  SET @count=LTRIM(STR(@n))  
  SET @dbname='GD_Content_'+ @count  
  SET @ldfname='GD_Content_' + @count + '_log'
  SET @sql= 'ALTER DATABASE '+@dbname+' MODIFY FILE ( NAME = '''+@ldfname+''', MAXSIZE = 1073741824KB )'
  EXEC(@sql) 
  SET @n=@n+1  
 END
go