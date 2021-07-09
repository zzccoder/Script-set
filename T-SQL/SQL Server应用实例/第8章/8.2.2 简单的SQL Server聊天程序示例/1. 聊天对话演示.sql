--=============================================
-- 1. ���� Service Broker �������
--=============================================
-- ���� Service Broker ����(׼����tempdb��������ʾ)
ALTER DATABASE tempdb SET ENABLE_BROKER
GO

USE tempdb
GO

-- ����һ�����Է����κ����ݵ���Ϣ����
CREATE MESSAGE TYPE MSGT_Message
VALIDATION = NONE

-- ����һ��Լ��, ��ʾ�Ի�ʹ�õ���Ϣ������ MSGT_Message
-- ���ұ�����Ϣ����������һ������
CREATE CONTRACT CT_MessageAny(
	MSGT_Message SENT BY ANY)

-- ������������
CREATE QUEUE Q_A
WITH
	STATUS = ON

CREATE QUEUE Q_B
WITH
	STATUS = ON

-- �����Ի���˫��(��������)
CREATE SERVICE SRV_A
ON QUEUE Q_A(
	CT_MessageAny)

CREATE SERVICE SRV_B
ON QUEUE Q_B(
	CT_MessageAny)
GO

--=============================================
-- 2. �����Ի��õ���Ϣ���պͷ��͵Ĵ洢����
--=============================================
-- ��Ϣ���մ洢���� A
CREATE PROC dbo.p_ReceiveA
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
				FROM Q_A
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

-- ��Ϣ���մ洢���� B
CREATE PROC dbo.p_ReceiveB
AS
SET NOCOUNT ON
WHILE 1 = 1          -- �洢����������һֱ������Ϣ
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
				FROM Q_B
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


-- ��Ϣ���ʹ洢���� A
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

-- ��Ϣ���ʹ洢���� B
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
-- 3. ������ɺ�ɾ�����Ի���
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