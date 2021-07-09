-- �����ݿ������ߵ���ݵ�¼

USE tempdb
GO

-- ����Ӧ�ó����ɫ
CREATE APPLICATION ROLE APPRoleTest
    WITH PASSWORD = 'p@ssw0rd'

-- ���� SELECT Ȩ��
GRANT SELECT 
	TO APPRoleTest
GO

-- ��ǰ�û�
SELECT BeforeSwitch = USER_NAME()

-- �л���Ӧ�ó����ɫ
DECLARE 
	@cookie varbinary(8000)
EXEC sp_setapprole 
	@rolename = 'APPRoleTest',
	@password = 'p@ssw0rd',
    @fCreateCookie = true,
    @cookie = @cookie OUTPUT

-- ��ǰ�û�
SELECT AfterSwitch = USER_NAME()

-- �����Ƿ�ֻ��Ӧ�ó����ɫȨ�ޣ���ʧ�������û���Ȩ�ޣ�
BEGIN TRY
	CREATE TABLE tb(id int)
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

-- �ظ��������û���������
EXEC sp_unsetapprole 
	@cookie = @cookie
GO

-- ɾ����ʾ������Ӧ�ó����ɫ
DROP APPLICATION ROLE APPRoleTest
