-- 1. �������ӷ�����
EXEC sp_addlinkedserver 'localhost\sql2000', 'SQL Server'
GO

-- 2. �����ӷ�������ִ�����, ����һ��������һЩ����
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

-- 3. ��ѯ��2�������ı��е�����
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

-- 4. �����������ʾ����
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