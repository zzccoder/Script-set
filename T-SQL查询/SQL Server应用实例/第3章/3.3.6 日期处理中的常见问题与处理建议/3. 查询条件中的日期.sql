-- 1. 低效的日期处理方法
--    a. 查询当日的数据
SELECT * FROM tbname 
WHERE DATEDIFF(Day, DateField, GETDATE()) = 0

--    b. 查询最近5分钟的记录
SELECT * FROM tbname 
WHERE DATEDIFF(Minute, DateField, GETDATE()) BETWEEN 0 AND 5

--    c. 查询2005年4月的数据
SELECT * FROM tbname 
WHERE YEAR(DateField)=2005 
	AND MONTH(DateField)=4

SELECT * FROM tbname 
WHERE CONVERT(char(6), DateField, 112) = '200504'

--    d. 查询2005年1月至3月的记录
SELECT * FROM tbname 
WHERE CONVERT(char(10), DateField, 112) BETWEEN '20050101' AND '20050331'

SELECT * FROM tbname 
WHERE CONVERT(char(6), DateField, 112) BETWEEN '200501' AND '200502'
GO

-- 2. 调优后的代码
--    a. 查询当日的数据
SELECT * FROM tbname 
WHERE DateField >= CONVERT(char(10), GETDATE(), 120)
	AND DateField < CONVERT(char(10), GETDATE() + 1, 120)

--    b. 查询最近5分钟的记录
SELECT * FROM tbname 
WHERE DateField BETWEEN DATEADD(Minute, -5, GETDATE()) AND GETDATE()


--    c. 查询2005年4月的数据
SELECT * FROM tbname 
WHERE DateField >= '20050401' AND DateField < '20050501'

--    d. 查询2005年1月至3月的记录
SELECT * FROM tbname 
WHERE DateField >= '20050101' AND DateField < '20050401'
GO
