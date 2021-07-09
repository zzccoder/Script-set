-- ===========================================
-- ������������������Ǿ��������, ����Ҫ��֤����Ĳ�����master����ִ��
USE master
GO

-- ===========================================
--��1��  ���������������ݿ�
-- �˲��������������ִ��
-- a. �����������ݿ�
CREATE DATABASE DB_Mirror
ON(
	NAME = DB_Mirror_DATA,
	FILENAME = N'C:\DB_Mirror.mdf'
)
LOG ON(
	NAME = DB_Mirror_LOG,
	FILENAME = N'C:\DB_Mirror.ldf'
)
ALTER DATABASE DB_Mirror SET
	RECOVERY FULL
GO

-- b. ��ȫ����
BACKUP DATABASE DB_Mirror
TO DISK = N'C:\DB_Mirror.bak'
WITH FORMAT
GO


-- ===========================================
--��2��  ��ʼ�������������ݿ�
-- �˲��������������ִ��
-- �����������ݿ����ȫ�����Ѿ����Ƶ� c:\DB_Mirror.bak
RESTORE DATABASE DB_Mirror
FROM DISK = N'C:\DB_Mirror.bak'
WITH REPLACE
	, NORECOVERY
-- ����������ݿ��ļ�Ҫ����ָ��λ��, ����������� Move ѡ��
--	, MOVE 'DB_Mirror_DATA' TO N'C:\DB_Mirror.mdf'
--	, MOVE 'DB_Mirror_LOG' TO N'C:\DB_Mirror.ldf'
GO


-- ===========================================
--��3��  ����������ϵ����ݿ⾵��˵�
-- �˲��������������ִ��
CREATE ENDPOINT EDP_Mirror
	STATE = STARTED 
	AS TCP(
		LISTENER_PORT = 5022,  -- ����˵�ʹ�õ�ͨ�Ŷ˿�
		LISTENER_IP = ALL)     -- ������IP��ַ
    FOR DATABASE_MIRRORING(
		AUTHENTICATION = WINDOWS NTLM, -- Windows �����֤
		ENCRYPTION = DISABLED,         -- ���Դ�������ݼ���,�����Ҫ����,��������Ϊ SUPPORTED �� REQUIRED, ����ѡ������㷨
		ROLE = ALL)                    -- �˵�֧�����е����ݿ⾵���ɫ, Ҳ��������Ϊ WITNESS(����֤������),�� PARTNER(��������)
GO


-- ===========================================
--��4��  ����������ϵ����ݿ⾵��˵�
-- �˲��������������ִ��
CREATE ENDPOINT EDP_Mirror
	STATE = STARTED 
	AS TCP(
		LISTENER_PORT = 5022,  -- ����˵�ʹ�õ�ͨ�Ŷ˿�
		LISTENER_IP = ALL)     -- ������IP��ַ
    FOR DATABASE_MIRRORING(
		AUTHENTICATION = WINDOWS NTLM, -- Windows �����֤
		ENCRYPTION = DISABLED,         -- ���Դ�������ݼ���,�����Ҫ����,��������Ϊ SUPPORTED �� REQUIRED, ����ѡ������㷨
		ROLE = ALL)               -- �˵�֧�����е����ݿ⾵���ɫ, Ҳ��������Ϊ WITNESS(����֤������),�� PARTNER(��������)
GO


-- ===========================================
--��5��  �ھ�����������������ݿ⾵��
-- �˲��������������ִ��
ALTER DATABASE DB_Mirror SET
	PARTNER = 'TCP://SrvA:5022'
GO


-- ===========================================
--��6��  ��������������������ݿ⾵��,������Ϊ�߿�����ģʽ
-- �˲��������������ִ��
ALTER DATABASE DB_Mirror SET
	PARTNER = 'TCP://SrvB:5022'

ALTER DATABASE DB_Mirror SET
	SAFETY OFF
GO



-- ===========================================
-- ����Ĳ���������ȷ��ͬ��
-- 1. ��ѯ���ݿ�״̬
-- ����Ľű�����������������;����������ִ��,ִ�н��Ϊ�����״̬
SELECT 
	mirroring_role_desc,           -- ���ݿ��ھ���Ự�е�ǰ�Ľ�ɫ
	mirroring_state_desc,          -- ����ǰ״̬
	mirroring_safety_level_desc,   -- ��������ģʽ
	mirroring_witness_state_desc   -- ���֤���������������
FROM sys.database_mirroring
WHERE database_id = DB_ID(N'DB_Mirror')
GO

-- 2. ���ݲ���
-- b. �����������ִ�����������Խ������Ա�
CREATE TABLE DB_Mirror.dbo.tb(
	id int)
WAITFOR DELAY '00:00:01'
GO

-- b. �����������, �����������ݿ�Ŀ������ݿ�,�Ա���Բ�ѯ��ǰ������
CREATE DATABASE SNP_DB_Mirror
ON(
	NAME = DB_Mirror_DATA,
	FILENAME = N'C:\SNP_DB_Mirror.mdf')
AS SNAPSHOT OF DB_Mirror
GO

-- c. �ӿ������ݿ��в�ѯ���Ա��Ƿ��Ѿ�ͬ��
SELECT * FROM SNP_DB_Mirror.dbo.tb
GO

-- d. ɾ�����Խ����Ŀ������ݿ�
DROP DATABASE SNP_DB_Mirror
GO


-- ===========================================
-- ����Ĳ�������ɾ����ʾ�����õľ������
--  ֤������ݿ�ı�����Ҫ�ڲ���ϵͳ����Դ��������ɾ��
-- 1. �����������ִ�еĲ���
-- a. ֹͣ�����ɾ���������ݿ�
USE master
GO

ALTER DATABASE DB_Mirror SET
	PARTNER OFF
DROP DATABASE DB_Mirror
GO

-- b. ɾ������˵�
DROP ENDPOINT EDP_Mirror
GO


-- 1. �����������ִ�еĲ���
-- a. ɾ���������ݿ�
USE master
GO

DROP DATABASE DB_Mirror
GO

-- b. ɾ������˵�
DROP ENDPOINT EDP_Mirror
GO
