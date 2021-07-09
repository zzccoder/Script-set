-- 建立演示环境
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

-- 创建索引辅助生成编号
CREATE INDEX IX_type_object_id
	ON dbo.tb(
		type, object_id)
GO

-- 利用索引重新生成object_id
DECLARE
	@type char(2), @id int
UPDATE A SET
	@id = CASE type
			WHEN @type THEN @id + 1
			ELSE 1 END,
	@type = type,
	object_id = @id
FROM dbo.tb A WITH(INDEX(IX_type_object_id))

-- 显示处理结果
SELECT * FROM dbo.tb
GO

-- 删除演示环境
DROP TABLE dbo.tb