DECLARE 
	@a char(2), @b varchar(2)

-- 1. ���ո�
SELECT
	@a = 'a', @b = 'a',           -- ��1�θ�ֵ
	@a = @a + 'b', @b = @b + 'b'  -- ��2�θ�ֵ

-- ��ʾ���
SELECT a = @a, b = @b

-- 2. ����β��ո�
SELECT
	@b = ' ',          -- ��1�θ�ֵ
	@b = @b + 'ab'       -- ��2�θ�ֵ
SELECT b = @b