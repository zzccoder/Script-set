-- 1. ƴ������
DECLARE @t TABLE(
	col nvarchar(10))
INSERT @t(
	col)
SELECT N'�������' UNION ALL
SELECT N'��' UNION ALL
SELECT N'�����ַ�' UNION ALL
SELECT N'����' UNION ALL
SELECT N'�е�Ӧ��'

SELECT * 
FROM @t 
ORDER BY col COLLATE Chinese_PRC_90_CS_AS_KS_WS
GO

-- 2. �ʻ�����
DECLARE @t TABLE(
	col nvarchar(10))
INSERT @t(
	col)
SELECT N'��' UNION ALL
SELECT N'��' UNION ALL
SELECT N'����'

SELECT * 
FROM @t 
ORDER BY col COLLATE Chinese_PRC_Stroke_90_CS_AS_KS_WS
