-- ���������ݿ���ݼ���Ϊ 65 ʱ
EXEC sp_dbcmptlevel N'AdventureWorks', 65
GO

USE AdventureWorks
-- BACKUP ������
BACKUP DATABASE master 
TO DISK = 'c:\master.bak'
WITH FORMAT
/*--����������Ϣ
��Ϣ 325������ 15��״̬ 1���� 4 ��
'BACKUP' �������﷨������������Ҫ����ǰ���ݿ�ļ��ݼ�������Ϊ���ߵ�ֵ�������ô˹��ܡ��йش洢���� sp_dbcmptlevel ����Ϣ����μ�������
--*/
GO

-- �ָ����ݿ���ݼ���
EXEC sp_dbcmptlevel N'AdventureWorks', 90
