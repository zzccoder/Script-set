--a. ����������ת��Ϊ�ַ���ĸ�ʽ
SELECT * FROM tbname
WHERE DateField LIKE '2005-01-01%'

SELECT * FROM tbname 
WHERE LEFT(DateField, 10) = '2005-01-01'

SELECT * FROM tbname
WHERE CONVERT(CHAR(10), DateField, 120) = '2005-1-1'

SELECT * FROM tbname 
WHERE DateField LIKE '2005-01-01%'

--b.  ��������������ѯ(��ѯ2005��2����2006��3�µ�����)
SELECT * FROM tbname 
WHERE Year(DateField) = 2005 AND Month(DateField) >= 2
	AND Year(DateField) = 2006 AND Month(DateField) <= 3
