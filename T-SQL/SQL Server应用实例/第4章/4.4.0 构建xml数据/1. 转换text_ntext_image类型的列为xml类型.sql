-- 建立测试环境, 使用 text/ntext/image 类型的列存储xml数据
CREATE TABLE #t(
	col1 text,
	col2 ntext,
	col3 image)
INSERT #t(
	col1,
	col2,
	col3)
VALUES(
	'<r />',
	N'<r>测试</r>',
	CONVERT(varbinary(8000), N'<r>image列</r>'))
GO

-- 将 text/ntext 列的类型修改为 xml 类型
ALTER TABLE #t ALTER COLUMN col1 xml
ALTER TABLE #t ALTER COLUMN col2 xml

-- 将 image 列类型修改为 varbinary(max), 以便于能直接转换为 xml 类型
ALTER TABLE #t ALTER COLUMN col3 varbinary(max)
ALTER TABLE #t ALTER COLUMN col3 xml
GO

-- 显示结果
SELECT * FROM #t
GO

-- 删除测试环境
DROP TABLE #t