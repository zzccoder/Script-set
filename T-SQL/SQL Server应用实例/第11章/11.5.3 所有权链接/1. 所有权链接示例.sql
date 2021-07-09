USE TEMPDB
GO

-- 建立测试所有权链的 所有者登录和用户
CREATE LOGIN _Test_Manger
WITH PASSWORD = '123.abc'

CREATE USER _Test_Manger 
FOR LOGIN _Test_Manger
GO

-- 建立测试所有权链的 普通登录和用户
CREATE LOGIN _Test_Employee
WITH PASSWORD = 'abc.123'

CREATE USER _Test_Employee 
FOR LOGIN _Test_Employee
GO

-- 创建测试表
CREATE TABLE dbo.tb(
	id int)

-- 调整表的所有者
ALTER AUTHORIZATION ON OBJECT::dbo.tb
	TO _Test_Manger
GO

-- 创建测试视图
CREATE VIEW dbo.v_tb
AS
SELECT * FROM dbo.tb
GO
-- 调整视图的所有者
ALTER AUTHORIZATION ON OBJECT::dbo.v_tb
	TO _Test_Manger
GO

-- 将当前上下文切换到所有者用户
EXECUTE AS USER = N'_Test_Manger'

-- 授予普通用户对视图的 SELECT 权限
GRANT SELECT ON dbo.v_tb
	TO _Test_Employee
-- 恢复到以前的上下文
REVERT
GO

-- 将当前上下文切换到普通用户
EXECUTE AS USER = N'_Test_Employee'

-- 查询测试
BEGIN TRY
	-- 查询视图
	SELECT * FROM dbo.v_tb
	-- 查询表
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
-- 恢复到以前的上下文
REVERT
GO

-- 删除建立的测试对象
DROP VIEW dbo.v_tb
DROP TABLE dbo.tb
DROP USER _Test_Employee
DROP USER _Test_Manger
DROP LOGIN _Test_Employee
DROP LOGIN _Test_Manger
