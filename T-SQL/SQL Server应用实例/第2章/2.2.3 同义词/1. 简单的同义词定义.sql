-- 创建一个引用存储过程的同义词
IF OBJECT_ID(N'dbo.p_dir', 'SN') IS NOT NULL
	DROP SYNONYM dbo.p_dir;

CREATE SYNONYM dbo.p_dir
FOR
master.dbo.xp_dirtree;

--  引用同义词和引用原始存储过程一样, 包括存储过程参数的引用
EXEC dbo.p_dir 'c:\', 1;
