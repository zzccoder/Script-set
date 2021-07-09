USE tempdb
GO

-- ������ʾ����
CREATE TABLE Dept(
	id int PRIMARY KEY, 
	parent_id int,
	name nvarchar(20))
INSERT Dept
SELECT 0, 0, N'<ȫ��>' UNION ALL
SELECT 1, 0, N'����' UNION ALL
SELECT 2, 0, N'������' UNION ALL
SELECT 3, 0, N'ҵ��' UNION ALL
SELECT 4, 0, N'ҵ��' UNION ALL
SELECT 5, 4, N'���۲�' UNION ALL
SELECT 6, 4, N'MIS' UNION ALL
SELECT 7, 6, N'UI' UNION ALL
SELECT 8, 6, N'�������' UNION ALL
SELECT 9, 8, N'�ڲ�����'
GO

-- ��ѯָ��������������в���
DECLARE @Dept_name nvarchar(20)
SET @Dept_name = N'MIS'
;WITH
DEPTS AS(
	-- ��λ���Ա
	SELECT * FROM Dept
	WHERE name = @Dept_name
	UNION ALL
	-- �ݹ��Ա, ͨ������CTE������Dept����JOINʵ�ֵݹ�
	SELECT A.*
	FROM Dept A, DEPTS B
	WHERE A.parent_id = B.id
)
SELECT * FROM DEPTS
GO

-- ɾ����ʾ����
DROP TABLE Dept
