-- �����������ݿ⣬���������ݿ��ҳУ��Ϊ CHECKSUM ģʽ
CREATE DATABASE db_test
ON(
	NAME = db_test,
	FILENAME = N'c:\db_test.mdf')

ALTER DATABASE db_test
SET PAGE_VERIFY CHECKSUM
GO

-- �������Ա�
-- ��������ʹ���� 0��9�����֣�ÿ����¼ռ��һ������ҳ�����ҳ�ж�����ͬ������
-- ��������Ŀ����Ϊ�˺������Ϊ�ƻ��ܹ��ҵ��ƻ��ĵ�
SELECT TOP 500
	col = REPLICATE((ROW_NUMBER() OVER(ORDER BY C.object_id)) % 10, 8000)
INTO db_test.dbo.tb
FROM sys.columns C, sys.objects
GO

-- �����ݿ�����ȫ����
BACKUP DATABASE db_test
TO DISK = N'c:\db_test.bak'
WITH FORMAT
GO

-- �ر� SQL Server�� ��ʹ��ʮ�����ƹ����޸������ļ�(�ҵ��ǳ�����һ�����ݶ��ǵ��������ظ��ģ��ĵ���ʮ����
SHUTDOWN
GO

-- ��������  SQL Server�� ���������ҳ�Ƿ�������
DBCC CHECKDB(N'db_test')
/*-- ���ǰ��ֱ���޸����ݿ��ļ��Ĳ����õ����ᵼ������ҳ�𻵣����յ������������Ϣ
tb�� DBCC �����
��Ϣ 8928������ 16��״̬ 1���� 1 ��
���� ID 2073058421������ ID 0������ ID 72057594038321152�����䵥Ԫ ID 72057594043301888 (����Ϊ In-row data): �޷�����ҳ (1:176)���й���ϸ��Ϣ�����������������Ϣ��
��Ϣ 8939������ 16��״̬ 98���� 1 ��
�����: ���� ID 2073058421������ ID 0������ ID 72057594038321152�����䵥Ԫ ID 72057594043301888 (����Ϊ In-row data)��ҳ (1:176)������(IS_OFF (BUF_IOERR, pBUF->bstat))ʧ�ܡ�ֵΪ 12716041 �� -4��
--*/

-- ��ʱ��� msdb.dbo.suspect_pages �����Կ�������ҳ�ļ�¼��Ϣ
SELECT * FROM msdb.dbo.suspect_pages WITH(NOLOCK)
GO

-- ���� DBCC ��ʾ�Ĵ���ҳ��Ϣ����ԭ����ҳ
RESTORE DATABASE db_test
	PAGE = '1:234'    -- PAGE ������ֵ���� DBCC CHECKDB ����ʾ�Ĵ���ҳ����
                      --����ָ�����PAGE����ͬʱ��ԭ���ҳ
FROM DISK = N'c:\db_test.bak'

/*-- ���ݿ⻹ԭ�ɹ�������ʾ��ҪӦ��β��־
ǰ����ʼ������λ����־���к�(LSN) 52000000039300001 ������Ҫ����ǰ���� LSN 52000000048300001 ֮ǰ������ɻ�ԭ˳��
--*/
GO

-- ��֤����ҳ�Ƿ��޸�(����δӦ�����ݿ�β��־���������ɣ�
DBCC CHECKDB(N'db_test')
G0

-- ���潫Ӧ�����ݿ�β��־
-- ����֮ǰ����һ�����Ա��Լ��Ӧ��β��־�Ƿ�ᶪʧ��ǰ������
CREATE TABLE db_test.dbo.tb_check(
	id int)

-- �������ݿ�β��־����ͨ�� NORECOVERY ѡ��ʹ���ݿ⴦�ڿɻ�ԭ���ݵ�״̬
BACKUP LOG db_test
TO DISK = N'c:\db_test_log.bak'
WITH NORECOVERY,
	FORMAT

-- ��ԭ���ݿ�β��־����ʹ���ݿ����
RESTORE LOG db_test
FROM DISK = N'c:\db_test_log.bak'
WITH RECOVERY
GO

-- ��鱸��β��־ǰ�����Ĳ��Ա�����ñ���ڣ�˵��Ӧ��β��־���ᶪʧ����
SELECT * FROM db_test.dbo.tb_check
GO

-- �ٴ� DBCC CHECKDB�� ȷ������ҳ�����Ѿ��޸�
DBCC CHECKDB(N'db_test')
GO


-- ɾ���������ݿ�
DROP DATABASE db_test
