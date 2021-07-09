-- �����������ݿ�
USE master
CREATE DATABASE test
GO
-- �ر��Զ����������ͳ�ƹ���
ALTER DATABASE test
SET 
	AUTO_CREATE_STATISTICS OFF,
	AUTO_UPDATE_STATISTICS OFF
GO

USE test
GO

-- ����һ������10000����¼, ����1����¼ΪŮ,������¼Ϊ�еĲ��Ա�
CREATE TABLE dbo.tb(
	id int IDENTITY(1, 1) PRIMARY KEY, col1 char(8000), sex nchar(1))
INSERT dbo.tb(
	col1, sex)
SELECT TOP 10000 
	N'��', N'��'
FROM sys.columns C1, sys.columns C2

UPDATE dbo.tb SET 
	sex = N'Ů'
WHERE id = 10000
GO

-- ��������
CREATE INDEX IX_tb_sex ON dbo.tb(sex)
-- ��ʾͳ����Ϣ
DBCC SHOW_STATISTICS(N'dbo.tb', N'IX_tb_sex')
GO

-- ��ѯ sex = N'Ů' �ļ�¼
SELECT * FROM dbo.tb
WHERE sex = N'Ů'
GO

-- test1. ���������ݵ���Ϊ����1����¼Ϊ��,������¼ΪŮ
UPDATE dbo.tb SET
	sex = CASE id WHEN 10000 THEN N'��' ELSE N'Ů' END
-- ��ʾͳ����Ϣ
DBCC SHOW_STATISTICS(N'dbo.tb', N'IX_tb_sex')
GO

-- ��ѯ sex = N'Ů' �ļ�¼
SELECT * FROM dbo.tb
WHERE sex = N'Ů'
GO

-- test2. ����ͳ��
UPDATE STATISTICS dbo.tb
-- ��ʾͳ����Ϣ
DBCC SHOW_STATISTICS(N'dbo.tb', N'IX_tb_sex')
GO

-- ��ѯ sex = N'Ů' �ļ�¼
SELECT * FROM dbo.tb
WHERE sex = N'Ů'
GO

-- ɾ����ʾ����
USE master
DROP DATABASE test