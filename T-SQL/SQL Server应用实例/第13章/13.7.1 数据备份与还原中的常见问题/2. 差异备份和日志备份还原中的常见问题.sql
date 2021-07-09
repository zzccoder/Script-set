-- �����������ݿ�
CREATE DATABASE db_test
GO

-- ����������ݣ�Ϊ��ԭ������׼��
BACKUP DATABASE db_test
TO DISK = 'c:\1_db.bak'
WITH FORMAT

BACKUP LOG db_test
TO DISK = 'c:\2_log.bak'
WITH FORMAT

BACKUP LOG db_test
TO DISK = 'c:\3_log.bak'
WITH FORMAT

BACKUP DATABASE db_test
TO DISK = 'c:\4_db.bak'
WITH FORMAT

BACKUP DATABASE db_test TO
DISK = 'c:\5_diff.bak'
WITH FORMAT,
	DIFFERENTIAL

BACKUP LOG db_test
TO DISK = 'c:\6_log.bak'
WITH FORMAT
GO

--������������־���ݺͲ��챸�ݻ�ԭ���׷��Ĵ���
-- 1. �ָ�ʱʹ�ô������־˳��
RESTORE DATABASE db_test
FROM DISK = 'c:\1_db.bak'
WITH NORECOVERY,
	REPLACE

RESTORE LOG db_test
FROM DISK = 'c:\3_log.bak'
/*-- ��ԭ��־����ʱ�����յ���������Ĵ�����Ϣ
��Ϣ 4305������ 16��״̬ 1���� 6 ��
�˱��ݼ��е���־��ʼ�� LSN 37000000008000001���� LSN ̫���޷�Ӧ�õ����ݿ⡣���Ի�ԭ���� LSN 37000000007400001 �Ľ������־���ݡ�
-- */
GO

-- 2. �ָ�ʱ, ����־����Ӧ���ڴ������ȫ����
RESTORE DATABASE db_test
FROM DISK = 'c:\4_db.bak'
WITH NORECOVERY,
	REPLACE

RESTORE LOG db_test
FROM DISK = 'c:\2_log.bak'
/*-- ��ԭ��־����ʱ�����յ���������Ĵ�����Ϣ
��Ϣ 4326������ 16��״̬ 1���� 8 ��
�˱��ݼ��е���־��ֹ�� LSN 37000000008000001���� LSN ̫�磬�޷�Ӧ�õ����ݿ⡣���Ի�ԭ���� LSN 37000000009800001 �Ľ��µ���־���ݡ�
-- */
GO

-- 3. ����־�������� RESTORE DATABASE
IF DB_ID('db_test') IS NOT NULL
	DROP DATABASE db_test

RESTORE DATABASE db_test
FROM DISK = 'c:\2_log.bak'
WITH NORECOVERY,
	REPLACE
/*-- ��ԭ���յ���������Ĵ�����Ϣ
��Ϣ 3118������ 16��״̬ 1���� 4 ��
���ݿ� "db_test" �����ڡ�RESTORE ֻ���ڻ�ԭ���ļ����������ݻ��ļ�����ʱ�������ݿ⡣
-- */
GO

-- 4. �����챸�����ڴ������ȫ������
RESTORE DATABASE db_test
FROM DISK = 'c:\1_db.bak'
WITH NORECOVERY,
	REPLACE

RESTORE DATABASE db_test
FROM DISK = 'c:\5_diff.bak'
/*-- ��ԭ���챸��ʱ�����յ���������Ĵ�����Ϣ
��Ϣ 3136������ 16��״̬ 1���� 6 ��
�޷���ԭ�˲��챸�ݣ���Ϊ�����ݿ���δ��ԭ����ȷ������״̬��
--*/
GO

-- 5. ��ԭ��ȫ����ʱ,δʹ��NORECOVERY,���²�����ȷ��ԭ��־���ݻ��߲��챸��
RESTORE DATABASE db_test
FROM DISK = 'c:\1_db.bak'
WITH REPLACE

RESTORE LOG db_test
FROM DISK='c:\2_log.bak'
/*--�յ�������Ϣ
��Ϣ 3117������ 16��״̬ 1���� 5 ��
�޷���ԭ��־���ݻ���챸�ݣ���Ϊû���ļ�������ǰ����
--*/
GO

--ɾ������
IF DB_ID('db_test') IS NOT NULL
	DROP DATABASE db_test
