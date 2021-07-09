-- 1. 显示当前测试环境
SELECT 
	Step = 'begin test', 
	original_login = ORIGINAL_LOGIN(), 
	current_login = SUSER_SNAME()

-- 2. 模拟 sa 登录
EXECUTE AS LOGIN = 'sa'
SELECT 
	Step = 'switch to sa', 
	original_login = ORIGINAL_LOGIN(), 
	current_login = SUSER_SNAME()

-- 3. 模拟 NT AUTHORITY\SYSTEM 登录
EXECUTE AS LOGIN = 'NT AUTHORITY\SYSTEM'
SELECT 
	Step = 'switch to NT AUTHORITY\SYSTEM', 
	original_login = ORIGINAL_LOGIN(), 
	current_login = SUSER_SNAME()

-- 4. 恢复以前的执行上下文 1 
REVERT
SELECT 
	Step = 'first revert', 
	original_login = ORIGINAL_LOGIN(), 
	current_login = SUSER_SNAME()

-- 5. 恢复以前的执行上下文 2
REVERT
SELECT 
	Step = 'second revert', 
	original_login = ORIGINAL_LOGIN(), 
	current_login = SUSER_SNAME()
