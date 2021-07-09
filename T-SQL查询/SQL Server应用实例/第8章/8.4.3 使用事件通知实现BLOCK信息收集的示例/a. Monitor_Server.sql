/*--=======================================================================
-- 脚本中使用的标记 
[Server Name]	             替换为监控服务器(监控客户端)的服务器名或IP地址
<broker_instance_identifier> 替换为监控服务器(监控客户端)的 Service Broker 标识
=======================================================================--*/

--============================================================
-- 1. 建立监控数据库
--============================================================
-- Block是服务器级的SQL事件, 它使用msdb库
-- 因此服务端上此步骤不需要做任何处理

--============================================================
-- 2. 建立 Service Broker 服务对象
--============================================================
-- 事件通知内建有相关对象, 所以服务端上此步骤不需要做任何处理

--============================================================
-- 3. 在 master 中建立传输安全模式所需证书及Service Broker端点
--============================================================
USE master
GO

-- master key
CREATE MASTER KEY
ENCRYPTION BY PASSWORD = N'Service Broker用数据库的主密钥对会话密钥进行加密'
GO

-- 传输安全模式所需的证书
CREATE CERTIFICATE CERT_SSB_connect_Monitor_Service
WITH 
	SUBJECT = 'CERT_SSB_connect', 
	START_DATE = '1/1/2001',
	EXPIRY_DATE = '12/1/9999'
GO

-- 备份证书
BACKUP CERTIFICATE CERT_SSB_connect_Monitor_Service
TO FILE = 'd:\ssb\CERT_SSB_connect_Monitor_Service.cer'
GO

-- 端点
CREATE ENDPOINT EP_SSB
STATE = STARTED
AS TCP(
	LISTENER_PORT = 4022)
FOR SERVICE_BROKER(
	AUTHENTICATION = CERTIFICATE CERT_SSB_connect_Monitor_Service)
GO

--============================================================
-- 4. 建立会话安全模式所需的证书及公钥的备份(需要MASTER KEY)
--============================================================
USE msdb
GO

-- master key
CREATE MASTER KEY
ENCRYPTION BY PASSWORD = N'Service Broker用数据库的主密钥对会话密钥进行加密'
GO

-- 证书
CREATE CERTIFICATE CERT_SSB_Dialog_Monitor_Service
WITH 
	SUBJECT = 'CERT_SSB_Dialog', 
	START_DATE = '1/1/2001',
	EXPIRY_DATE = '12/1/9999'
GO

-- 备份证书
BACKup CERTIFICATE CERT_SSB_Dialog_Monitor_Service
TO FILE = 'd:\ssb\CERT_SSB_Dialog_Monitor_Service.cer'
GO



--============================================================
-- 5. 使用证书将远程操作映射到本地安全主体 -- 针对传输安全模式
--============================================================
-- 等待证书公钥复制到指定位置
-- 将另一台服务器备份的公钥复制到指定目录脚本即可继续执行
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

-- 使用远程服务的公钥创建证书
CREATE CERTIFICATE CERT_SSB_connect_Monitor_Client
FROM FILE = 'd:\ssb\CERT_SSB_connect_Monitor_Client.cer'

-- 通过证书创建登录
CREATE LOGIN LOGIN_SSB_REMOTE
FROM CERTIFICATE CERT_SSB_connect_Monitor_Client

--  授予连接权限
GRANT CONNECT ON ENDPOINT::EP_SSB
TO LOGIN_SSB_REMOTE
GO

--============================================================
-- 6. 使用证书将远程操作映射到本地安全主体 -- 针对会话安全模式
--============================================================
-- 将另一台服务器备份的公钥复制到指定目录脚本即可继续执行
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

-- 建立本地安全主体(可以是登录名或者应用程序角色)
CREATE USER USER_SSB_REMOTE
WITHOUT LOGIN

-- 授予 SEND 权限
GRANT SEND ON SERVICE::[http://schemas.microsoft.com/SQL/Notifications/EventNotificationService]
TO USER_SSB_REMOTE

-- 使用远程服务的公钥创建证书, 并通过AUTHORIZATION指定本地用户
CREATE CERTIFICATE CERT_SSB_Dialog_Monitor_Client
AUTHORIZATION USER_SSB_REMOTE 
FROM FILE = 'd:\ssb\CERT_SSB_Dialog_Monitor_Client.cer'

-- 创建远程服务绑定
CREATE REMOTE SERVICE BINDING RSB_SRV_Monitor_Client
TO SERVICE 'SRV_Monitor_Client'
WITH USER = USER_SSB_REMOTE
GO

--============================================================
-- 7. 建立路由
--============================================================
-- 创建路由
CREATE ROUTE ROUTE_SRV_Monitor_Client
WITH
	SERVICE_NAME  = N'SRV_Monitor_Client',
	BROKER_INSTANCE = '<broker_instance_identifier>',
	ADDRESS  = N'TCP://[Server Name]:4022' 
GO


--============================================================
-- 8. 启动监控服务端的 blocked process threshold 功能
--============================================================
EXEC sp_configure 'show advanced options', 1
RECONFIGURE
GO

EXEC sp_configure 'blocked process threshold', 10
RECONFIGURE
GO

--============================================================
-- 9. 创建事件通知
--============================================================
CREATE EVENT NOTIFICATION ENTN_Block
ON SERVER
FOR BLOCKED_PROCESS_REPORT
TO SERVICE 'SRV_Monitor_Client', 
		'<broker_instance_identifier>'
GO

--============================================================
-- 10. 测试完成后, 清理 master 库中经建立的东西
--    以下部分在测试完成后执行
--============================================================
--USE master
--GO
--
---- 删除 EVENT NOTIFICATION
--IF EXISTS(
--		SELECT * FROM sys.server_event_notifications
--		WHERE name = N'ENTN_Block')
--	DROP EVENT NOTIFICATION ENTN_Block
--	ON SERVER
--GO
--
---- 删除 Service Broker 端点
--IF EXISTS(
--		SELECT * FROM sys.endpoints
--		WHERE name = N'EP_SSB')
--	DROP ENDPOINT EP_SSB
--GO
--
---- 删除登录
--IF EXISTS(
--		SELECT * FROM sys.server_principals
--		WHERE name = N'LOGIN_SSB_REMOTE')
--	DROP LOGIN LOGIN_SSB_REMOTE
--GO
--
---- 删除证书
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
---- 删除 master 库的 master key
--IF EXISTS(
--		SELECT * FROM sys.symmetric_keys
--		WHERE name = N'##MS_DatabaseMasterKey##')
--	DROP MASTER KEY
--GO
--
----删除 msdb 库中的测试对象
--USE msdb
--GO
--
---- 删除路由
--IF EXISTS(
--		SELECT * FROM sys.routes
--		WHERE name = N'ROUTE_SRV_Monitor_Client')
--	DROP ROUTE ROUTE_SRV_Monitor_Client
--GO
--
---- 删除远程服务绑定
--IF EXISTS(
--		SELECT * FROM sys.remote_service_bindings
--		WHERE name = N'RSB_SRV_Monitor_Client')
--	DROP REMOTE SERVICE BINDING RSB_SRV_Monitor_Client
--GO
--
---- 删除证书
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
---- 删除本地安全主体
--IF EXISTS(
--		SELECT * FROM sys.database_principals 
--		WHERE name = N'USER_SSB_REMOTE')
--	DROP USER USER_SSB_REMOTE
--GO
--
---- 删除 msdb 库的 master key
--IF EXISTS(
--		SELECT * FROM sys.symmetric_keys
--		WHERE name = N'##MS_DatabaseMasterKey##')
--	DROP MASTER KEY
--GO

