-- 测试未使用服务主密钥加密数据库主密钥时，数据库主密钥不会在需要时自动打开

-- 创建测试数据库
CREATE DATABASE db_test
GO

USE db_test

-- 创建数据库主密钥
CREATE MASTER KEY ENCRYPTION BY PASSWORD = N'Passw0rd.125'

-- 删除服务主密钥对数据库主密钥的加密
-- 测试未使用服务主密钥加密数据库主密钥时，数据库主密钥不会在需要时自动打开
IF EXISTS(
		SELECT * FROM sys.databases
		WHERE name = DB_NAME()
			AND is_master_key_encrypted_by_server = 1)
	ALTER MASTER KEY
		DROP ENCRYPTION BY SERVICE MASTER KEY

---- 添加服务主密钥对数据库主密钥的加密(如果需要)
---- 测试使用服务主密钥加密数据库主密钥时，数据库主密钥在需要时自动打开
--IF EXISTS(
--		SELECT * FROM sys.databases
--		WHERE name = DB_NAME()
--			AND is_master_key_encrypted_by_server = 0)
--BEGIN
--	OPEN MASTER KEY DECRYPTION BY PASSWORD = N'Passw0rd.125'
--
--	ALTER MASTER KEY
--		ADD ENCRYPTION BY SERVICE MASTER KEY
--
--	CLOSE MASTER KEY
--END
GO

-- 测试在未使用 OPEN MASTER KEY 的情况下，数据库主密钥是否自动打开
BEGIN TRY
	-- 证书私钥需要数据库主密钥保护
	-- 如果数据库主密钥没有打开，证书创建会失败
	CREATE CERTIFICATE CT_test
	WITH
		SUBJECT = '测试数据库主密钥是否打开',
		START_DATE = '2001-1-1',
		EXPIRY_DATE = '2099-12-31'
END TRY
BEGIN CATCH
	SELECT ERROR_MESSAGE()

	-- 使用 OPEN MASTER KEY 打开数据库主密钥
	OPEN MASTER KEY DECRYPTION BY PASSWORD = N'Passw0rd.125'

	-- 再次创建证书，以测试数据库主密钥打开
	CREATE CERTIFICATE CT_test
	WITH
		SUBJECT = '测试数据库主密钥是否打开',
		START_DATE = '2001-1-1',
		EXPIRY_DATE = '2099-12-31'
	
	-- 关闭数据库主密钥
	CLOSE MASTER KEY
END CATCH
GO

-- 删除测试数据库
USE master
DROP DATABASE db_test
