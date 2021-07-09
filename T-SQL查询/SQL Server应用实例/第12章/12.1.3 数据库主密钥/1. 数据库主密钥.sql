-- ����δʹ�÷�������Կ�������ݿ�����Կʱ�����ݿ�����Կ��������Ҫʱ�Զ���

-- �����������ݿ�
CREATE DATABASE db_test
GO

USE db_test

-- �������ݿ�����Կ
CREATE MASTER KEY ENCRYPTION BY PASSWORD = N'Passw0rd.125'

-- ɾ����������Կ�����ݿ�����Կ�ļ���
-- ����δʹ�÷�������Կ�������ݿ�����Կʱ�����ݿ�����Կ��������Ҫʱ�Զ���
IF EXISTS(
		SELECT * FROM sys.databases
		WHERE name = DB_NAME()
			AND is_master_key_encrypted_by_server = 1)
	ALTER MASTER KEY
		DROP ENCRYPTION BY SERVICE MASTER KEY

---- ��ӷ�������Կ�����ݿ�����Կ�ļ���(�����Ҫ)
---- ����ʹ�÷�������Կ�������ݿ�����Կʱ�����ݿ�����Կ����Ҫʱ�Զ���
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

-- ������δʹ�� OPEN MASTER KEY ������£����ݿ�����Կ�Ƿ��Զ���
BEGIN TRY
	-- ֤��˽Կ��Ҫ���ݿ�����Կ����
	-- ������ݿ�����Կû�д򿪣�֤�鴴����ʧ��
	CREATE CERTIFICATE CT_test
	WITH
		SUBJECT = '�������ݿ�����Կ�Ƿ��',
		START_DATE = '2001-1-1',
		EXPIRY_DATE = '2099-12-31'
END TRY
BEGIN CATCH
	SELECT ERROR_MESSAGE()

	-- ʹ�� OPEN MASTER KEY �����ݿ�����Կ
	OPEN MASTER KEY DECRYPTION BY PASSWORD = N'Passw0rd.125'

	-- �ٴδ���֤�飬�Բ������ݿ�����Կ��
	CREATE CERTIFICATE CT_test
	WITH
		SUBJECT = '�������ݿ�����Կ�Ƿ��',
		START_DATE = '2001-1-1',
		EXPIRY_DATE = '2099-12-31'
	
	-- �ر����ݿ�����Կ
	CLOSE MASTER KEY
END CATCH
GO

-- ɾ���������ݿ�
USE master
DROP DATABASE db_test
