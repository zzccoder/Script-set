-- ȫ����ʱ��Ŀɼ��ԺͿ�������ʾ

-- 1. ����A������Ϊ##tb����ʱ��
CREATE TABLE ##tb(
	id int)
GO


-- 2. ����B����ֱ�ӷ�������A������##tb����ʱ��

----�������B��ͼ����##tb����ʱ��,����յ�������Ϣ,���ҽ������ɹ�
--CREATE TABLE ##tb(
--	id int)

BEGIN TRAN
	INSERT ##tb(
		id)
	VALUES(
		1)
	WAITFOR DELAY '00:05:00'
COMMIT TRAN
GO

-- 3. �Ͽ�����A,��������B. Ȼ��������C����������A��������ʱ��##tb
SELECT * FROM ##tb WITH(NOLOCK)
