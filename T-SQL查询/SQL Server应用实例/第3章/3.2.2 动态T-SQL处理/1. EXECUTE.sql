--1. ִ���ַ����е�T-SQL
DECLARE @sql nvarchar(max)
SET @sql = N'SELECT * FROM sys.objects'
EXEC(@sql)

-- 2. ִ���ַ����еĴ洢����
DECLARE 
	@ProcName sysname, @LoginName sysname
SELECT
	@ProcName = N'sys.sp_who',
	@LoginName =  SUSER_SNAME()
EXEC @ProcName 
	@loginame = @LoginName
