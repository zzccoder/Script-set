-- 1. ����A

-- ������ʾ����
USE tempdb

CREATE TABLE dbo.tb(
	id int)
GO

-- �������񲢲�������
BEGIN TRAN
	INSERT dbo.tb(
		id)
	VALUES(
		1)
--COMMIT TRAN
GO

-- 2. ����B
USE tempdb

SELECT * FROM dbo.tb
GO

-- ɾ����ʾ����
DROP TABLE dbo.tb
GO

