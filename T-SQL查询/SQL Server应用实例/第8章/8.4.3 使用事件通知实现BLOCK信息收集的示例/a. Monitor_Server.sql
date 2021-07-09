/*--=======================================================================
-- �ű���ʹ�õı�� 
[Server Name]	             �滻Ϊ��ط�����(��ؿͻ���)�ķ���������IP��ַ
<broker_instance_identifier> �滻Ϊ��ط�����(��ؿͻ���)�� Service Broker ��ʶ
=======================================================================--*/

--============================================================
-- 1. ����������ݿ�
--============================================================
-- Block�Ƿ���������SQL�¼�, ��ʹ��msdb��
-- ��˷�����ϴ˲��費��Ҫ���κδ���

--============================================================
-- 2. ���� Service Broker �������
--============================================================
-- �¼�֪ͨ�ڽ�����ض���, ���Է�����ϴ˲��費��Ҫ���κδ���

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
CREATE CERTIFICATE CERT_SSB_connect_Monitor_Service
WITH 
	SUBJECT = 'CERT_SSB_connect', 
	START_DATE = '1/1/2001',
	EXPIRY_DATE = '12/1/9999'
GO

-- ����֤��
BACKUP CERTIFICATE CERT_SSB_connect_Monitor_Service
TO FILE = 'd:\ssb\CERT_SSB_connect_Monitor_Service.cer'
GO

-- �˵�
CREATE ENDPOINT EP_SSB
STATE = STARTED
AS TCP(
	LISTENER_PORT = 4022)
FOR SERVICE_BROKER(
	AUTHENTICATION = CERTIFICATE CERT_SSB_connect_Monitor_Service)
GO

--============================================================
-- 4. �����Ự��ȫģʽ�����֤�鼰��Կ�ı���(��ҪMASTER KEY)
--============================================================
USE msdb
GO

-- master key
CREATE MASTER KEY
ENCRYPTION BY PASSWORD = N'Service Broker�����ݿ������Կ�ԻỰ��Կ���м���'
GO

-- ֤��
CREATE CERTIFICATE CERT_SSB_Dialog_Monitor_Service
WITH 
	SUBJECT = 'CERT_SSB_Dialog', 
	START_DATE = '1/1/2001',
	EXPIRY_DATE = '12/1/9999'
GO

-- ����֤��
BACKup CERTIFICATE CERT_SSB_Dialog_Monitor_Service
TO FILE = 'd:\ssb\CERT_SSB_Dialog_Monitor_Service.cer'
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
	EXEC master.dbo.xp_fileexist 'd:\ssb\CERT_SSB_connect_Monitor_Client.cer', @FileExists OUTPUT
	IF @FileExists = 1
		BREAK
	WAITFOR DELAY '00:00:01'
END
SET NOCOUNT OFF
GO

USE master
GO

-- ʹ��Զ�̷���Ĺ�Կ����֤��
CREATE CERTIFICATE CERT_SSB_connect_Monitor_Client
FROM FILE = 'd:\ssb\CERT_SSB_connect_Monitor_Client.cer'

-- ͨ��֤�鴴����¼
CREATE LOGIN LOGIN_SSB_REMOTE
FROM CERTIFICATE CERT_SSB_connect_Monitor_Client

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
	EXEC master.dbo.xp_fileexist 'd:\ssb\CERT_SSB_Dialog_Monitor_Client.cer', @FileExists OUTPUT
	IF @FileExists = 1
		BREAK
	WAITFOR DELAY '00:00:01'
END
SET NOCOUNT OFF
GO

USE msdb
GO

-- �������ذ�ȫ����(�����ǵ�¼������Ӧ�ó����ɫ)
CREATE USER USER_SSB_REMOTE
WITHOUT LOGIN

-- ���� SEND Ȩ��
GRANT SEND ON SERVICE::[http://schemas.microsoft.com/SQL/Notifications/EventNotificationService]
TO USER_SSB_REMOTE

-- ʹ��Զ�̷���Ĺ�Կ����֤��, ��ͨ��AUTHORIZATIONָ�������û�
CREATE CERTIFICATE CERT_SSB_Dialog_Monitor_Client
AUTHORIZATION USER_SSB_REMOTE 
FROM FILE = 'd:\ssb\CERT_SSB_Dialog_Monitor_Client.cer'

-- ����Զ�̷����
CREATE REMOTE SERVICE BINDING RSB_SRV_Monitor_Client
TO SERVICE 'SRV_Monitor_Client'
WITH USER = USER_SSB_REMOTE
GO

--============================================================
-- 7. ����·��
--============================================================
-- ����·��
CREATE ROUTE ROUTE_SRV_Monitor_Client
WITH
	SERVICE_NAME  = N'SRV_Monitor_Client',
	BROKER_INSTANCE = '<broker_instance_identifier>',
	ADDRESS  = N'TCP://[Server Name]:4022' 
GO


--============================================================
-- 8. ������ط���˵� blocked process threshold ����
--============================================================
EXEC sp_configure 'show advanced options', 1
RECONFIGURE
GO

EXEC sp_configure 'blocked process threshold', 10
RECONFIGURE
GO

--============================================================
-- 9. �����¼�֪ͨ
--============================================================
CREATE EVENT NOTIFICATION ENTN_Block
ON SERVER
FOR BLOCKED_PROCESS_REPORT
TO SERVICE 'SRV_Monitor_Client', 
		'<broker_instance_identifier>'
GO

--============================================================
-- 10. ������ɺ�, ���� master ���о������Ķ���
--    ���²����ڲ�����ɺ�ִ��
--============================================================
--USE master
--GO
--
---- ɾ�� EVENT NOTIFICATION
--IF EXISTS(
--		SELECT * FROM sys.server_event_notifications
--		WHERE name = N'ENTN_Block')
--	DROP EVENT NOTIFICATION ENTN_Block
--	ON SERVER
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
--
----ɾ�� msdb ���еĲ��Զ���
--USE msdb
--GO
--
---- ɾ��·��
--IF EXISTS(
--		SELECT * FROM sys.routes
--		WHERE name = N'ROUTE_SRV_Monitor_Client')
--	DROP ROUTE ROUTE_SRV_Monitor_Client
--GO
--
---- ɾ��Զ�̷����
--IF EXISTS(
--		SELECT * FROM sys.remote_service_bindings
--		WHERE name = N'RSB_SRV_Monitor_Client')
--	DROP REMOTE SERVICE BINDING RSB_SRV_Monitor_Client
--GO
--
---- ɾ��֤��
--IF EXISTS(
--		SELECT * FROM sys.certificates
--		WHERE name = N'CERT_SSB_Dialog_Monitor_Service')
--	DROP CERTIFICATE CERT_SSB_Dialog_Monitor_Service
--GO
--IF EXISTS(
--		SELECT * FROM sys.certificates
--		WHERE name = N'CERT_SSB_Dialog_Monitor_Client')
--	DROP CERTIFICATE CERT_SSB_Dialog_Monitor_Client
--GO
--
---- ɾ�����ذ�ȫ����
--IF EXISTS(
--		SELECT * FROM sys.database_principals 
--		WHERE name = N'USER_SSB_REMOTE')
--	DROP USER USER_SSB_REMOTE
--GO
--
---- ɾ�� msdb ��� master key
--IF EXISTS(
--		SELECT * FROM sys.symmetric_keys
--		WHERE name = N'##MS_DatabaseMasterKey##')
--	DROP MASTER KEY
--GO

