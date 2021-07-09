-- 创建一个测试的数据库
CREATE DATABASE db_test
GO

--创建两个登录
CREATE LOGIN _aa
WITH PASSWORD = N'123.abc',
	DEFAULT_DATABASE = db_test

CREATE LOGIN _bb
WITH PASSWORD = N'321.cba',
	DEFAULT_DATABASE = db_test
GO

-- 为登录 _aa, _bb 在测试数据库中建立用户
USE db_test
GO

CREATE USER _aa
	FOR LOGIN _aa

CREATE USER _bb
	FOR LOGIN _bb
GO

-- 创建一个属于用户 _bb 的构架
CREATE SCHEMA _bb
	AUTHORIZATION _bb

-- 创建架构 _bb 下的测试表，并授予 _aa 对该表的访问权
CREATE TABLE _bb.tb(
	id int)
GRANT SELECT ON _bb.tb
	TO _aa
GO

-- 当前执行上下文切换到登录 _aa 和 _bb, 验证他们可以访问测试的表
EXECUTE AS LOGIN = '_aa'
SELECT * FROM _bb.tb
REVERT

EXECUTE AS LOGIN = '_bb'
SELECT * FROM _bb.tb
REVERT
GO


-- 用户验证完成后,备份并删除测试数据库,演示孤立用户的产生过程
USE master
GO
BACKUP DATABASE db_test
TO DISK = 'c:\db_test.bak'
WITH FORMAT

DROP DATABASE db_test
GO

-- 删除登录,用以模拟目标服务器没有事先创建登录时的情况
DROP LOGIN _aa
DROP LOGIN _bb
GO

--还原测试数据库
RESTORE DATABASE db_test
FROM DISK='c:\db_test.bak'
WITH REPLACE
GO

-- 查看还原后的测试数据库的用户是否存在
SELECT
	name, default_schema_name
FROM db_test.sys.database_principals
WHERE type = 'S'
/*--结果
name                          default_schema_name
----------------------------- ---------------------
guest                         guest
INFORMATION_SCHEMA            NULL
sys                           NULL
_aa                           dbo
_bb                           dbo
--*/

-- 尝试切换当前执行上下文到登录 _aa, _bb
EXECUTE AS LOGIN = '_aa'
EXECUTE AS LOGIN = '_bb'
/*-- 将收到类似这样的错误信息
消息 15406，级别 16，状态 1，第 1 行
无法作为服务器主体执行，因为主体 "_aa" 不存在、无法模拟这种类型的主体，或您没有所需的权限。
--*/
GO

-- 尝试切换当前执行上下文到用户 _aa, _bb
EXECUTE AS USER = '_aa'
EXECUTE AS USER = '_bb'
/*-- 将收到类似这样的错误信息
消息 15517，级别 16，状态 1，第 1 行
无法作为数据库主体执行，因为主体 "_aa" 不存在、无法模拟这种类型的主体，或您没有所需的权限。
--*/
GO


-- 重新建立登录 _aa, _bb
CREATE LOGIN _aa
WITH PASSWORD = N'123.abc',
	DEFAULT_DATABASE = db_test

CREATE LOGIN _bb
WITH PASSWORD = N'321.cba',
	DEFAULT_DATABASE = db_test
GO

-- 尝试切换当前执行上下文到登录 _aa, _bb
EXECUTE AS LOGIN = '_aa'
REVERT
EXECUTE AS LOGIN = '_bb'
REVERT
/*-- 将收到类似这样的错误信息
消息 916，级别 14，状态 1，第 1 行
服务器主体 "_aa" 无法在当前执行上下文下访问数据库 "db_test"。
--*/
GO

-- 尝试切换当前执行上下文到用户 _aa, _bb
EXECUTE AS USER = '_aa'
EXECUTE AS USER = '_bb'
/*-- 将收到类似这样的错误信息
消息 15517，级别 16，状态 1，第 1 行
无法作为数据库主体执行，因为主体 "_aa" 不存在、无法模拟这种类型的主体，或您没有所需的权限。
--*/
GO


-- 尝试为登录 _aa, _bb 在测试数据库中建立用户
USE db_test
GO

CREATE USER _aa
	FOR LOGIN _aa

CREATE USER _bb
	FOR LOGIN _bb
/*-- 收到类似下面的错误信息
消息 15023，级别 16，状态 1，第 2 行
用户、组或角色 '_aa' 在当前数据库中已存在。
消息 15023，级别 16，状态 1，第 5 行
用户、组或角色 '_bb' 在当前数据库中已存在。
--*/
GO


-- 尝试删除测试数据库中的用户
DROP USER _aa
-- 因为不拥有任何对象，所以成功
GO

DROP USER _bb
/*-- 收到类似下面的错误信息
消息 15138，级别 16，状态 1，第 1 行
数据库主体在该数据库中拥有 架构，无法删除。
--*/
GO


-- 因为孤立用户 _aa 已经删除，所以可以重新建立用户
CREATE USER _aa
	FOR LOGIN _aa
GO

-- 顺利将当前执行上下文切换到 _aa，并且可以访问数据
EXECUTE AS LOGIN = '_aa'
REVERT
EXECUTE AS USER = '_aa'
REVERT
GO

-- 删除测试环境
USE master
GO
DROP DATABASE db_test
DROP LOGIN _aa
DROP LOGIN _bb
