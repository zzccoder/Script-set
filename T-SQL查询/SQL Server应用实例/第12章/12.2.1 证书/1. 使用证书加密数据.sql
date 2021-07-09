USE tempdb
GO

-- 创建数据库主密钥
IF NOT EXISTS(
		SELECT * FROM sys.symmetric_keys
		WHERE name = N'##MS_DatabaseMasterKey##')
	CREATE MASTER KEY ENCRYPTION BY PASSWORD = N'abcd.1234'
-- 如果数据库主密钥没有被服务器主密钥加密，则使用服务器主密钥加密数据库主密钥
-- 以实现数据库主密钥在需要时自动打开
IF NOT EXISTS(
		SELECT * FROM sys.databases
		WHERE database_id = DB_ID()
			AND is_master_key_encrypted_by_server = 1)
	ALTER MASTER KEY
		ADD ENCRYPTION BY SERVICE MASTER KEY 
GO

-- 创建使用数据库主密钥加密的证书
CREATE CERTIFICATE CERT_Test1
WITH
	SUBJECT = N'Encryption by database maser key',
	START_DATE = '1999-1-1',
	EXPIRY_DATE= '2099-12-31'

-- 创建使用密码加密的证书
CREATE CERTIFICATE CERT_Test2
	ENCRYPTION BY PASSWORD = N'abc.1234'
WITH
	SUBJECT = N'Encryption by password',
	START_DATE = '1999-1-1',
	EXPIRY_DATE= '2099-12-31'
GO

-- 使用前面建立的两种证书加密并保存数据
DECLARE @tb TABLE(
	EncryptData varbinary(8000))
INSERT @tb(
	EncryptData)
SELECT ENCRYPTBYCERT(CERT_ID(N'CERT_Test1'), N'使用证书 CERT_Test1 加密') UNION ALL
SELECT ENCRYPTBYCERT(CERT_ID(N'CERT_Test2'), N'使用证书 CERT_Test2 加密')

-- 解密加密后的数据
SELECT
	DecryptionBy_CERT_Test1 = CONVERT(nvarchar(4000), 
			DECRYPTBYCERT(CERT_ID(N'CERT_Test1'), EncryptData)),
	DecryptionBy_CERT_Test1_UsePassword = CONVERT(nvarchar(4000), 
			DECRYPTBYCERT(CERT_ID(N'CERT_Test1'), EncryptData, N'abc.1234')),
	DecryptionBy_CERT_Test2 = CONVERT(nvarchar(4000), 
			DECRYPTBYCERT(CERT_ID(N'CERT_Test2'), EncryptData)),
	DecryptionBy_CERT_Test2_UsePassword = CONVERT(nvarchar(4000), 
			DECRYPTBYCERT(CERT_ID(N'CERT_Test2'), EncryptData, N'abc.1234'))
FROM @tb
GO

-- 删除测试环境
DROP CERTIFICATE CERT_Test1
DROP CERTIFICATE CERT_Test2

