-- ������ʾ����
USE tempdb
GO

CREATE TABLE dbo.tb(
	type char(2),
	object_id int)
INSERT dbo.tb(
	object_id, type)
SELECT 
	object_id, type
FROM sys.objects
GO

-- ���������������ɱ��
CREATE INDEX IX_type_object_id
	ON dbo.tb(
		type, object_id)
GO

-- ����������������object_id
DECLARE
	@type char(2), @id int
UPDATE A SET
	@id = CASE type
			WHEN @type THEN @id + 1
			ELSE 1 END,
	@type = type,
	object_id = @id
FROM dbo.tb A WITH(INDEX(IX_type_object_id))

-- ��ʾ������
SELECT * FROM dbo.tb
GO

-- ɾ����ʾ����
DROP TABLE dbo.tb