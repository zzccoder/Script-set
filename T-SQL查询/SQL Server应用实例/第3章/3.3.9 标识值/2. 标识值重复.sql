-- 1. ǿ�Ʋ����ʶֵ���±�ʶֵ�ظ�
-- ������ʾ����
CREATE TABLE #(
	id int IDENTITY(1, 1), b int)
INSERT #(
	b)
VALUES(
	1)

-- �����ظ��ı�ʶֵ
SET IDENTITY_INSERT # ON
INSERT #(
	id, b)
VALUES(
	SCOPE_IDENTITY(), 2)
SET IDENTITY_INSERT # OFF

SELECT * FROM #
GO

-- ɾ����ʾ����
DROP TABLE #
GO


-- 2. DBCC CHECKIDENT���±�ʶֵ�ظ�
-- ������ʾ����
CREATE TABLE #(
	id int IDENTITY(1, 1), b int)
INSERT #(
	b)
VALUES(
	1)

--���ñ�ʶֵ
DBCC CHECKIDENT(#, RESEED, 0)
INSERT #(
	b)
VALUES(
	2)

SELECT * FROM #
GO

-- ɾ����ʾ����
DROP TABLE #
GO
