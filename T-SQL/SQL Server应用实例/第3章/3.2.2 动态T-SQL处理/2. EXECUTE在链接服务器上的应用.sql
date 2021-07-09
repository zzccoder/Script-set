-- 1. 定义链接服务器
EXEC sp_addlinkedserver 'localhost\sql2000', 'SQL Server'
GO

-- 2. 在链接服务器上执行语句, 创建一个表并插入一些数据
DECLARE @sql nvarchar(max)
SET @sql = N'
USE tempdb
CREATE TABLE tb(
	id int)
INSERT tb
SELECT 1 UNION ALL
SELECT 2
'
EXEC(@sql)
	AT [localhost\sql2000]
GO

-- 3. 查询第2步创建的表中的数据
DECLARE 
	@sql nvarchar(max),
	@id int
SELECT
	@id = 1,
	@sql = N'
USE tempdb
SELECT * FROM tb
WHERE id = ?
'
EXEC(@sql, @id)
	AT [localhost\sql2000]
GO

-- 4. 清除创建的演示环境
DECLARE @sql nvarchar(max)
SET @sql = N'
USE tempdb
DROP TABLE tb
'
EXEC(@sql)
	AT [localhost\sql2000]

EXEC sp_dropserver 
	@server = N'localhost\sql2000',
	@droplogins = 'droplogins'