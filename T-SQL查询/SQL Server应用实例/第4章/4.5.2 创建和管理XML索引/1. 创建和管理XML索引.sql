-- �������Ի���
USE tempdb
GO
CREATE TABLE tb(
	id int
		PRIMARY KEY CLUSTERED,
	col xml)
GO

-- 1. ���� xml ����
-- 1.a. ���� xml ������
CREATE PRIMARY XML INDEX PKX_col
	ON tb(col)

-- 1.b. ���� VALUE ���� xml ����
CREATE XML INDEX IXX_col_value
	ON tb(col)
	USING XML INDEX PKX_col
	FOR VALUE

-- 1.c. ���� PATH ���� xml ����
CREATE XML INDEX IXX_col_path
	ON tb(col)
	USING XML INDEX PKX_col
	FOR PATH
GO

-- 2. �޸� xml ����
-- 2.a. �ؽ� PATH ���� xml ���� IXX_col_path
ALTER INDEX IXX_col_path
	ON tb
	REBUILD

-- 2.b. ���� VALUE ���� xml ���� IXX_col_value
ALTER INDEX IXX_col_value
	ON tb
	DISABLE
GO


-- 3. ɾ�� xml ����
-- 3.a. VALUE ���� xml ���� IXX_col_value
DROP INDEX IXX_col_value
	ON tb

-- 3.b. ɾ�� xml ������, ע��˲�����ͬʱɾ����֮��صĸ��� xml ����
DROP INDEX PKX_col
	ON tb
GO

-- ɾ�����Ի���
DROP TABLE tb