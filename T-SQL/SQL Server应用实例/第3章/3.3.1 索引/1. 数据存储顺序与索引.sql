USE tempdb
GO

-- ������ʾ��
CREATE TABLE tb(
	id int)

-- ����������¼
INSERT tb SELECT 1
INSERT tb SELECT 2
INSERT tb SELECT 3

-- ɾ�������¼��,��ǰ�������
DELETE tb WHERE id < 3

-- �ٴβ���������¼
INSERT tb SELECT 2
INSERT tb SELECT 1

-- ��ʾ���
SELECT * FROM tb
GO

-- ���Ͼۼ�����
CREATE CLUSTERED INDEX IDX_tb_id
	ON tb(
		id)

-- ��ʾ���
SELECT * FROM tb
