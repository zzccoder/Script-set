-- 1. ��ʾ��ǰ���Ի���
SELECT 
	Step = 'begin test', 
	original_login = ORIGINAL_LOGIN(), 
	current_login = SUSER_SNAME()

-- 2. ģ�� sa ��¼
EXECUTE AS LOGIN = 'sa'
SELECT 
	Step = 'switch to sa', 
	original_login = ORIGINAL_LOGIN(), 
	current_login = SUSER_SNAME()

-- 3. ģ�� NT AUTHORITY\SYSTEM ��¼
EXECUTE AS LOGIN = 'NT AUTHORITY\SYSTEM'
SELECT 
	Step = 'switch to NT AUTHORITY\SYSTEM', 
	original_login = ORIGINAL_LOGIN(), 
	current_login = SUSER_SNAME()

-- 4. �ָ���ǰ��ִ�������� 1 
REVERT
SELECT 
	Step = 'first revert', 
	original_login = ORIGINAL_LOGIN(), 
	current_login = SUSER_SNAME()

-- 5. �ָ���ǰ��ִ�������� 2
REVERT
SELECT 
	Step = 'second revert', 
	original_login = ORIGINAL_LOGIN(), 
	current_login = SUSER_SNAME()
