-- ===========================================
-- ��������������������������, ���Ǽ�֤������
-- ���ر�˵���⣬����Ҫ��֤����Ĳ�����master����ִ��
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
--��3��  ����������ϵ����ݿ⾵��˵㼰�����֤�õ�֤��
-- �˲��������������ִ��
-- a. �������ݿ⾵��˵������֤��֤��
IF NOT EXISTS(  -- ʹ�����ݿ�����Կ����֤��
		SELECT * FROM sys.symmetric_keys
		WHERE name = N'##MS_DatabaseMasterKey##')
	CREATE MASTER KEY
		ENCRYPTION BY PASSWORD = N'abc.123'

CREATE CERTIFICATE CT_Mirror_SrvA
WITH
	SUBJECT = N'certificate for database mirror',
	START_DATE = '19990101',
	EXPIRY_DATE = '99991231'
GO

-- b. ����֤��, �Ա�����˶˵�ͨ�ŵ���һ�˽�����֤��
BACKUP CERTIFICATE CT_Mirror_SrvA
TO FILE = 'C:\CT_Mirror_SrvA.cer'
GO

-- c. ���ݿ⾵��˵�
CREATE ENDPOINT EDP_Mirror
	STATE = STARTED 
	AS TCP(
		LISTENER_PORT = 5022,  -- ����˵�ʹ�õ�ͨ�Ŷ˿�
		LISTENER_IP = ALL)     -- ������IP��ַ
    FOR DATABASE_MIRRORING(
		AUTHENTICATION = CERTIFICATE CT_Mirror_SrvA, -- ֤�������֤
		ENCRYPTION = DISABLED,                       -- ���Դ�������ݼ���,�����Ҫ����,��������Ϊ SUPPORTED �� REQUIRED, ����ѡ������㷨
		ROLE = ALL)                                  -- �˵�֧�����е����ݿ⾵���ɫ, Ҳ��������Ϊ WITNESS(����֤������),�� PARTNER(��������)
GO


-- ===========================================
--��4��  ����������ϵ����ݿ⾵��˵㼰�����֤�õ�֤��
-- �˲��������������ִ��
-- a. �������ݿ⾵��˵������֤��֤��
IF NOT EXISTS(  -- ʹ�����ݿ�����Կ����֤��
		SELECT * FROM sys.symmetric_keys
		WHERE name = N'##MS_DatabaseMasterKey##')
	CREATE MASTER KEY
		ENCRYPTION BY PASSWORD = N'abc.123'

CREATE CERTIFICATE CT_Mirror_SrvB
WITH
	SUBJECT = N'certificate for database mirror',
	START_DATE = '19990101',
	EXPIRY_DATE = '99991231'
GO

-- b. ����֤��, �Ա�����˶˵�ͨ�ŵ���һ�˽�����֤��
BACKUP CERTIFICATE CT_Mirror_SrvB
TO FILE = 'C:\CT_Mirror_SrvB.cer'
GO

-- c. ���ݿ⾵��˵�
CREATE ENDPOINT EDP_Mirror
	STATE = STARTED 
	AS TCP(
		LISTENER_PORT = 5022,  -- ����˵�ʹ�õ�ͨ�Ŷ˿�
		LISTENER_IP = ALL)     -- ������IP��ַ
    FOR DATABASE_MIRRORING(
		AUTHENTICATION = CERTIFICATE CT_Mirror_SrvB, -- ֤�������֤
		ENCRYPTION = DISABLED,                       -- ���Դ�������ݼ���,�����Ҫ����,��������Ϊ SUPPORTED �� REQUIRED, ����ѡ������㷨
		ROLE = ALL)                                  -- �˵�֧�����е����ݿ⾵���ɫ, Ҳ��������Ϊ WITNESS(����֤������),�� PARTNER(��������)
GO


-- ===========================================
--��5��  �ھ�������������������������ݿ⾵��˵�Ĵ��䰲ȫģʽ����
-- �˲��������������ִ��
-- a. ��������������ϵ�֤��(��������������ϱ��ݵ�֤���Ѿ����Ƶ� C:\CT_Mirror_SrvA.cer)
CREATE CERTIFICATE CT_Mirror_SrvA
FROM FILE = 'C:\CT_Mirror_SrvA.cer'

-- b. ������¼
CREATE LOGIN LOGIN_Mirror_SrvA
FROM CERTIFICATE CT_Mirror_SrvA

-- c. ��������ݿ⾵��˵�� connect Ȩ��
GRANT CONNECT ON ENDPOINT::EDP_Mirror
TO LOGIN_Mirror_SrvA
GO


-- ===========================================
--��6��  ���������������ɾ�����������ݿ⾵��˵�Ĵ��䰲ȫģʽ����
-- �˲��������������ִ��
-- a. ��������������ϵ�֤��(���辵��������ϱ��ݵ�֤���Ѿ����Ƶ� C:\CT_Mirror_SrvB.cer)
CREATE CERTIFICATE CT_Mirror_SrvB
FROM FILE = 'C:\CT_Mirror_SrvB.cer'

-- b. ������¼
CREATE LOGIN LOGIN_Mirror_SrvB
FROM CERTIFICATE CT_Mirror_SrvB

-- c. ��������ݿ⾵��˵�� connect Ȩ��
GRANT CONNECT ON ENDPOINT::EDP_Mirror
TO LOGIN_Mirror_SrvB
GO


-- ===========================================
--��7��  �ھ�����������������ݿ⾵��
-- �˲��������������ִ��
ALTER DATABASE DB_Mirror SET
	PARTNER = 'TCP://SrvA:5022'
GO


-- ===========================================
--��8��  ��������������������ݿ⾵��(Ĭ��Ϊ�߰�ȫ��ģʽ,���Բ��ý���ģʽ����)
-- �˲��������������ִ��
ALTER DATABASE DB_Mirror SET
	PARTNER = 'TCP://SrvB:5022'
GO


-- ===========================================
--��9��  ���ü�֤������
-- �˲����ڼ�֤��������ִ��
-- a. ��ɼ�֤�����������ݿ⾵��˵�Ĵ��䰲ȫģʽ����
-- (a). �������ݿ⾵��˵������֤��֤��
IF NOT EXISTS(  -- ʹ�����ݿ�����Կ����֤��
		SELECT * FROM sys.symmetric_keys
		WHERE name = N'##MS_DatabaseMasterKey##')
	CREATE MASTER KEY
		ENCRYPTION BY PASSWORD = N'abc.123'

CREATE CERTIFICATE CT_Mirror_SrvWitness
WITH
	SUBJECT = N'certificate for database mirror',
	START_DATE = '19990101',
	EXPIRY_DATE = '99991231'
GO

-- (b). ����֤��, �Ա�����˶˵�ͨ�ŵ���һ�˽�����֤��
BACKUP CERTIFICATE CT_Mirror_SrvWitness
TO FILE = 'C:\CT_Mirror_SrvWitness.cer'
GO

-- (c). ���ݿ⾵��˵�
CREATE ENDPOINT EDP_Mirror
	STATE = STARTED 
	AS TCP(
		LISTENER_PORT = 5022,  -- ����˵�ʹ�õ�ͨ�Ŷ˿�
		LISTENER_IP = ALL)     -- ������IP��ַ
    FOR DATABASE_MIRRORING(
		AUTHENTICATION = CERTIFICATE CT_Mirror_SrvWitness, -- ֤�������֤
		ENCRYPTION = DISABLED,                             -- ���Դ�������ݼ���,�����Ҫ����,��������Ϊ SUPPORTED �� REQUIRED, ����ѡ������㷨
		ROLE = ALL)                                        -- �˵�֧�����е����ݿ⾵���ɫ, Ҳ��������Ϊ WITNESS(����֤������),�� PARTNER(��������)
GO

-- b. �����������������ݿ⾵��˵�Ĵ��䰲ȫģʽ����
-- (a). ��������������ϵ�֤��(��������������ϱ��ݵ�֤���Ѿ����Ƶ� C:\CT_Mirror_SrvA.cer)
CREATE CERTIFICATE CT_Mirror_SrvA
FROM FILE = 'C:\CT_Mirror_SrvA.cer'

-- (b). ������¼
CREATE LOGIN LOGIN_Mirror_SrvA
FROM CERTIFICATE CT_Mirror_SrvA

-- (c). ��������ݿ⾵��˵�� connect Ȩ��
GRANT CONNECT ON ENDPOINT::EDP_Mirror
TO LOGIN_Mirror_SrvA
GO

-- c. ��ɾ�������������ݿ⾵��˵�Ĵ��䰲ȫģʽ����
-- (a). ��������������ϵ�֤��(���辵��������ϱ��ݵ�֤���Ѿ����Ƶ� C:\CT_Mirror_SrvB.cer)
CREATE CERTIFICATE CT_Mirror_SrvB
FROM FILE = 'C:\CT_Mirror_SrvB.cer'

-- (b). ������¼
CREATE LOGIN LOGIN_Mirror_SrvB
FROM CERTIFICATE CT_Mirror_SrvB

-- (c). ��������ݿ⾵��˵�� connect Ȩ��
GRANT CONNECT ON ENDPOINT::EDP_Mirror
TO LOGIN_Mirror_SrvB
GO


-- ===========================================
--��10��  �ھ������������ɼ�֤���������ݿ⾵��˵�Ĵ��䰲ȫģʽ����
-- �˲��������������ִ��
-- a. ������֤�������ϵ�֤��(�����֤�������ϱ��ݵ�֤���Ѿ����Ƶ� C:\CT_Mirror_SrvWitness.cer)
CREATE CERTIFICATE CT_Mirror_SrvWitness
FROM FILE = 'C:\CT_Mirror_SrvWitness.cer'

-- b. ������¼
CREATE LOGIN LOGIN_Mirror_SrvWitness
FROM CERTIFICATE CT_Mirror_SrvWitness

-- c. ��������ݿ⾵��˵�� connect Ȩ��
GRANT CONNECT ON ENDPOINT::EDP_Mirror
TO LOGIN_Mirror_SrvWitness
GO


-- ===========================================
--��11��  ���������������ɼ�֤���������ݿ⾵��˵�Ĵ��䰲ȫģʽ����
-- �˲��������������ִ��
-- a. ������֤�������ϵ�֤��(�����֤�������ϱ��ݵ�֤���Ѿ����Ƶ� C:\CT_Mirror_SrvWitness.cer)
CREATE CERTIFICATE CT_Mirror_SrvWitness
FROM FILE = 'C:\CT_Mirror_SrvWitness.cer'

-- b. ������¼
CREATE LOGIN LOGIN_Mirror_SrvWitness
FROM CERTIFICATE CT_Mirror_SrvWitness

-- c. ��������ݿ⾵��˵�� connect Ȩ��
GRANT CONNECT ON ENDPOINT::EDP_Mirror
TO LOGIN_Mirror_SrvWitness
GO


-- ===========================================
--��12��  �������������Ϊ���ݿ⾵�����ü�֤������
-- �˲��������������ִ��
ALTER DATABASE DB_Mirror SET
	WITNESS = 'TCP://SrvWitness:5022'
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

-- c. ɾ����¼��֤��
DROP LOGIN LOGIN_Mirror_SrvB
DROP LOGIN LOGIN_Mirror_SrvWitness
DROP CERTIFICATE CT_Mirror_SrvA
DROP CERTIFICATE CT_Mirror_SrvB
DROP CERTIFICATE CT_Mirror_SrvWitness
GO


-- 2. �����������ִ�еĲ���
-- a. ɾ���������ݿ�
USE master
GO

DROP DATABASE DB_Mirror
GO

-- b. ɾ������˵�
DROP ENDPOINT EDP_Mirror
GO

-- c. ɾ����¼��֤��
DROP LOGIN LOGIN_Mirror_SrvA
DROP LOGIN LOGIN_Mirror_SrvWitness
DROP CERTIFICATE CT_Mirror_SrvA
DROP CERTIFICATE CT_Mirror_SrvB
DROP CERTIFICATE CT_Mirror_SrvWitness
GO

-- 3. ��֤��������ִ�еĲ���
-- a. ɾ���˵�
DROP ENDPOINT EDP_Mirror
GO

-- b. ɾ����¼��֤��
DROP LOGIN LOGIN_Mirror_SrvA
DROP LOGIN LOGIN_Mirror_SrvB
DROP CERTIFICATE CT_Mirror_SrvA
DROP CERTIFICATE CT_Mirror_SrvB
DROP CERTIFICATE CT_Mirror_SrvWitness
GO

