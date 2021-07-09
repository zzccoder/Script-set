--1. 执行字符串中的T-SQL
DECLARE @sql nvarchar(max)
SET @sql = N'SELECT * FROM sys.objects'
EXEC(@sql)

-- 2. 执行字符串中的存储过程
DECLARE 
	@ProcName sysname, @LoginName sysname
SELECT
	@ProcName = N'sys.sp_who',
	@LoginName =  SUSER_SNAME()
EXEC @ProcName 
	@loginame = @LoginName
