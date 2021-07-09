-- 1. ��Ч�����ڴ�����
--    a. ��ѯ���յ�����
SELECT * FROM tbname 
WHERE DATEDIFF(Day, DateField, GETDATE()) = 0

--    b. ��ѯ���5���ӵļ�¼
SELECT * FROM tbname 
WHERE DATEDIFF(Minute, DateField, GETDATE()) BETWEEN 0 AND 5

--    c. ��ѯ2005��4�µ�����
SELECT * FROM tbname 
WHERE YEAR(DateField)=2005 
	AND MONTH(DateField)=4

SELECT * FROM tbname 
WHERE CONVERT(char(6), DateField, 112) = '200504'

--    d. ��ѯ2005��1����3�µļ�¼
SELECT * FROM tbname 
WHERE CONVERT(char(10), DateField, 112) BETWEEN '20050101' AND '20050331'

SELECT * FROM tbname 
WHERE CONVERT(char(6), DateField, 112) BETWEEN '200501' AND '200502'
GO

-- 2. ���ź�Ĵ���
--    a. ��ѯ���յ�����
SELECT * FROM tbname 
WHERE DateField >= CONVERT(char(10), GETDATE(), 120)
	AND DateField < CONVERT(char(10), GETDATE() + 1, 120)

--    b. ��ѯ���5���ӵļ�¼
SELECT * FROM tbname 
WHERE DateField BETWEEN DATEADD(Minute, -5, GETDATE()) AND GETDATE()


--    c. ��ѯ2005��4�µ�����
SELECT * FROM tbname 
WHERE DateField >= '20050401' AND DateField < '20050501'

--    d. ��ѯ2005��1����3�µļ�¼
SELECT * FROM tbname 
WHERE DateField >= '20050101' AND DateField < '20050401'
GO
