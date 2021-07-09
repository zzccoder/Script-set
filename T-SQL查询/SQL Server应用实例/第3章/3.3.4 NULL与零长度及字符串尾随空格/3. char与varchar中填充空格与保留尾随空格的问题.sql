DECLARE 
	@a char(2), @b varchar(2)

-- 1. 填充空格
SELECT
	@a = 'a', @b = 'a',           -- 第1次赋值
	@a = @a + 'b', @b = @b + 'b'  -- 第2次赋值

-- 显示结果
SELECT a = @a, b = @b

-- 2. 保留尾随空格
SELECT
	@b = ' ',          -- 第1次赋值
	@b = @b + 'ab'       -- 第2次赋值
SELECT b = @b