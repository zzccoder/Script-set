/*--=======================================================================
-- �ű���ʹ�õı�� 
-- �ű���ʹ�õı�� 
[Server Name]	�滻Ϊ����ط�����(��ط����)�ķ���������IP��ַ
=======================================================================--*/

--============================================================
-- 1. ����������ݿ�
--============================================================
USE master
GO

IF DB_ID(N'Monitor_Database') IS NOT NULL
	DROP DATABASE Monitor_Database
CREATE DATABASE Monitor_Database
ALTER DATABASE Monitor_Database SET ENABLE_BROKER

-- ��ȡ Service Broker ��ʶ
DECLARE @broker_instance_identifier char(36)
SELECT 
	@broker_instance_identifier = CONVERT(char(36), service_broker_guid)
FROM sys.databases
WHERE name = N'Monitor_Database'
RAISERROR('Service Broker Identifier is: %s', 10, 1, @broker_instance_identifier) WITH NOWAIT
GO

--============================================================
-- 2. ���� Service Broker �������
--============================================================
USE Monitor_Database
GO

-- ���������Ϣ(�¼�֪ͨ��Ϣ)�Ķ���
CREATE QUEUE Q_MonitorInfo
WITH
	STATUS = ON

-- �������ռ����Ϣ(�¼�֪ͨ��Ϣ)�ķ���
CREATE SERVICE SRV_Monitor_Client
ON QUEUE Q_MonitorInfo(
	[http://schemas.microsoft.com/SQL/Notifications/PostEventNotification])
GO

--============================================================
-- 3. �� master �н������䰲ȫģʽ����֤�鼰Service Broker�˵�
--============================================================
USE master
GO

-- master key
CREATE MASTER KEY
ENCRYPTION BY PASSWORD = N'Service Broker�����ݿ������Կ�ԻỰ��Կ���м���'
GO

-- ���䰲ȫģʽ�����֤��
CREATE CERTIFICATE CERT_SSB_connect_Monitor_Client
WITH 
	SUBJECT = 'CERT_SSB_connect', 
	START_DATE = '1/1/2001',
	EXPIRY_DATE = '12/1/9999'
GO

-- ����֤��
BACKUP CERTIFICATE CERT_SSB_connect_Monitor_Client
TO FILE = 'd:\ssb\CERT_SSB_connect_Monitor_Client.cer'
GO

-- �˵�
CREATE ENDPOINT EP_SSB
STATE = STARTED
AS TCP(
	LISTENER_PORT = 4022)
FOR SERVICE_BROKER(
	AUTHENTICATION = CERTIFICATE CERT_SSB_connect_Monitor_Client)
GO

--============================================================
-- 4. �����Ự��ȫģʽ�����֤�鼰��Կ�ı���(��ҪMASTER KEY)
--============================================================
USE Monitor_Database
GO

-- master key
CREATE MASTER KEY
ENCRYPTION BY PASSWORD = N'Service Broker�����ݿ������Կ�ԻỰ��Կ���м���'
GO

-- ֤��
CREATE CERTIFICATE CERT_SSB_Dialog_Monitor_Client
WITH 
	SUBJECT = 'CERT_SSB_Dialog', 
	START_DATE = '1/1/2001',
	EXPIRY_DATE = '12/1/9999'
GO

-- ����֤��
BACKup CERTIFICATE CERT_SSB_Dialog_Monitor_Client
TO FILE = 'd:\ssb\CERT_SSB_Dialog_Monitor_Client.cer'
GO



--============================================================
-- 5. ʹ��֤�齫Զ�̲���ӳ�䵽���ذ�ȫ���� -- ��Դ��䰲ȫģʽ
--============================================================
-- �ȴ�֤�鹫Կ���Ƶ�ָ��λ��
-- ����һ̨���������ݵĹ�Կ���Ƶ�ָ��Ŀ¼�ű����ɼ���ִ��
SET NOCOUNT ON
DECLARE @FileExists int
WHILE 1 = 1
BEGIN
	EXEC master.dbo.xp_fileexist 'd:\ssb\CERT_SSB_connect_Monitor_Service.cer', @FileExists OUTPUT
	IF @FileExists = 1
		BREAK
	WAITFOR DELAY '00:00:01'
END
SET NOCOUNT OFF
GO

USE master
GO

-- ʹ��Զ�̷���Ĺ�Կ����֤��
CREATE CERTIFICATE CERT_SSB_connect_Monitor_Service
FROM FILE = 'd:\ssb\CERT_SSB_connect_Monitor_Service.cer'

-- ͨ��֤�鴴����¼
CREATE LOGIN LOGIN_SSB_REMOTE
FROM CERTIFICATE CERT_SSB_connect_Monitor_Service

--  ��������Ȩ��
GRANT CONNECT ON ENDPOINT::EP_SSB
TO LOGIN_SSB_REMOTE
GO

--============================================================
-- 6. ʹ��֤�齫Զ�̲���ӳ�䵽���ذ�ȫ���� -- ��ԻỰ��ȫģʽ
--============================================================
-- ����һ̨���������ݵĹ�Կ���Ƶ�ָ��Ŀ¼�ű����ɼ���ִ��
SET NOCOUNT ON
DECLARE @FileExists int
WHILE 1 = 1
BEGIN
	EXEC master.dbo.xp_fileexist 'd:\ssb\CERT_SSB_Dialog_Monitor_Service.cer', @FileExists OUTPUT
	IF @FileExists = 1
		BREAK
	WAITFOR DELAY '00:00:01'
END
SET NOCOUNT OFF
GO

USE Monitor_Database
GO

-- �������ذ�ȫ����(�����ǵ�¼������Ӧ�ó����ɫ)
CREATE USER USER_SSB_REMOTE
WITHOUT LOGIN

-- ���� REFERENCES Ȩ��
GRANT REFERENCES ON CONTRACT::[http://schemas.microsoft.com/SQL/Notifications/PostEventNotification]
TO USER_SSB_REMOTE

-- ���� SEND Ȩ��
GRANT SEND ON SERVICE::SRV_Monitor_Client
TO USER_SSB_REMOTE

-- ʹ��Զ�̷���Ĺ�Կ����֤��, ��ͨ��AUTHORIZATIONָ�������û�
CREATE CERTIFICATE CERT_SSB_Dialog_Monitor_Service
AUTHORIZATION USER_SSB_REMOTE 
FROM FILE = 'd:\ssb\CERT_SSB_Dialog_Monitor_Service.cer'

-- ����Զ�̷����
-- ����Ҫ
--CREATE REMOTE SERVICE BINDING RSB_SRV_Monitor_Service
--TO SERVICE 'http://schemas.microsoft.com/SQL/Notifications/EventNotificationService'
--WITH USER = USER_SSB_REMOTE
GO

--============================================================
-- 7. ����·��
--============================================================
-- ����·��
-- һ�㲻ָ����������, ��Ϊ��ط���˿����ж��
-- �������Ҫ, ����ָ����ط���˵� Service Broker ��ʶ
CREATE ROUTE ROUTE_SRV_Monitor_Service
WITH
--	SERVICE_NAME  = N'http://schemas.microsoft.com/SQL/Notifications/EventNotificationService',
--	BROKER_INSTANCE = '<broker_instance_identifier>',
	ADDRESS  = N'TCP://[Server Name]:4022' 
GO



--============================================================
-- 8. ������ɺ�, ���� master ���о������Ķ���
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
--		WHERE name = N'CERT_SSB_connect_Monitor_Client')
--	DROP CERTIFICATE CERT_SSB_connect_Monitor_Client
--
--IF EXISTS(
--		SELECT * FROM sys.certificates
--		WHERE name = N'CERT_SSB_connect_Monitor_Service')
--	DROP CERTIFICATE CERT_SSB_connect_Monitor_Service
--GO
--
---- ɾ�� master ��� master key
--IF EXISTS(
--		SELECT * FROM sys.symmetric_keys
--		WHERE name = N'##MS_DatabaseMasterKey##')
--	DROP MASTER KEY
--GO
