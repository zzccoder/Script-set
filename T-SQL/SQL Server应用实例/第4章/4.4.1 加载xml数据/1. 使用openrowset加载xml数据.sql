-- 1. 加载 XML 文件数据时指定编码
-- 定义编码
DECLARE @encoding varbinary(max)
SET @encoding = CONVERT(varbinary(max), '<?xml version="1.0" encoding="gb2312"?>')

-- 加载 xml 文件中的数据
SELECT 
	Doc = CONVERT(xml, @encoding + T.c)
FROM OPENROWSET(BULK 'c:\test.xml', SINGLE_BLOB) T(c)
GO

-- 不指定编码加载
SELECT 
	Doc = CONVERT(xml, T.c)
FROM OPENROWSET(BULK 'c:\test.xml', SINGLE_BLOB) T(c)
