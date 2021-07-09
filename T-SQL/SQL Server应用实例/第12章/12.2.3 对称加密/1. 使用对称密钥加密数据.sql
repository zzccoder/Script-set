USE tempdb
GO

-- 创建使用密码加密的对称密钥
CREATE SYMMETRIC KEY SYM_Test
WITH 
	ALGORITHM = AES_128
ENCRYPTION BY
	PASSWORD = N'abc.password_1'

-- 添加一个加密对称密钥的密码
-- 也可以在创建对称密钥时, 在 ENCRYPTION BY 子句中指定两个密码(指定两个 PASSWORD 项）
OPEN SYMMETRIC KEY SYM_Test
	DECRYPTION BY PASSWORD = N'abc.password_1'

ALTER SYMMETRIC KEY SYM_Test
ADD
	ENCRYPTION BY PASSWORD = N'abc.password_2'
CLOSE SYMMETRIC KEY SYM_Test
GO

-- 使用对称密钥加密数据
OPEN SYMMETRIC KEY SYM_Test
	DECRYPTION BY PASSWORD = N'abc.password_1'

DECLARE
	@ciphertext varbinary(1000)
SELECT 
	@ciphertext = ENCRYPTBYKEY(KEY_GUID(N'SYM_Test'), N'测试对称密钥加密')
CLOSE SYMMETRIC KEY SYM_Test

-- 使用另一个密码打开对称密钥进行数据解密
OPEN SYMMETRIC KEY SYM_Test
	DECRYPTION BY PASSWORD = N'abc.password_2'

SELECT 
	CONVERT(nvarchar(10), DECRYPTBYKEY(@ciphertext))
CLOSE SYMMETRIC KEY SYM_Test
GO

-- 删除测试环境
DROP SYMMETRIC KEY SYM_Test