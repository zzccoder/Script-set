-- 以数据库所有者的身份登录

USE tempdb
GO

-- 创建应用程序角色
CREATE APPLICATION ROLE APPRoleTest
    WITH PASSWORD = 'p@ssw0rd'

-- 授予 SELECT 权限
GRANT SELECT 
	TO APPRoleTest
GO

-- 当前用户
SELECT BeforeSwitch = USER_NAME()

-- 切换到应用程序角色
DECLARE 
	@cookie varbinary(8000)
EXEC sp_setapprole 
	@rolename = 'APPRoleTest',
	@password = 'p@ssw0rd',
    @fCreateCookie = true,
    @cookie = @cookie OUTPUT

-- 当前用户
SELECT AfterSwitch = USER_NAME()

-- 测试是否只有应用程序角色权限（丢失掉连接用户的权限）
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

-- 回复到连接用户的上下文
EXEC sp_unsetapprole 
	@cookie = @cookie
GO

-- 删除演示建立的应用程序角色
DROP APPLICATION ROLE APPRoleTest
