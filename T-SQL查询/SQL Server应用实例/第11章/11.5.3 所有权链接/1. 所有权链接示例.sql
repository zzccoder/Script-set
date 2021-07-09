USE TEMPDB
GO

-- ������������Ȩ���� �����ߵ�¼���û�
CREATE LOGIN _Test_Manger
WITH PASSWORD = '123.abc'

CREATE USER _Test_Manger 
FOR LOGIN _Test_Manger
GO

-- ������������Ȩ���� ��ͨ��¼���û�
CREATE LOGIN _Test_Employee
WITH PASSWORD = 'abc.123'

CREATE USER _Test_Employee 
FOR LOGIN _Test_Employee
GO

-- �������Ա�
CREATE TABLE dbo.tb(
	id int)

-- �������������
ALTER AUTHORIZATION ON OBJECT::dbo.tb
	TO _Test_Manger
GO

-- ����������ͼ
CREATE VIEW dbo.v_tb
AS
SELECT * FROM dbo.tb
GO
-- ������ͼ��������
ALTER AUTHORIZATION ON OBJECT::dbo.v_tb
	TO _Test_Manger
GO

-- ����ǰ�������л����������û�
EXECUTE AS USER = N'_Test_Manger'

-- ������ͨ�û�����ͼ�� SELECT Ȩ��
GRANT SELECT ON dbo.v_tb
	TO _Test_Employee
-- �ָ�����ǰ��������
REVERT
GO

-- ����ǰ�������л�����ͨ�û�
EXECUTE AS USER = N'_Test_Employee'

-- ��ѯ����
BEGIN TRY
	-- ��ѯ��ͼ
	SELECT * FROM dbo.v_tb
	-- ��ѯ��
	SELECT * FROM dbo.tb
END TRY
BEGIN CATCH
	DECLARE
		@error_state int,
		@error_severity int,
		@error_message nvarchar(2048)
	SELECT
		@error_severity = ERROR_SEVERITY(),
		@error_state = ERROR_STATE(),
		@error_message = ERROR_MESSAGE()
	RAISERROR('%s', @error_severity, @error_state, @error_message)
END CATCH
-- �ָ�����ǰ��������
REVERT
GO

-- ɾ�������Ĳ��Զ���
DROP VIEW dbo.v_tb
DROP TABLE dbo.tb
DROP USER _Test_Employee
DROP USER _Test_Manger
DROP LOGIN _Test_Employee
DROP LOGIN _Test_Manger
