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

-- ��ѯָ��������������в���, �����ܸ����ŵ��¼�������
DECLARE @Dept_name nvarchar(20)
SET @Dept_name = N'MIS'
;WITH
DEPTS AS(			-- ��ѯָ�����ż����µ������Ӳ���
	-- ��λ���Ա
	SELECT * FROM Dept
	WHERE name = @Dept_name
	UNION ALL
	-- �ݹ��Ա, ͨ������CTE������Dept����JOINʵ�ֵݹ�
	SELECT A.*
	FROM Dept A, DEPTS B
	WHERE A.parent_id = B.id
),
DEPTCHILD AS(		-- ���õ�1��CTE,��ѯ��ÿ����¼��Ӧ�Ĳ����µ������Ӳ���
	SELECT 
		Dept_id = P.id, C.id, C.parent_id
	FROM DEPTS P, Dept C
	WHERE P.id = C.parent_id
	UNION ALL
	SELECT 
		P.Dept_id, C.id, C.parent_id
	FROM DEPTCHILD P, Dept C
	WHERE P.id = C.parent_id
),
DEPTCHILDCNT AS(	-- ���õ�2��CTE, ���ܵõ��������µ��Ӳ�����
	SELECT 
		Dept_id, Cnt = COUNT(*)
	FROM DEPTCHILD
	GROUP BY Dept_id
)
SELECT				-- JOIN��1,3��CTE,�õ����յĲ�ѯ���
	D.*,
	ChildDeptCount = ISNULL(DS.Cnt, 0)
FROM DEPTS D
	LEFT JOIN DEPTCHILDCNT DS
		ON D.id = DS.Dept_id
GO

-- ɾ����ʾ����
DROP TABLE Dept
