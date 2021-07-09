--=============================================
-- 1. 建立 Service Broker 服务对象
--=============================================
-- 开启 Service Broker 功能(准备在tempdb库中做演示)
ALTER DATABASE tempdb SET ENABLE_BROKER
GO

USE tempdb
GO

-- 创建一个可以发送任何数据的消息类型
CREATE MESSAGE TYPE MSGT_Message
VALIDATION = NONE

-- 创建一个约定, 表示对话使用的消息类型是 MSGT_Message
-- 并且标明消息可以由任意一方发送
CREATE CONTRACT CT_MessageAny(
	MSGT_Message SENT BY ANY)

-- 创建两个队列
CREATE QUEUE Q_A
WITH
	STATUS = ON

CREATE QUEUE Q_B
WITH
	STATUS = ON

-- 创建对话的双方(两个服务)
CREATE SERVICE SRV_A
ON QUEUE Q_A(
	CT_MessageAny)

CREATE SERVICE SRV_B
ON QUEUE Q_B(
	CT_MessageAny)
GO

--=============================================
-- 2. 建立对话用的消息接收和发送的存储过程
--=============================================
-- 消息接收存储过程 A
CREATE PROC dbo.p_ReceiveA
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
				FROM Q_A
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

-- 消息接收存储过程 B
CREATE PROC dbo.p_ReceiveB
AS
SET NOCOUNT ON
WHILE 1 = 1          -- 存储过程启动后一直接收消息
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
				FROM Q_B
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


-- 消息发送存储过程 A
CREATE PROC dbo.p_SendA
	@msg nvarchar(4000)
AS
SET NOCOUNT ON
	DECLARE 
		@handle uniqueidentifier
	BEGIN DIALOG CONVERSATION @handle
		FROM SERVICE SRV_A
		TO SERVICE 'SRV_B'
		ON CONTRACT CT_MessageAny
		WITH ENCRYPTION = OFF;
	SEND ON CONVERSATION @handle
		MESSAGE TYPE MSGT_Message(
			@msg)
GO

-- 消息发送存储过程 B
CREATE PROC dbo.p_SendB
	@msg nvarchar(4000)
AS
SET NOCOUNT ON
	DECLARE 
		@handle uniqueidentifier
	BEGIN DIALOG CONVERSATION @handle
		FROM SERVICE SRV_B
		TO SERVICE 'SRV_A'
		ON CONTRACT CT_MessageAny
		WITH ENCRYPTION = OFF;
	SEND ON CONVERSATION @handle
		MESSAGE TYPE MSGT_Message(
			@msg)
GO


--=============================================
-- 3. 测试完成后删除测试环境
--=============================================
/*--
DROP PROC 
	dbo.p_ReceiveA, dbo.p_ReceiveB,
	dbo.p_SendA, dbo.p_SendB

DROP SERVICE SRV_A
DROP SERVICE SRV_B

DROP QUEUE Q_A
DROP QUEUE Q_B

DROP CONTRACT CT_MessageAny

DROP MESSAGE TYPE MSGT_Message
--*/