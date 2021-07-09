-- 1. 相同的种子值生成同样的随机数
SELECT R1 = RAND(1), R2 = RAND(1)

-- 2. 一条查询中生成的记录是相同的
SELECT TOP 3
	R1 = RAND(), R2 = RAND()
FROM sys.objects
