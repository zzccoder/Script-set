-- ����һ�����Ե����ݿ�
CREATE DATABASE db_test
GO

--����������¼
CREATE LOGIN _aa
WITH PASSWORD = N'123.abc',
	DEFAULT_DATABASE = db_test

CREATE LOGIN _bb
WITH PASSWORD = N'321.cba',
	DEFAULT_DATABASE = db_test
GO

-- Ϊ��¼ _aa, _bb �ڲ������ݿ��н����û�
USE db_test
GO

CREATE USER _aa
	FOR LOGIN _aa

CREATE USER _bb
	FOR LOGIN _bb
GO

-- ����һ�������û� _bb �Ĺ���
CREATE SCHEMA _bb
	AUTHORIZATION _bb

-- �����ܹ� _bb �µĲ��Ա������� _aa �Ըñ�ķ���Ȩ
CREATE TABLE _bb.tb(
	id int)
GRANT SELECT ON _bb.tb
	TO _aa
GO

-- ��ǰִ���������л�����¼ _aa �� _bb, ��֤���ǿ��Է��ʲ��Եı�
EXECUTE AS LOGIN = '_aa'
SELECT * FROM _bb.tb
REVERT

EXECUTE AS LOGIN = '_bb'
SELECT * FROM _bb.tb
REVERT
GO


-- �û���֤��ɺ�,���ݲ�ɾ���������ݿ�,��ʾ�����û��Ĳ�������
USE master
GO
BACKUP DATABASE db_test
TO DISK = 'c:\db_test.bak'
WITH FORMAT

DROP DATABASE db_test
GO

-- ɾ����¼,����ģ��Ŀ�������û�����ȴ�����¼ʱ�����
DROP LOGIN _aa
DROP LOGIN _bb
GO

--��ԭ�������ݿ�
RESTORE DATABASE db_test
FROM DISK='c:\db_test.bak'
WITH REPLACE
GO

-- �鿴��ԭ��Ĳ������ݿ���û��Ƿ����
SELECT
	name, default_schema_name
FROM db_test.sys.database_principals
WHERE type = 'S'
/*--���
name                          default_schema_name
----------------------------- ---------------------
guest                         guest
INFORMATION_SCHEMA            NULL
sys                           NULL
_aa                           dbo
_bb                           dbo
--*/

-- �����л���ǰִ�������ĵ���¼ _aa, _bb
EXECUTE AS LOGIN = '_aa'
EXECUTE AS LOGIN = '_bb'
/*-- ���յ����������Ĵ�����Ϣ
��Ϣ 15406������ 16��״̬ 1���� 1 ��
�޷���Ϊ����������ִ�У���Ϊ���� "_aa" �����ڡ��޷�ģ���������͵����壬����û�������Ȩ�ޡ�
--*/
GO

-- �����л���ǰִ�������ĵ��û� _aa, _bb
EXECUTE AS USER = '_aa'
EXECUTE AS USER = '_bb'
/*-- ���յ����������Ĵ�����Ϣ
��Ϣ 15517������ 16��״̬ 1���� 1 ��
�޷���Ϊ���ݿ�����ִ�У���Ϊ���� "_aa" �����ڡ��޷�ģ���������͵����壬����û�������Ȩ�ޡ�
--*/
GO


-- ���½�����¼ _aa, _bb
CREATE LOGIN _aa
WITH PASSWORD = N'123.abc',
	DEFAULT_DATABASE = db_test

CREATE LOGIN _bb
WITH PASSWORD = N'321.cba',
	DEFAULT_DATABASE = db_test
GO

-- �����л���ǰִ�������ĵ���¼ _aa, _bb
EXECUTE AS LOGIN = '_aa'
REVERT
EXECUTE AS LOGIN = '_bb'
REVERT
/*-- ���յ����������Ĵ�����Ϣ
��Ϣ 916������ 14��״̬ 1���� 1 ��
���������� "_aa" �޷��ڵ�ǰִ���������·������ݿ� "db_test"��
--*/
GO

-- �����л���ǰִ�������ĵ��û� _aa, _bb
EXECUTE AS USER = '_aa'
EXECUTE AS USER = '_bb'
/*-- ���յ����������Ĵ�����Ϣ
��Ϣ 15517������ 16��״̬ 1���� 1 ��
�޷���Ϊ���ݿ�����ִ�У���Ϊ���� "_aa" �����ڡ��޷�ģ���������͵����壬����û�������Ȩ�ޡ�
--*/
GO


-- ����Ϊ��¼ _aa, _bb �ڲ������ݿ��н����û�
USE db_test
GO

CREATE USER _aa
	FOR LOGIN _aa

CREATE USER _bb
	FOR LOGIN _bb
/*-- �յ���������Ĵ�����Ϣ
��Ϣ 15023������ 16��״̬ 1���� 2 ��
�û�������ɫ '_aa' �ڵ�ǰ���ݿ����Ѵ��ڡ�
��Ϣ 15023������ 16��״̬ 1���� 5 ��
�û�������ɫ '_bb' �ڵ�ǰ���ݿ����Ѵ��ڡ�
--*/
GO


-- ����ɾ���������ݿ��е��û�
DROP USER _aa
-- ��Ϊ��ӵ���κζ������Գɹ�
GO

DROP USER _bb
/*-- �յ���������Ĵ�����Ϣ
��Ϣ 15138������ 16��״̬ 1���� 1 ��
���ݿ������ڸ����ݿ���ӵ�� �ܹ����޷�ɾ����
--*/
GO


-- ��Ϊ�����û� _aa �Ѿ�ɾ�������Կ������½����û�
CREATE USER _aa
	FOR LOGIN _aa
GO

-- ˳������ǰִ���������л��� _aa�����ҿ��Է�������
EXECUTE AS LOGIN = '_aa'
REVERT
EXECUTE AS USER = '_aa'
REVERT
GO

-- ɾ�����Ի���
USE master
GO
DROP DATABASE db_test
DROP LOGIN _aa
DROP LOGIN _bb
