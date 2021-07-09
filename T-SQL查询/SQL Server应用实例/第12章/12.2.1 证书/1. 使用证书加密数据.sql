USE tempdb
GO

-- �������ݿ�����Կ
IF NOT EXISTS(
		SELECT * FROM sys.symmetric_keys
		WHERE name = N'##MS_DatabaseMasterKey##')
	CREATE MASTER KEY ENCRYPTION BY PASSWORD = N'abcd.1234'
-- ������ݿ�����Կû�б�����������Կ���ܣ���ʹ�÷���������Կ�������ݿ�����Կ
-- ��ʵ�����ݿ�����Կ����Ҫʱ�Զ���
IF NOT EXISTS(
		SELECT * FROM sys.databases
		WHERE database_id = DB_ID()
			AND is_master_key_encrypted_by_server = 1)
	ALTER MASTER KEY
		ADD ENCRYPTION BY SERVICE MASTER KEY 
GO

-- ����ʹ�����ݿ�����Կ���ܵ�֤��
CREATE CERTIFICATE CERT_Test1
WITH
	SUBJECT = N'Encryption by database maser key',
	START_DATE = '1999-1-1',
	EXPIRY_DATE= '2099-12-31'

-- ����ʹ��������ܵ�֤��
CREATE CERTIFICATE CERT_Test2
	ENCRYPTION BY PASSWORD = N'abc.1234'
WITH
	SUBJECT = N'Encryption by password',
	START_DATE = '1999-1-1',
	EXPIRY_DATE= '2099-12-31'
GO

-- ʹ��ǰ�潨��������֤����ܲ���������
DECLARE @tb TABLE(
	EncryptData varbinary(8000))
INSERT @tb(
	EncryptData)
SELECT ENCRYPTBYCERT(CERT_ID(N'CERT_Test1'), N'ʹ��֤�� CERT_Test1 ����') UNION ALL
SELECT ENCRYPTBYCERT(CERT_ID(N'CERT_Test2'), N'ʹ��֤�� CERT_Test2 ����')

-- ���ܼ��ܺ������
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

-- ɾ�����Ի���
DROP CERTIFICATE CERT_Test1
DROP CERTIFICATE CERT_Test2

