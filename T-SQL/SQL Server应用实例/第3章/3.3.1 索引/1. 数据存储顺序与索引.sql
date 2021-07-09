USE tempdb
GO

-- 建立演示表
CREATE TABLE tb(
	id int)

-- 插入三条记录
INSERT tb SELECT 1
INSERT tb SELECT 2
INSERT tb SELECT 3

-- 删除插入记录中,最前面的两条
DELETE tb WHERE id < 3

-- 再次插入两条记录
INSERT tb SELECT 2
INSERT tb SELECT 1

-- 显示结果
SELECT * FROM tb
GO

-- 加上聚集索引
CREATE CLUSTERED INDEX IDX_tb_id
	ON tb(
		id)

-- 显示结果
SELECT * FROM tb
