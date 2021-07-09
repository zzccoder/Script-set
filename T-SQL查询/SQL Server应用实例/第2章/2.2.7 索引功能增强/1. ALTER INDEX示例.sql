USE tempdb
GO

-- ������ʾ����
CREATE TABLE dbo.tb_IndexTest(
	id int NOT NULL,
	col int,
	CONSTRAINT PK_id
		PRIMARY KEY CLUSTERED(
			id)
)
CREATE INDEX IX_col
	ON dbo.tb_IndexTest(
		col)
GO

-- ��������
ALTER INDEX IX_col
	ON dbo.tb_IndexTest
	DISABLE
GO

-- ������������(��������)
ALTER INDEX ALL
	ON dbo.tb_IndexTest
	DISABLE
GO

-- ����������, ���ʻ������ʧ��
SELECT * FROM dbo.tb_IndexTest
GO

-- ��������
ALTER INDEX ALL
	ON dbo.tb_IndexTest
	REBUILD
GO

-- ������֯���� IX_col
ALTER INDEX IX_col
	ON dbo.tb_IndexTest
	REORGANIZE
GO

-- ɾ����ʾ
DROP TABLE dbo.tb_IndexTest
