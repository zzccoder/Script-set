-- 1. ���������

--a. ��©�ַ����ڱ߽��ַ�
SET @dt=2005-3-11

--b. ������ַ����ڱ߽��ַ�
SET @dt=#2005-3-11#

--c. ���������
SET @dt='2005-4-31'

--d. �������ڷ�Χ
SET @dt='1700-1-1'

--e. SQL Server��֧�ֵ����ڸ�ʽ
SET @dt='1999-1-1 ���� 2:30'
GO

-- 2. �뵱ǰ�Ự���Ի�����ƥ�������
DECLARE @dt varchar(50)
-- ���õ�ǰ�Ự���黷��ΪӢ��
SET LANGUAGE us_english
SET @dt = CONVERT(VARCHAR, GETDATE())
SELECT @dt

-- ���õ�ǰ�Ự���黷��Ϊ��������
SET LANGUAGE ��������
SELECT CONVERT(datetime, @dt)
GO
