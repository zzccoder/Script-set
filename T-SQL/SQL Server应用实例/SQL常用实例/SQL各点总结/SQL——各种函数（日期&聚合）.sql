--���ں���
--��õ�ǰʱ��
select GETDATE()

--����ʱ�䣺dateadd�����ڲ��֣�������ʱ�䣩
select dateadd(DAY,5,GETDATE())
select DATEADD(day,-5,getdate())

--datediff(���ڲ��֣�����1������2):��������1������2֮���ʱ���
select DATEDIFF(MONTH,'1989-01-12','1994-11-27')
select DATEDIFF(SECOND,'2011-03-21',getdate())
select DATEDIFF(dd,'1992-02-12',GETDATE())
select DATEDIFF(dd,getdate(),DATEADD(yy,70,'1992-02-12'))

--datepart(���ڲ��֣�ʱ��)��������ڲ���
select DATEPART(yy,getdate())-20



--��ѧ����
--abs����������ֵ
select ABS(-25)
select ABS(0)

--rand():�����
select RAND()

--round(��ֵ��С��λ��):��������
select ROUND(-11.4,0)
select ROUND(-11.5,0)
select ROUND(-11.6,0)
select ROUND(11.25632,2)-- 11.26000

--floor():����ȡ�������С�ڻ���ڵ�ǰ�����������
select FLOOR(-11.2)  -- -12
select FLOOR(-11)  -- -11

select FLOOR(11.2)  -- 11
select FLOOR(11)  --11


--ceiling():����ȡ��
select CEILING(-11.2)  -- -11
select CEILING(-11)   --  -11
select CEILING(11.2)   --  12
select CEILING(11)   --  11


--�ַ�������
--left() right() :�����ң���ȡָ�����ȵ��ַ�
select LEFT('abcdefg',3)
select RIGHT('abcdefg',3)

--len()���ַ�����
select LEN('�й�')

--lower() upper() :ת���ɴ�д��Сд��
select LOWER('ASDFsdaf')
select UPPER('SDAFSADFdasdfasdf')

--ltrim() rtrim() :ȥ���ַ������ң��˵Ŀո�
select 'c' + LTRIM('163 36   ')+'d'
--ȥ�����˿ո�
select 'c' + rtrim(ltrim (' 163 36  ')) + 'd'

--reverse() :��ת�ַ���
select REVERSE('abcdefg')

--replace(�ַ������ɣ���) ���ַ����滻
select REPLACE('0000abdfoasoodf0','0','o')

--substring(Ҫ��ȡ���ַ�������ʼλ�ã�����)���ַ�����ȡ
select SUBSTRING('abcdefg',2,4)

use mytest
select * from employee
--�鿴ÿλԱ��������
select substring(empname,1,1) from employee

--�����֤�����е�1���滻��0
select replace(empid,'1','0') from employee

--�鿴ÿλԱ�����ֵĸ���
select empname,LEN(empname) from employee


---����ת������

--cast(Ҫת������ֵ as Ŀ������)
select 'a'+CAST(1 as CHAR(2))

--�뽫Ա����ź�������Ϊһ���ֶ�
select cast(empNo as CHAR(2))+empname from employee

--convert(Ŀ�����ͣ�Ҫת������ֵ)
select CONVERT(char(2),1)+'a'
select convert(char(2),empNo)+empname from employee

--��ȡÿ��Ա��������
select right(empname,len(empname)-1) from employee
select SUBSTRING(empname,2,len(empname)-1) from employee

select REVERSE(empname) from employee