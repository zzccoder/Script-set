USE tempdb
GO

-- 建立使用密码加密私钥的非对称密钥
CREATE ASYMMETRIC KEY ASYM_Test
WITH
	ALGORITHM = RSA_512
ENCRYPTION BY PASSWORD = N'abc.124'
GO

-- 加密/解密数据
SELECT
	Encrypt = ENCRYPTBYASYMKEY(ASYMKEY_ID(N'ASYM_Test'), N'加密'),
	Decrypt = CONVERT(nvarchar(100),
			DECRYPTBYASYMKEY(
				ASYMKEY_ID(N'ASYM_Test'), 
				ENCRYPTBYASYMKEY(ASYMKEY_ID(N'ASYM_Test'), N'解密'),
				N'abc.124'))
GO

-- 删除测试环境
DROP ASYMMETRIC KEY ASYM_Test
