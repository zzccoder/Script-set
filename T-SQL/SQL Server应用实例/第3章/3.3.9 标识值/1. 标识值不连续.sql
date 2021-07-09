-- 1. ����ع����±�ʶֵ������
-- ������ʾ����
CREATE TABLE #(
	id int IDENTITY(0,1), b int UNIQUE)
INSERT #(
	b)
VALUES(
	1)

-- a. �ֹ�����ع�
BEGIN TRAN
	INSERT #(
		b)
	VALUES(
		2)
ROLLBACK TRAN

INSERT #(
	b)
VALUES(
	2)
SELECT * FROM #
GO

-- b. �����ʧ���Զ��ع�����
INSERT #(
	b)
VALUES(
	2)
INSERT #(
	b)
VALUES(
	3)
SELECT * FROM #
GO

-- ɾ����ʾ��
DROP TABLE #
GO



-- 2. ɾ����¼���±�ʶֵ������
-- ������ʾ����
CREATE TABLE #(
	id int IDENTITY(0,1), b int)
INSERT #(
	b)
SELECT 1 UNION ALL
SELECT 2
GO

-- ɾ��һ����¼
DELETE # WHERE b = 2
INSERT #(
	b)
VALUES(
	2)
SELECT * FROM #
GO

-- ɾ����ʾ����
DROP TABLE #
GO


-- 3. ���ñ�ʶֵ���±�ʶֵ������
-- ������ʾ����
CREATE TABLE #(
	id int IDENTITY(0,1), b int)
INSERT #(
	b)
VALUES(
	1)

--���õ�ǰ��ʶֵ
DBCC CHECKIDENT(#, RESEED, 1)
INSERT #(
	b)
VALUES(
	1)
SELECT * FROM #
GO

-- ɾ����ʾ����
DROP TABLE #
GO
