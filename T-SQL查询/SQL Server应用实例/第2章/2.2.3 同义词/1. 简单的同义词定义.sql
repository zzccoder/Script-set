-- ����һ�����ô洢���̵�ͬ���
IF OBJECT_ID(N'dbo.p_dir', 'SN') IS NOT NULL
	DROP SYNONYM dbo.p_dir;

CREATE SYNONYM dbo.p_dir
FOR
master.dbo.xp_dirtree;

--  ����ͬ��ʺ�����ԭʼ�洢����һ��, �����洢���̲���������
EXEC dbo.p_dir 'c:\', 1;
