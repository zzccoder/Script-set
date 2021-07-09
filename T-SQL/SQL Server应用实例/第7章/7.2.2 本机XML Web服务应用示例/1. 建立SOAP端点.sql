USE master
GO

-- 1. 建立 SOAP 端点
CREATE ENDPOINT SOAP_test
	STATE=STARTED
AS HTTP(
	AUTHENTICATION = (INTEGRATED),
	PATH = N'/sql/soap_test',
	PORTS = (CLEAR)
)
FOR SOAP(
	WEBMETHOD 'sp_who'(        -- 执行存储过程 sp_who 的专用方法
		NAME = N'master.dbo.sp_who',
		FORMAT = ROWSETS_ONLY  -- 存储过程只返回记录集
	),
	BATCHES = ENABLED,         -- 启用 BATCHES, 以便能够执行指定的T-SQL
	WSDL = DEFAULT,            -- 让SQL Server自己生成WSDL信息
	SCHEMA = STANDARD          -- 返回标准的XSD
)
GO

-- 2. 如果要使用的 Windows 帐号或者帐号所在的组未在SQL Sserver中有对应的登录帐号, 则需要建立登录
--    假设本机名称为: Test, 要为其建立登录的Windwos帐号名为:SQLTest
--    则下面的语句用于建立SQL登录及用户, 并授予适当的权限, 以便能够访问SOAP端点及执行即席T-SQL查询
-- 为WINDOWS帐号建立一个登录, 以便可以通过此帐号访问SOAP端点
CREATE LOGIN [Test\SQLTest]
FROM WINDOWS
GO

-- 授予登录对端点的连接权限
GRANT CONNECT ON ENDPOINT::SOAP_Test
	TO [Test\SQLTest]
GO

-- 为登录建立USER
CREATE USER [Test\SQLTest]
FOR LOGIN [Test\SQLTest]
WITH DEFAULT_SCHEMA = dbo
GO

-- 为USER授予适当的权限, 以使其能够执行相关的T-SQL
GRANT EXECUTE ON sp_who
TO [Test\SQLTest]
GRANT SELECT
TO [Test\SQLTest]
GO

/*-- 3. 测试完成后, 删除测试环境
-- 删除 SOAP 端点
IF EXISTS(
		SELECT * FROM sys.soap_endpoints
		WHERE name = N'SOAP_test')
	DROP ENDPOINT SOAP_test

-- 删除测试用的SQL用户及登录(如果有需要的话)
IF USER_ID(N'WSCDMIS048\JackZou') IS NOT NULL
	DROP USER [Test\SQLTest]
IF SUSER_SID(N'WSCDMIS048\JackZou') IS NOT NULL
	DROP LOGIN [Test\SQLTest]
--*/