-- �������Ի���, ʹ�� text/ntext/image ���͵��д洢xml����
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
	N'<r>����</r>',
	CONVERT(varbinary(8000), N'<r>image��</r>'))
GO

-- �� text/ntext �е������޸�Ϊ xml ����
ALTER TABLE #t ALTER COLUMN col1 xml
ALTER TABLE #t ALTER COLUMN col2 xml

-- �� image �������޸�Ϊ varbinary(max), �Ա�����ֱ��ת��Ϊ xml ����
ALTER TABLE #t ALTER COLUMN col3 varbinary(max)
ALTER TABLE #t ALTER COLUMN col3 xml
GO

-- ��ʾ���
SELECT * FROM #t
GO

-- ɾ�����Ի���
DROP TABLE #t