USE master
GO

-- 1. ���� SOAP �˵�
CREATE ENDPOINT SOAP_test
	STATE=STARTED
AS HTTP(
	AUTHENTICATION = (INTEGRATED),
	PATH = N'/sql/soap_test',
	PORTS = (CLEAR)
)
FOR SOAP(
	WEBMETHOD 'sp_who'(        -- ִ�д洢���� sp_who ��ר�÷���
		NAME = N'master.dbo.sp_who',
		FORMAT = ROWSETS_ONLY  -- �洢����ֻ���ؼ�¼��
	),
	BATCHES = ENABLED,         -- ���� BATCHES, �Ա��ܹ�ִ��ָ����T-SQL
	WSDL = DEFAULT,            -- ��SQL Server�Լ�����WSDL��Ϣ
	SCHEMA = STANDARD          -- ���ر�׼��XSD
)
GO

-- 2. ���Ҫʹ�õ� Windows �ʺŻ����ʺ����ڵ���δ��SQL Sserver���ж�Ӧ�ĵ�¼�ʺ�, ����Ҫ������¼
--    ���豾������Ϊ: Test, ҪΪ�佨����¼��Windwos�ʺ���Ϊ:SQLTest
--    �������������ڽ���SQL��¼���û�, �������ʵ���Ȩ��, �Ա��ܹ�����SOAP�˵㼰ִ�м�ϯT-SQL��ѯ
-- ΪWINDOWS�ʺŽ���һ����¼, �Ա����ͨ�����ʺŷ���SOAP�˵�
CREATE LOGIN [Test\SQLTest]
FROM WINDOWS
GO

-- �����¼�Զ˵������Ȩ��
GRANT CONNECT ON ENDPOINT::SOAP_Test
	TO [Test\SQLTest]
GO

-- Ϊ��¼����USER
CREATE USER [Test\SQLTest]
FOR LOGIN [Test\SQLTest]
WITH DEFAULT_SCHEMA = dbo
GO

-- ΪUSER�����ʵ���Ȩ��, ��ʹ���ܹ�ִ����ص�T-SQL
GRANT EXECUTE ON sp_who
TO [Test\SQLTest]
GRANT SELECT
TO [Test\SQLTest]
GO

/*-- 3. ������ɺ�, ɾ�����Ի���
-- ɾ�� SOAP �˵�
IF EXISTS(
		SELECT * FROM sys.soap_endpoints
		WHERE name = N'SOAP_test')
	DROP ENDPOINT SOAP_test

-- ɾ�������õ�SQL�û�����¼(�������Ҫ�Ļ�)
IF USER_ID(N'WSCDMIS048\JackZou') IS NOT NULL
	DROP USER [Test\SQLTest]
IF SUSER_SID(N'WSCDMIS048\JackZou') IS NOT NULL
	DROP LOGIN [Test\SQLTest]
--*/