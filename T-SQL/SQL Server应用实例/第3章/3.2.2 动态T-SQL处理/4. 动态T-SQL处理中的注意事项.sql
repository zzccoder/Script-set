-- 1. ��̬T-SQL�����е�������������
DECLARE @value int
SET @value = 100

DECLARE @sql varchar(8000)
SET @sql='SELECT * FROM tbname WHERE col=' + @value
EXEC(@sql)
GO

-- 2. ��̬T-SQL�����е��ַ����߽��������
--    a. ��Ҫ��ȷʹ���ַ����߽��
DECLARE @value varchar(10)
SET @value = 'aa'

DECLARE 
	@sql1 varchar(8000),
	@sql2 varchar(8000),
	@sql3 varchar(8000)

-- δʹ���ַ����߽��
SET @sql1 = 'SELECT * FROM tbname WHERE col1=' + @value

-- ȱ���ַ����߽��
SET @sql2 = 'SELECT * FROM tbname WHERE col1='' + @value + '

-- ��ȷ�Ĵ���ƴ�ӷ���
SET @sql3 = 'SELECT * FROM tbname WHERE col1=''' + @value + ''''
GO

--    b. ��Ҫע���ַ����б���������ַ����߽��
DECLARE @value varchar(10)
SELECT @value = 'a''a'

DECLARE @sql varchar(8000)
-- δ�����ַ����б���������ַ����߽��
SET @sql = 'SELECT * FROM tbname WHERE col=''' + @value + ''''
EXEC(@sql)

-- ��ȷ�����ַ����б���������ַ����߽��
SET @sql = 'SELECT * FROM tbname WHERE col=''' 
		+ REPLACE(@value, '''', '''''') + ''''
EXEC(@sql)
GO

-- 3. �����еĶ�����
--    a. ֱ�����ñ���
DECLARE @tbname sysname
SET @tbname = 'sysobjects'
SELECT * FROM @tbname

-- ��ȷ�ķ���
EXEC('SELECT * FROM ' + @tbname)
GO

--    b. sp_executesql���׷��Ĵ���: ������������
DECLARE @tbname sysname
SET @tbname = 'sysobjects'
EXEC sp_executesql
	N'SELECT * FROM @tbname',
	N'@tbname sysname',
	@tbname
GO

-- 4. ��̬T-SQL�����еĲ�������
DECLARE 
	@tbname sysname, @sql varchar(100), @sqlN nvarchar(4000)

-- ��ͼ�������ⲿ����ı���
SET @sql = 'SELECT TOP 1 @tbname = name FROM sys.objects'
EXEC(@sql)
SELECT @tbname

-- ��ȷ�ķ���
SET @sqlN = N'SELECT TOP 1 @tbname = name FROM sys.objects'
EXEC sp_executesql 
	@sqlN,
	N'@tbname sysname OUTPUT',
	@tbname OUTPUT
SELECT @tbname
GO

-- 5. QUOTENAME�ڶ�̬T-SQL�����е�Ӧ��
DECLARE 
	@tbname sysname,@value varchar(10),@date datetime

SELECT 
	@tbname = 'tb name''s',
	@value = 'a''b',
	@date = GETDATE()
DECLARE @sql varchar(4000)
SET @sql = 'SELECT * FROM ' + QUOTENAME(@tbname)
	+ ' WHERE col1 = ' + QUOTENAME(@value, '''')
	+ ' AND col2 = '+QUOTENAME(@date, '''')
EXEC(@sql)
