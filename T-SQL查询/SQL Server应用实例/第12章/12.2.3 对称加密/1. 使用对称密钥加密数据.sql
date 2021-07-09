USE tempdb
GO

-- ����ʹ��������ܵĶԳ���Կ
CREATE SYMMETRIC KEY SYM_Test
WITH 
	ALGORITHM = AES_128
ENCRYPTION BY
	PASSWORD = N'abc.password_1'

-- ���һ�����ܶԳ���Կ������
-- Ҳ�����ڴ����Գ���Կʱ, �� ENCRYPTION BY �Ӿ���ָ����������(ָ������ PASSWORD �
OPEN SYMMETRIC KEY SYM_Test
	DECRYPTION BY PASSWORD = N'abc.password_1'

ALTER SYMMETRIC KEY SYM_Test
ADD
	ENCRYPTION BY PASSWORD = N'abc.password_2'
CLOSE SYMMETRIC KEY SYM_Test
GO

-- ʹ�öԳ���Կ��������
OPEN SYMMETRIC KEY SYM_Test
	DECRYPTION BY PASSWORD = N'abc.password_1'

DECLARE
	@ciphertext varbinary(1000)
SELECT 
	@ciphertext = ENCRYPTBYKEY(KEY_GUID(N'SYM_Test'), N'���ԶԳ���Կ����')
CLOSE SYMMETRIC KEY SYM_Test

-- ʹ����һ������򿪶Գ���Կ�������ݽ���
OPEN SYMMETRIC KEY SYM_Test
	DECRYPTION BY PASSWORD = N'abc.password_2'

SELECT 
	CONVERT(nvarchar(10), DECRYPTBYKEY(@ciphertext))
CLOSE SYMMETRIC KEY SYM_Test
GO

-- ɾ�����Ի���
DROP SYMMETRIC KEY SYM_Test