USE master
GO

-- �������Ե�¼
CREATE LOGIN Log_Test
WITH PASSWORD = N'L0g Test'
GO

-- �����û�����Ķ˵�, ����ָ����IP�ϵĽ�����Ϣ
CREATE ENDPOINT [TSQL User test]
STATE = STARTED
AS TCP(
	LISTENER_PORT = 2433,
	LISTENER_IP = (192.168.1.100)
)
FOR TSQL()
GO

-- �ָ�Ĭ�ϵ� PUBLIC ��ɫ��Ȩ
GRANT CONNECT ON ENDPOINT::[TSQL Default TCP]
TO [PUBLIC]

-- ����Ĭ�϶˵��ϵ�Ȩ��
DENY CONNECT ON ENDPOINT::[TSQL Default TCP]
TO Log_Test

DENY CONNECT ON ENDPOINT::[TSQL Named Pipes]
TO Log_Test

DENY CONNECT ON ENDPOINT::[Dedicated Admin Connection]
TO Log_Test

DENY CONNECT ON ENDPOINT::[TSQL Default VIA]
TO Log_Test

DENY CONNECT ON ENDPOINT::[TSQL Local Machine]
TO Log_Test
GO

-- �����¼���û�����˵��ϵ�����Ȩ��
GRANT CONNECT ON ENDPOINT::[TSQL User test]
TO Log_Test
GO

-- ɾ������
--DROP ENDPOINT [TSQL User test]
--DROP LOGIN Log_Test
