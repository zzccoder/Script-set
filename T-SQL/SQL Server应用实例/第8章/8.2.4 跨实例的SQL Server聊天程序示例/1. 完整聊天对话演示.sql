/*--=======================================================================
-- �ű���ʹ�õı�� 
@@@_A_@@@		�� A �����ʹ��ʱ, �滻Ϊ A ; �� B �����ʹ��ʱ, �滻Ϊ B
@@@_B_@@@		�� A �����ʹ��ʱ, �滻Ϊ B ; �� B �����ʹ��ʱ, �滻Ϊ A
[Server Name]	�� A �����ʹ��ʱ, �滻Ϊ B ����������IP��ַ;
				�� B �����ʹ��ʱ, �滻Ϊ A ����������IP��ַ
=======================================================================--*/

--============================================================
-- 1. ������Ϣ���ݿ�
--============================================================
USE master
GO

IF DB_ID(N'TM_Database') IS NOT NULL
	DROP DATABASE TM_Database
CREATE DATABASE TM_Database
ALTER DATABASE TM_Database SET ENABLE_BROKER
GO

--============================================================
-- 2. ���� Service Broker �������
--============================================================
USE TM_Database
GO

-- ����һ�����Է����κ����ݵ���Ϣ����
CREATE MESSAGE TYPE MSGT_Message
VALIDATION = NONE

-- ����һ��Լ��, ��ʾ�Ի�ʹ�õ���Ϣ������ MSGT_Message
-- ���ұ�����Ϣ����������һ������
CREATE CONTRACT CT_MessageAny(
	MSGT_Message SENT BY ANY)

-- �����洢��Ϣ�Ķ���
CREATE QUEUE Q_Message
WITH
	STATUS = ON

-- �����Ի���˫��֮һ
CREATE SERVICE [SRV_@@@_A_@@@]
ON QUEUE Q_Message(
	CT_MessageAny)
GO

--============================================================
-- 3. �����Ի��õ���Ϣ���պͷ��͵Ĵ洢����
--============================================================
-- ��Ϣ���մ洢����
CREATE PROC dbo.p_Receive
AS
SET NOCOUNT ON
WHILE 1 = 1   -- �洢����������һֱ������Ϣ
BEGIN 
	DECLARE 
		@handle uniqueidentifier,
		@msg_type sysname,
		@message varbinary(max)
	BEGIN TRY
		BEGIN TRAN
			WAITFOR(              -- �ȴ�, ֱ���յ�һ����Ϣ
				RECEIVE TOP(1)   
					@handle = conversation_handle,
					@msg_type = message_type_name,
					@message = message_body
				FROM Q_Message
			)
			IF @msg_type = N'MSGT_Message'  -- ����������Ի�����Ϣ, ����ʾ
			BEGIN
				DECLARE @showmsg nvarchar(2047)
				SET @showmsg = CONVERT(nvarchar(2047), @message)
				RAISERROR(@showmsg, 0, 0) WITH NOWAIT
			END
			END CONVERSATION @handle
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		DECLARE 
			@err_msg nvarchar(4000)
		SELECT
			@err_msg =ERROR_MESSAGE()
		RAISERROR(@err_msg, 16, 1) WITH NOWAIT
	END CATCH	
END
GO

-- ��Ϣ���ʹ洢����
CREATE PROC dbo.p_Send
	@msg nvarchar(4000)
AS
SET NOCOUNT ON
	DECLARE 
		@handle uniqueidentifier
	BEGIN DIALOG CONVERSATION @handle
		FROM SERVICE [SRV_@@@_A_@@@]
		TO SERVICE 'SRV_@@@_B_@@@'
		ON CONTRACT CT_MessageAny
		WITH ENCRYPTION = ON;
	SEND ON CONVERSATION @handle
		MESSAGE TYPE MSGT_Message(
			@msg)
GO

--============================================================
-- 4. �� master �н������䰲ȫģʽ����֤�鼰Service Broker�˵�
--============================================================
USE master
GO

-- master key
CREATE MASTER KEY
ENCRYPTION BY PASSWORD = N'Service Broker�����ݿ������Կ�ԻỰ��Կ���м���'
GO

-- ���䰲ȫģʽ�����֤��
CREATE CERTIFICATE [CERT_SSB_connect_@@@_A_@@@]
WITH 
	SUBJECT = 'CERT_SSB_connect', 
	START_DATE = '1/1/2001',
	EXPIRY_DATE = '12/1/9999'
GO

-- ����֤��
BACKUP CERTIFICATE [CERT_SSB_connect_@@@_A_@@@]
TO FILE = 'd:\ssb\CERT_SSB_connect_@@@_A_@@@.cer'
GO

-- �˵�
CREATE ENDPOINT EP_SSB
STATE = STARTED
AS TCP(
	LISTENER_PORT = 4022)
FOR SERVICE_BROKER(
	AUTHENTICATION = CERTIFICATE [CERT_SSB_connect_@@@_A_@@@])
GO

--============================================================
-- 5. �����Ự��ȫģʽ�����֤�鼰��Կ�ı���(��ҪMASTER KEY)
--============================================================
USE TM_Database
GO

-- master key
CREATE MASTER KEY
ENCRYPTION BY PASSWORD = N'Service Broker�����ݿ������Կ�ԻỰ��Կ���м���'
GO

-- ֤��
CREATE CERTIFICATE [CERT_SSB_Dialog_SRV_@@@_A_@@@]
WITH 
	SUBJECT = 'CERT_SSB_Dialog', 
	START_DATE = '1/1/2001',
	EXPIRY_DATE = '12/1/9999'
GO

-- ����֤��
BACKup CERTIFICATE [CERT_SSB_Dialog_SRV_@@@_A_@@@]
TO FILE = 'd:\ssb\CERT_SSB_Dialog_SRV_@@@_A_@@@.cer'
GO



--============================================================
-- 6. ʹ��֤�齫Զ�̲���ӳ�䵽���ذ�ȫ���� -- ��Դ��䰲ȫģʽ
--============================================================
-- �ȴ�֤�鹫Կ���Ƶ�ָ��λ��
-- ����һ̨���������ݵĹ�Կ���Ƶ�ָ��Ŀ¼�ű����ɼ���ִ��
SET NOCOUNT ON
DECLARE @FileExists int
WHILE 1 = 1
BEGIN
	EXEC master.dbo.xp_fileexist 'd:\ssb\CERT_SSB_connect_@@@_B_@@@.cer', @FileExists OUTPUT
	IF @FileExists = 1
		BREAK
	WAITFOR DELAY '00:00:01'
END
SET NOCOUNT OFF
GO

USE master
GO

-- ʹ��Զ�̷���Ĺ�Կ����֤��
CREATE CERTIFICATE [CERT_SSB_connect_@@@_B_@@@]
FROM FILE = 'd:\ssb\CERT_SSB_connect_@@@_B_@@@.cer'

-- ͨ��֤�鴴����¼
CREATE LOGIN LOGIN_SSB_REMOTE
FROM CERTIFICATE [CERT_SSB_connect_@@@_B_@@@]

--  ��������Ȩ��
GRANT CONNECT ON ENDPOINT::EP_SSB
TO LOGIN_SSB_REMOTE
GO

--============================================================
-- 7. ʹ��֤�齫Զ�̲���ӳ�䵽���ذ�ȫ���� -- ��ԻỰ��ȫģʽ
--============================================================
-- ����һ̨���������ݵĹ�Կ���Ƶ�ָ��Ŀ¼�ű����ɼ���ִ��
SET NOCOUNT ON
DECLARE @FileExists int
WHILE 1 = 1
BEGIN
	EXEC master.dbo.xp_fileexist 'd:\ssb\CERT_SSB_Dialog_SRV_@@@_B_@@@.cer', @FileExists OUTPUT
	IF @FileExists = 1
		BREAK
	WAITFOR DELAY '00:00:01'
END
SET NOCOUNT OFF
GO

USE TM_Database
GO

-- �������ذ�ȫ����(�����ǵ�¼������Ӧ�ó����ɫ)
CREATE USER USER_SSB_REMOTE
WITHOUT LOGIN

-- ���� SEND Ȩ��
GRANT SEND ON SERVICE::[SRV_@@@_A_@@@]
TO USER_SSB_REMOTE

-- ʹ��Զ�̷���Ĺ�Կ����֤��, ��ͨ��AUTHORIZATIONָ�������û�
CREATE CERTIFICATE [CERT_SSB_Dialog_SRV_@@@_B_@@@]
AUTHORIZATION USER_SSB_REMOTE 
FROM FILE = 'd:\ssb\CERT_SSB_Dialog_SRV_@@@_B_@@@.cer'

-- ����Զ�̷����
CREATE REMOTE SERVICE BINDING [RSB_SRV_@@@_B_@@@]
TO SERVICE 'SRV_@@@_B_@@@'
WITH USER = USER_SSB_REMOTE

--============================================================
-- 8. ����·��
--============================================================
-- ����·��
CREATE ROUTE [ROUTE_SRV_@@@_B_@@@]
WITH  SERVICE_NAME  = N'SRV_@@@_B_@@@' ,  
ADDRESS  = N'TCP://[Server Name]:4022' 
GO



--============================================================
-- 9. ������ɺ�, ���� master ���о������Ķ���
--    ���²����ڲ�����ɺ�ִ��
--============================================================
--USE master
--GO
--
---- ɾ�� Service Broker �˵�
--IF EXISTS(
--		SELECT * FROM sys.endpoints
--		WHERE name = N'EP_SSB')
--	DROP ENDPOINT EP_SSB
--GO
--
---- ɾ����¼
--IF EXISTS(
--		SELECT * FROM sys.server_principals
--		WHERE name = N'LOGIN_SSB_REMOTE')
--	DROP LOGIN LOGIN_SSB_REMOTE
--GO
--
---- ɾ��֤��
--IF EXISTS(
--		SELECT * FROM sys.certificates
--		WHERE name = N'CERT_SSB_connect_A')
--	DROP CERTIFICATE [CERT_SSB_connect_A]
--
--IF EXISTS(
--		SELECT * FROM sys.certificates
--		WHERE name = N'CERT_SSB_connect_B')
--	DROP CERTIFICATE [CERT_SSB_connect_B]
--GO
--
---- ɾ�� master ��� master key
--IF EXISTS(
--		SELECT * FROM sys.symmetric_keys
--		WHERE name = N'##MS_DatabaseMasterKey##')
--	DROP MASTER KEY
--GO
