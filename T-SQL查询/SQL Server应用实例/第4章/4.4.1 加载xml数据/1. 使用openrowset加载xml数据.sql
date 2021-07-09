-- 1. ���� XML �ļ�����ʱָ������
-- �������
DECLARE @encoding varbinary(max)
SET @encoding = CONVERT(varbinary(max), '<?xml version="1.0" encoding="gb2312"?>')

-- ���� xml �ļ��е�����
SELECT 
	Doc = CONVERT(xml, @encoding + T.c)
FROM OPENROWSET(BULK 'c:\test.xml', SINGLE_BLOB) T(c)
GO

-- ��ָ���������
SELECT 
	Doc = CONVERT(xml, T.c)
FROM OPENROWSET(BULK 'c:\test.xml', SINGLE_BLOB) T(c)
