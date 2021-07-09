-- 1. 错误的日期

--a. 遗漏字符日期边界字符
SET @dt=2005-3-11

--b. 错误的字符日期边界字符
SET @dt=#2005-3-11#

--c. 错误的日期
SET @dt='2005-4-31'

--d. 超出日期范围
SET @dt='1700-1-1'

--e. SQL Server不支持的日期格式
SET @dt='1999-1-1 下午 2:30'
GO

-- 2. 与当前会话语言环境不匹配的日期
DECLARE @dt varchar(50)
-- 设置当前会话评议环境为英文
SET LANGUAGE us_english
SET @dt = CONVERT(VARCHAR, GETDATE())
SELECT @dt

-- 设置当前会话评议环境为简体中文
SET LANGUAGE 简体中文
SELECT CONVERT(datetime, @dt)
GO
