-- 创建测试环境
USE tempdb
GO
CREATE TABLE tb(
	id int
		PRIMARY KEY CLUSTERED,
	col xml)
GO

-- 1. 创建 xml 索引
-- 1.a. 创建 xml 主索引
CREATE PRIMARY XML INDEX PKX_col
	ON tb(col)

-- 1.b. 创建 VALUE 辅助 xml 索引
CREATE XML INDEX IXX_col_value
	ON tb(col)
	USING XML INDEX PKX_col
	FOR VALUE

-- 1.c. 创建 PATH 辅助 xml 索引
CREATE XML INDEX IXX_col_path
	ON tb(col)
	USING XML INDEX PKX_col
	FOR PATH
GO

-- 2. 修改 xml 索引
-- 2.a. 重建 PATH 辅助 xml 索引 IXX_col_path
ALTER INDEX IXX_col_path
	ON tb
	REBUILD

-- 2.b. 禁用 VALUE 辅助 xml 索引 IXX_col_value
ALTER INDEX IXX_col_value
	ON tb
	DISABLE
GO


-- 3. 删除 xml 索引
-- 3.a. VALUE 辅助 xml 索引 IXX_col_value
DROP INDEX IXX_col_value
	ON tb

-- 3.b. 删除 xml 主索引, 注意此操作会同时删除与之相关的辅助 xml 索引
DROP INDEX PKX_col
	ON tb
GO

-- 删除测试环境
DROP TABLE tb