USE master
GO

-- 建立测试登录
CREATE LOGIN Log_Test
WITH PASSWORD = N'L0g Test'
GO

-- 创建用户定义的端点, 侦听指定的IP上的接入信息
CREATE ENDPOINT [TSQL User test]
STATE = STARTED
AS TCP(
	LISTENER_PORT = 2433,
	LISTENER_IP = (192.168.1.100)
)
FOR TSQL()
GO

-- 恢复默认的 PUBLIC 角色授权
GRANT CONNECT ON ENDPOINT::[TSQL Default TCP]
TO [PUBLIC]

-- 回收默认端点上的权限
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

-- 授予登录在用户定义端点上的连接权限
GRANT CONNECT ON ENDPOINT::[TSQL User test]
TO Log_Test
GO

-- 删除测试
--DROP ENDPOINT [TSQL User test]
--DROP LOGIN Log_Test
