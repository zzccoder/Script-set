/*--=======================================================================
-- 脚本中使用的标记 
@@@_A_@@@		在 A 服务端使用时, 替换为 A ; 在 B 服务端使用时, 替换为 B
@@@_B_@@@		在 A 服务端使用时, 替换为 B ; 在 B 服务端使用时, 替换为 A
[Server Name]	在 A 服务端使用时, 替换为 B 服务器名或IP地址;
				在 B 服务端使用时, 替换为 A 服务器名或IP地址
=======================================================================--*/

--============================================================
-- 1. 建立消息数据库
--============================================================
USE master
GO

IF DB_ID(N'TM_Database') IS NOT NULL
	DROP DATABASE TM_Database
CREATE DATABASE TM_Database
ALTER DATABASE TM_Database SET ENABLE_BROKER
GO

--============================================================
-- 2. 建立 Service Broker 服务对象
--============================================================
USE TM_Database
GO

-- 创建一个可以发送任何数据的消息类型
CREATE MESSAGE TYPE MSGT_Message
VALIDATION = NONE

-- 创建一个约定, 表示对话使用的消息类型是 MSGT_Message
-- 并且标明消息可以由任意一方发送
CREATE CONTRACT CT_MessageAny(
	MSGT_Message SENT BY ANY)

-- 创建存储消息的队列
CREATE QUEUE Q_Message
WITH
	STATUS = ON

-- 创建对话的双方之一
CREATE SERVICE [SRV_@@@_A_@@@]
ON QUEUE Q_Message(
	CT_MessageAny)
GO

--============================================================
-- 3. 建立对话用的消息接收和发送的存储过程
--============================================================
-- 消息接收存储过程
CREATE PROC dbo.p_Receive
AS
SET NOCOUNT ON
WHILE 1 = 1   -- 存储过程启动后一直接收消息
BEGIN 
	DECLARE 
		@handle uniqueidentifier,
		@msg_type sysname,
		@message varbinary(max)
	BEGIN TRY
		BEGIN TRAN
			WAITFOR(              -- 等待, 直到收到一条消息
				RECEIVE TOP(1)   
					@handle = conversation_handle,
					@msg_type = message_type_name,
					@message = message_body
				FROM Q_Message
			)
			IF @msg_type = N'MSGT_Message'  -- 如果是正常对话的消息, 则显示
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

-- 消息发送存储过程
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
-- 4. 在 master 中建立传输安全模式所需证书及Service Broker端点
--============================================================
USE master
GO

-- master key
CREATE MASTER KEY
ENCRYPTION BY PASSWORD = N'Service Broker用数据库的主密钥对会话密钥进行加密'
GO

-- 传输安全模式所需的证书
CREATE CERTIFICATE [CERT_SSB_connect_@@@_A_@@@]
WITH 
	SUBJECT = 'CERT_SSB_connect', 
	START_DATE = '1/1/2001',
	EXPIRY_DATE = '12/1/9999'
GO

-- 备份证书
BACKUP CERTIFICATE [CERT_SSB_connect_@@@_A_@@@]
TO FILE = 'd:\ssb\CERT_SSB_connect_@@@_A_@@@.cer'
GO

-- 端点
CREATE ENDPOINT EP_SSB
STATE = STARTED
AS TCP(
	LISTENER_PORT = 4022)
FOR SERVICE_BROKER(
	AUTHENTICATION = CERTIFICATE [CERT_SSB_connect_@@@_A_@@@])
GO

--============================================================
-- 5. 建立会话安全模式所需的证书及公钥的备份(需要MASTER KEY)
--============================================================
USE TM_Database
GO

-- master key
CREATE MASTER KEY
ENCRYPTION BY PASSWORD = N'Service Broker用数据库的主密钥对会话密钥进行加密'
GO

-- 证书
CREATE CERTIFICATE [CERT_SSB_Dialog_SRV_@@@_A_@@@]
WITH 
	SUBJECT = 'CERT_SSB_Dialog', 
	START_DATE = '1/1/2001',
	EXPIRY_DATE = '12/1/9999'
GO

-- 备份证书
BACKup CERTIFICATE [CERT_SSB_Dialog_SRV_@@@_A_@@@]
TO FILE = 'd:\ssb\CERT_SSB_Dialog_SRV_@@@_A_@@@.cer'
GO



--============================================================
-- 6. 使用证书将远程操作映射到本地安全主体 -- 针对传输安全模式
--============================================================
-- 等待证书公钥复制到指定位置
-- 将另一台服务器备份的公钥复制到指定目录脚本即可继续执行
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

-- 使用远程服务的公钥创建证书
CREATE CERTIFICATE [CERT_SSB_connect_@@@_B_@@@]
FROM FILE = 'd:\ssb\CERT_SSB_connect_@@@_B_@@@.cer'

-- 通过证书创建登录
CREATE LOGIN LOGIN_SSB_REMOTE
FROM CERTIFICATE [CERT_SSB_connect_@@@_B_@@@]

--  授予连接权限
GRANT CONNECT ON ENDPOINT::EP_SSB
TO LOGIN_SSB_REMOTE
GO

--============================================================
-- 7. 使用证书将远程操作映射到本地安全主体 -- 针对会话安全模式
--============================================================
-- 将另一台服务器备份的公钥复制到指定目录脚本即可继续执行
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

-- 建立本地安全主体(可以是登录名或者应用程序角色)
CREATE USER USER_SSB_REMOTE
WITHOUT LOGIN

-- 授予 SEND 权限
GRANT SEND ON SERVICE::[SRV_@@@_A_@@@]
TO USER_SSB_REMOTE

-- 使用远程服务的公钥创建证书, 并通过AUTHORIZATION指定本地用户
CREATE CERTIFICATE [CERT_SSB_Dialog_SRV_@@@_B_@@@]
AUTHORIZATION USER_SSB_REMOTE 
FROM FILE = 'd:\ssb\CERT_SSB_Dialog_SRV_@@@_B_@@@.cer'

-- 创建远程服务绑定
CREATE REMOTE SERVICE BINDING [RSB_SRV_@@@_B_@@@]
TO SERVICE 'SRV_@@@_B_@@@'
WITH USER = USER_SSB_REMOTE

--============================================================
-- 8. 建立路由
--============================================================
-- 创建路由
CREATE ROUTE [ROUTE_SRV_@@@_B_@@@]
WITH  SERVICE_NAME  = N'SRV_@@@_B_@@@' ,  
ADDRESS  = N'TCP://[Server Name]:4022' 
GO



--============================================================
-- 9. 测试完成后, 清理 master 库中经建立的东西
--    以下部分在测试完成后执行
--============================================================
--USE master
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
--		WHERE name = N'CERT_SSB_connect_A')
--	DROP CERTIFICATE [CERT_SSB_connect_A]
--
--IF EXISTS(
--		SELECT * FROM sys.certificates
--		WHERE name = N'CERT_SSB_connect_B')
--	DROP CERTIFICATE [CERT_SSB_connect_B]
--GO
--
---- 删除 master 库的 master key
--IF EXISTS(
--		SELECT * FROM sys.symmetric_keys
--		WHERE name = N'##MS_DatabaseMasterKey##')
--	DROP MASTER KEY
--GO
