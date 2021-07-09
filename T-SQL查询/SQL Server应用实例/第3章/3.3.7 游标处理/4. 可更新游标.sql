CREATE TABLE #(
	id int, a int)
INSERT #(
	id, a)
SELECT 1,1 UNION ALL
SELECT 2,2 UNION ALL
SELECT 3,2

--索引或者约束
--ALTER TABLE # ADD UNIQUE(id)				--惟一键(约束)，提供RID书签
--CREATE INDEX IDX_a ON #(a)				--a列上的普通索引,可以提供RID书签
--CREATE CLUSTERED INDEX IDX_id_1 ON #(id)	--id列上的聚集索引,可以提供群集键书签
--CREATE INDEX IDX_id_2 ON #(id)			--id列上的普通索引,游标的定义语句无法使用该索引提                                                       供的RID书签
--CREATE INDEX IDX_a_id ON #(a,id)			--a列和id列的上普通索引,可以提供RID书签

--游标处理
DECLARE CUR_tb CURSOR LOCAL TYPE_WARNING
FOR
SELECT id 
FROM # 
ORDER BY a

DECLARE @id int
OPEN CUR_tb
FETCH CUR_tb INTO @id
WHILE @@FETCH_STATUS = 0
BEGIN
	UPDATE # SET 
		a = a - @id / 2
	WHERE CURRENT OF CUR_tb

	FETCH CUR_tb INTO @id
END
CLOSE CUR_tb
DEALLOCATE CUR_tb
SELECT * FROM #
DROP TABLE #
