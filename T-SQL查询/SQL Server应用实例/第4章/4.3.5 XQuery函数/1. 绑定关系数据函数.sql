-- 1. ʹ�� sql:column ����
DECLARE @test xml
SET @test = ''

SELECT TOP 1
	@test = @test.query('<s>{sql:column("name")}</s>')
FROM sys.objects

SELECT @test
GO


-- 2. ʹ�� sql:variable ����
-- ���� xml ����
DECLARE @test xml
SET @test = (
		SELECT * FROM sys.objects OBJ
		FOR XML AUTO, TYPE, ROOT('OBJS')
	)

-- �� xml ���ݽ��в�ѯ
DECLARE 
	@column_name sysname,
	@row_no int

SELECT 
	@column_name = N'name',  -- ָ����ѯ������
	@row_no = 4              -- ָ����ѯ�ڼ���OBJ�ڵ�

SELECT @test
SELECT @test.value('(/OBJS/OBJ[sql:variable("@row_no")]/@*[local-name()=sql:variable("@column_name")])[1]', 'nvarchar(max)')