USE tempdb
GO

-- ������ʾ����
CREATE TABLE T1(
	id int)
INSERT T1 
SELECT 1 UNION ALL 
SELECT 2

CREATE TABLE T2(
	id int)
GO

-- CTE 
;WITH
T2 AS(
	SELECT * FROM T1
)
-- ��ʾ���
SELECT * FROM T2

-- �����Ѿ���CTE�����޹�, ��ʾT1������, ��ȷ��CTE�������Ч��Χ
SELECT * FROM T2
GO

-- ɾ����ʾ����
DROP TABLE T1, T2