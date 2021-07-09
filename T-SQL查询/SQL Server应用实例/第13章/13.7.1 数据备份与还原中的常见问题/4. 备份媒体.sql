-- �����������ݿ�
CREATE DATABASE db_test
GO

-- ʹ�ô���ý�弯���ݲ������ݿ�,������ɺ�ɾ���������ݿ�
-- ����ı��ݲ������� c:\db_test_a.bak��c:\db_test_a.bak�ϴ���һ��ý�弯
BACKUP DATABASE db_test 
TO 
	DISK = 'c:\db_test_a.bak',
	DISK = 'c:\db_test_b.bak'
WITH FORMAT
DROP DATABASE db_test
GO

-- ��������ý�弯����ʾ
-- 1. ��ԭʱ��ָ��ý�弯�е�һ������ý��
RESTORE DATABASE db_test 
FROM DISK = 'c:\db_test_a.bak'
/*-- ��ԭ�������յ���������Ĵ�����Ϣ
��Ϣ 3132������ 16��״̬ 1���� 1 ��
ý�弯�� 2 ��ý��أ���ֻ�ṩ�� 1 ���������ṩ���г�Ա��
--*/

-- 2. ���Ե�������ý�弯�е�ĳ������ý����б���
BACKUP DATABASE master
TO DISK = 'c:\db_test_a.bak'
/*--���յ�������Ϣ
��Ϣ 3132������ 16��״̬ 1���� 1 ��
ý�弯�� 2 ��ý��أ���ֻ�ṩ�� 1 ���������ṩ���г�Ա��
--*/

-- 3. ����ͬʱ����ý�弯����ý�弯�еı���ý�屸��
BACKUP DATABASE master 
TO 
	DISK = 'c:\db_test_a.bak',
	DISK = 'c:\db_test_b.bak',
	DISK = 'c:\db_test_c.bak'
/*--���յ�������Ϣ
��Ϣ 3231������ 16��״̬ 1���� 1 ��
�� "c:\db_test_a.bak" �ϼ��ص�ý���Ѹ�ʽ��Ϊ֧�� 2 ��ý��أ�������ָ���ı����豸��Ӧ֧�� 3 ��ý��ء�
--*/

-- 4. ���³�ʼ��ý�弯ʱʾָ��ý�弯�е����б���ý��
BACKUP DATABASE master 
TO DISK = 'c:\db_test_a.bak'
WITH INIT
/*--���յ�������Ϣ
��Ϣ 3132������ 16��״̬ 1���� 1 ��
ý�弯�� 2 ��ý��أ���ֻ�ṩ�� 1 ���������ṩ���г�Ա��
--*/


-- ��ȷ����ý�弯����ʾ
-- 1. ָ��������ý�弯���������ָ����ݿ�
RESTORE DATABASE db_test 
FROM
	DISK = 'c:\db_test_a.bak',
	DISK = 'c:\db_test_b.bak'
/*-- �ɹ���ԭ���յ������������Ϣ
��Ϊ���ݿ� 'db_test'���ļ� 'db_test' (λ���ļ� 1 ��)������ 176 ҳ��
��Ϊ���ݿ� 'db_test'���ļ� 'db_test_log' (λ���ļ� 1 ��)������ 1 ҳ��
RESTORE DATABASE �ɹ������� 177 ҳ������ 0.716 ��(2.025 MB/��)��
--*/

-- 1. ʹ�� FORMAT ��дý��ͷ�����ؽ�ý�弯
BACKUP DATABASE master
TO DISK = 'c:\db_test_a.bak'
WITH FORMAT
/*-- �ɹ����ݣ������յ������������Ϣ
��Ϊ���ݿ� 'master'���ļ� 'master' (λ���ļ� 1 ��)������ 376 ҳ��
��Ϊ���ݿ� 'master'���ļ� 'mastlog' (λ���ļ� 1 ��)������ 2 ҳ��
BACKUP DATABASE �ɹ������� 378 ҳ������ 1.223 ��(2.531 MB/��)��
--*/
GO

-- ɾ���������ݿ�
IF DB_ID(N'db_test') IS NOT NULL
	DROP DATABASE db_test