-- ������ʾ����
USE tempdb
GO

CREATE TABLE dbo.tb(
	c1 int NOT NULL,
	c2 int NOT NULL)
INSERT dbo.tb 
SELECT 1, 3 UNION ALL
SELECT 2, 2 UNION ALL
SELECT 3, 1
GO

-- ��������������
ALTER TABLE dbo.tb 
	ADD CONSTRAINT PK_tb
		PRIMARY KEY(
			c1)

CREATE UNIQUE INDEX IXU_tb_c2 
	ON dbo.tb(
		c2)
GO

-- ��ѯ����
SELECT * FROM dbo.tb 

SELECT * FROM dbo.tb 
WITH(INDEX(PK_tb))
GO

-- ɾ����ʾ����
DROP TABLE dbo.tb