-- 1. ��ͬ������ֵ����ͬ���������
SELECT R1 = RAND(1), R2 = RAND(1)

-- 2. һ����ѯ�����ɵļ�¼����ͬ��
SELECT TOP 3
	R1 = RAND(), R2 = RAND()
FROM sys.objects
