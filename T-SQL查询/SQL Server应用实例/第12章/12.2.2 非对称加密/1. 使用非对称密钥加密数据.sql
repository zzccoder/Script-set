USE tempdb
GO

-- ����ʹ���������˽Կ�ķǶԳ���Կ
CREATE ASYMMETRIC KEY ASYM_Test
WITH
	ALGORITHM = RSA_512
ENCRYPTION BY PASSWORD = N'abc.124'
GO

-- ����/��������
SELECT
	Encrypt = ENCRYPTBYASYMKEY(ASYMKEY_ID(N'ASYM_Test'), N'����'),
	Decrypt = CONVERT(nvarchar(100),
			DECRYPTBYASYMKEY(
				ASYMKEY_ID(N'ASYM_Test'), 
				ENCRYPTBYASYMKEY(ASYMKEY_ID(N'ASYM_Test'), N'����'),
				N'abc.124'))
GO

-- ɾ�����Ի���
DROP ASYMMETRIC KEY ASYM_Test
