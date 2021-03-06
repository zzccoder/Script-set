-- ===========================================
-- 无论是主体服务器、镜像服务器, 还是见证服务器
-- 除特别说明外，均需要保证下面的操作在master库中执行
USE master
GO

-- ===========================================
--（1）  建立镜像主体数据库
-- 此操作主体服务器上执行
-- a. 建立测试数据库
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

-- b. 完全备份
BACKUP DATABASE DB_Mirror
TO DISK = N'C:\DB_Mirror.bak'
WITH FORMAT
GO


-- ===========================================
--（2）  初始化镜像主体数据库
-- 此操作镜像服务器上执行
-- 假设主体数据库的完全备份已经复制到 c:\DB_Mirror.bak
RESTORE DATABASE DB_Mirror
FROM DISK = N'C:\DB_Mirror.bak'
WITH REPLACE
	, NORECOVERY
-- 如果镜像数据库文件要放在指定位置, 则启用下面的 Move 选项
--	, MOVE 'DB_Mirror_DATA' TO N'C:\DB_Mirror.mdf'
--	, MOVE 'DB_Mirror_LOG' TO N'C:\DB_Mirror.ldf'
GO


-- ===========================================
--（3）  主体服务器上的数据库镜像端点及身份验证用的证书
-- 此操作主体服务器上执行
-- a. 用于数据库镜像端点身份验证的证书
IF NOT EXISTS(  -- 使用数据库主密钥加密证书
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

-- b. 备份证书, 以便在与此端点通信的另一端建立此证书
BACKUP CERTIFICATE CT_Mirror_SrvA
TO FILE = 'C:\CT_Mirror_SrvA.cer'
GO

-- c. 数据库镜像端点
CREATE ENDPOINT EDP_Mirror
	STATE = STARTED 
	AS TCP(
		LISTENER_PORT = 5022,  -- 镜像端点使用的通信端口
		LISTENER_IP = ALL)     -- 侦听的IP地址
    FOR DATABASE_MIRRORING(
		AUTHENTICATION = CERTIFICATE CT_Mirror_SrvA, -- 证书身份验证
		ENCRYPTION = DISABLED,                       -- 不对传输的数据加密,如果需要加密,可以配置为 SUPPORTED 或 REQUIRED, 并可选择加密算法
		ROLE = ALL)                                  -- 端点支持所有的数据库镜像角色, 也可以设置为 WITNESS(仅见证服务器),或 PARTNER(仅镜像伙伴)
GO


-- ===========================================
--（4）  镜像服务器上的数据库镜像端点及身份验证用的证书
-- 此操作镜像服务器上执行
-- a. 用于数据库镜像端点身份验证的证书
IF NOT EXISTS(  -- 使用数据库主密钥加密证书
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

-- b. 备份证书, 以便在与此端点通信的另一端建立此证书
BACKUP CERTIFICATE CT_Mirror_SrvB
TO FILE = 'C:\CT_Mirror_SrvB.cer'
GO

-- c. 数据库镜像端点
CREATE ENDPOINT EDP_Mirror
	STATE = STARTED 
	AS TCP(
		LISTENER_PORT = 5022,  -- 镜像端点使用的通信端口
		LISTENER_IP = ALL)     -- 侦听的IP地址
    FOR DATABASE_MIRRORING(
		AUTHENTICATION = CERTIFICATE CT_Mirror_SrvB, -- 证书身份验证
		ENCRYPTION = DISABLED,                       -- 不对传输的数据加密,如果需要加密,可以配置为 SUPPORTED 或 REQUIRED, 并可选择加密算法
		ROLE = ALL)                                  -- 端点支持所有的数据库镜像角色, 也可以设置为 WITNESS(仅见证服务器),或 PARTNER(仅镜像伙伴)
GO


-- ===========================================
--（5）  在镜像服务器上完成主体服务器数据库镜像端点的传输安全模式配置
-- 此操作镜像服务器上执行
-- a. 建立主体服务器上的证书(假设主体服务器上备份的证书已经复制到 C:\CT_Mirror_SrvA.cer)
CREATE CERTIFICATE CT_Mirror_SrvA
FROM FILE = 'C:\CT_Mirror_SrvA.cer'

-- b. 建立登录
CREATE LOGIN LOGIN_Mirror_SrvA
FROM CERTIFICATE CT_Mirror_SrvA

-- c. 授予对数据库镜像端点的 connect 权限
GRANT CONNECT ON ENDPOINT::EDP_Mirror
TO LOGIN_Mirror_SrvA
GO


-- ===========================================
--（6）  在主体服务器上完成镜像服务器数据库镜像端点的传输安全模式配置
-- 此操作主体服务器上执行
-- a. 建立主体服务器上的证书(假设镜像服务器上备份的证书已经复制到 C:\CT_Mirror_SrvB.cer)
CREATE CERTIFICATE CT_Mirror_SrvB
FROM FILE = 'C:\CT_Mirror_SrvB.cer'

-- b. 建立登录
CREATE LOGIN LOGIN_Mirror_SrvB
FROM CERTIFICATE CT_Mirror_SrvB

-- c. 授予对数据库镜像端点的 connect 权限
GRANT CONNECT ON ENDPOINT::EDP_Mirror
TO LOGIN_Mirror_SrvB
GO


-- ===========================================
--（7）  在镜像服务器上启用数据库镜像
-- 此操作镜像服务器上执行
ALTER DATABASE DB_Mirror SET
	PARTNER = 'TCP://SrvA:5022'
GO


-- ===========================================
--（8）  在主体服务器上启用数据库镜像(默认为高安全性模式,所以不用进行模式设置)
-- 此操作主体服务器上执行
ALTER DATABASE DB_Mirror SET
	PARTNER = 'TCP://SrvB:5022'
GO


-- ===========================================
--（9）  配置见证服务器
-- 此操作在见证服务器上执行
-- a. 完成见证服务器上数据库镜像端点的传输安全模式配置
-- (a). 用于数据库镜像端点身份验证的证书
IF NOT EXISTS(  -- 使用数据库主密钥加密证书
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

-- (b). 备份证书, 以便在与此端点通信的另一端建立此证书
BACKUP CERTIFICATE CT_Mirror_SrvWitness
TO FILE = 'C:\CT_Mirror_SrvWitness.cer'
GO

-- (c). 数据库镜像端点
CREATE ENDPOINT EDP_Mirror
	STATE = STARTED 
	AS TCP(
		LISTENER_PORT = 5022,  -- 镜像端点使用的通信端口
		LISTENER_IP = ALL)     -- 侦听的IP地址
    FOR DATABASE_MIRRORING(
		AUTHENTICATION = CERTIFICATE CT_Mirror_SrvWitness, -- 证书身份验证
		ENCRYPTION = DISABLED,                             -- 不对传输的数据加密,如果需要加密,可以配置为 SUPPORTED 或 REQUIRED, 并可选择加密算法
		ROLE = ALL)                                        -- 端点支持所有的数据库镜像角色, 也可以设置为 WITNESS(仅见证服务器),或 PARTNER(仅镜像伙伴)
GO

-- b. 完成主体服务器上数据库镜像端点的传输安全模式配置
-- (a). 建立主体服务器上的证书(假设主体服务器上备份的证书已经复制到 C:\CT_Mirror_SrvA.cer)
CREATE CERTIFICATE CT_Mirror_SrvA
FROM FILE = 'C:\CT_Mirror_SrvA.cer'

-- (b). 建立登录
CREATE LOGIN LOGIN_Mirror_SrvA
FROM CERTIFICATE CT_Mirror_SrvA

-- (c). 授予对数据库镜像端点的 connect 权限
GRANT CONNECT ON ENDPOINT::EDP_Mirror
TO LOGIN_Mirror_SrvA
GO

-- c. 完成镜像服务器上数据库镜像端点的传输安全模式配置
-- (a). 建立镜像服务器上的证书(假设镜像服务器上备份的证书已经复制到 C:\CT_Mirror_SrvB.cer)
CREATE CERTIFICATE CT_Mirror_SrvB
FROM FILE = 'C:\CT_Mirror_SrvB.cer'

-- (b). 建立登录
CREATE LOGIN LOGIN_Mirror_SrvB
FROM CERTIFICATE CT_Mirror_SrvB

-- (c). 授予对数据库镜像端点的 connect 权限
GRANT CONNECT ON ENDPOINT::EDP_Mirror
TO LOGIN_Mirror_SrvB
GO


-- ===========================================
--（10）  在镜像服务器上完成见证服务器数据库镜像端点的传输安全模式配置
-- 此操作镜像服务器上执行
-- a. 建立见证服务器上的证书(假设见证服务器上备份的证书已经复制到 C:\CT_Mirror_SrvWitness.cer)
CREATE CERTIFICATE CT_Mirror_SrvWitness
FROM FILE = 'C:\CT_Mirror_SrvWitness.cer'

-- b. 建立登录
CREATE LOGIN LOGIN_Mirror_SrvWitness
FROM CERTIFICATE CT_Mirror_SrvWitness

-- c. 授予对数据库镜像端点的 connect 权限
GRANT CONNECT ON ENDPOINT::EDP_Mirror
TO LOGIN_Mirror_SrvWitness
GO


-- ===========================================
--（11）  在主体服务器上完成见证服务器数据库镜像端点的传输安全模式配置
-- 此操作主体服务器上执行
-- a. 建立见证服务器上的证书(假设见证服务器上备份的证书已经复制到 C:\CT_Mirror_SrvWitness.cer)
CREATE CERTIFICATE CT_Mirror_SrvWitness
FROM FILE = 'C:\CT_Mirror_SrvWitness.cer'

-- b. 建立登录
CREATE LOGIN LOGIN_Mirror_SrvWitness
FROM CERTIFICATE CT_Mirror_SrvWitness

-- c. 授予对数据库镜像端点的 connect 权限
GRANT CONNECT ON ENDPOINT::EDP_Mirror
TO LOGIN_Mirror_SrvWitness
GO


-- ===========================================
--（12）  在主体服务器上为数据库镜像启用见证服务器
-- 此操作主体服务器上执行
ALTER DATABASE DB_Mirror SET
	WITNESS = 'TCP://SrvWitness:5022'
GO




-- ===========================================
-- 下面的操作可用于确定同步
-- 1. 查询数据库状态
-- 下面的脚本可以在主体服务器和镜像服务器上执行,执行结果为镜像的状态
SELECT 
	mirroring_role_desc,           -- 数据库在镜像会话中当前的角色
	mirroring_state_desc,          -- 镜像当前状态
	mirroring_safety_level_desc,   -- 镜像运行模式
	mirroring_witness_state_desc   -- 与见证服务器的连接情况
FROM sys.database_mirroring
WHERE database_id = DB_ID(N'DB_Mirror')
GO

-- 2. 数据测试
-- b. 主体服务器上执行下面的语句以建立测试表
CREATE TABLE DB_Mirror.dbo.tb(
	id int)
WAITFOR DELAY '00:00:01'
GO

-- b. 镜像服务器上, 建立镜像数据库的快昭数据库,以便可以查询当前的数据
CREATE DATABASE SNP_DB_Mirror
ON(
	NAME = DB_Mirror_DATA,
	FILENAME = N'C:\SNP_DB_Mirror.mdf')
AS SNAPSHOT OF DB_Mirror
GO

-- c. 从快照数据库中查询测试表是否已经同步
SELECT * FROM SNP_DB_Mirror.dbo.tb
GO

-- d. 删除测试建立的快照数据库
DROP DATABASE SNP_DB_Mirror
GO


-- ===========================================
-- 下面的操作用于删除此示例配置的镜像对象
--  证书和数据库的备份需要在操作系统的资源管理器中删除
-- 1. 主体服务器上执行的操作
-- a. 停止镜像和删除主体数据库
USE master
GO

ALTER DATABASE DB_Mirror SET
	PARTNER OFF
DROP DATABASE DB_Mirror
GO

-- b. 删除镜像端点
DROP ENDPOINT EDP_Mirror
GO

-- c. 删除登录及证书
DROP LOGIN LOGIN_Mirror_SrvB
DROP LOGIN LOGIN_Mirror_SrvWitness
DROP CERTIFICATE CT_Mirror_SrvA
DROP CERTIFICATE CT_Mirror_SrvB
DROP CERTIFICATE CT_Mirror_SrvWitness
GO


-- 2. 镜像服务器上执行的操作
-- a. 删除镜像数据库
USE master
GO

DROP DATABASE DB_Mirror
GO

-- b. 删除镜像端点
DROP ENDPOINT EDP_Mirror
GO

-- c. 删除登录及证书
DROP LOGIN LOGIN_Mirror_SrvA
DROP LOGIN LOGIN_Mirror_SrvWitness
DROP CERTIFICATE CT_Mirror_SrvA
DROP CERTIFICATE CT_Mirror_SrvB
DROP CERTIFICATE CT_Mirror_SrvWitness
GO

-- 3. 见证服务器上执行的操作
-- a. 删除端点
DROP ENDPOINT EDP_Mirror
GO

-- b. 删除登录及证书
DROP LOGIN LOGIN_Mirror_SrvA
DROP LOGIN LOGIN_Mirror_SrvB
DROP CERTIFICATE CT_Mirror_SrvA
DROP CERTIFICATE CT_Mirror_SrvB
DROP CERTIFICATE CT_Mirror_SrvWitness
GO

