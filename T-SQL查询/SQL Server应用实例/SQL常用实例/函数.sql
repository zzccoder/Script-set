create database function1 
----------------------------�ַ�������--------------------------

--�ַ�������charindex ����Ѱ��һ��ָ�����ַ�������һ���ַ����е���ʼλ�á�
select charindex('accp','myaccpcoures',1)
--�ַ�������len�����ַ����ĳ���
select len('123')
--�ַ�������Lower�ַ���ת��ΪСд
select Lower('ABC')
--�ַ�������Upper���ַ���ת��Ϊ��д
select Upper('abc')
--�ַ�������Ltrim�����ߵĿո�
select Ltrim(' adb')
--�ַ�������Rtrim����ұߵĿո�
select Rtrim(' ads ')
--�ַ�������right���ַ����ұ߷���ָ����Ŀ���ַ���
select Right('1234',3)
--�ַ�������replace�滻һ���ַ����е��ַ�
select replace('123123123','1','abc')
--�ַ�������stuff���ַ�����ɾ��ָ�����ȵ��ַ����ڸ�λ�ò���һ��
--�µ��ַ���
select stuff('123456789',2,3,'a')

------------------------------���ں���-----------------------------

--��õ�ǰ��ϵͳ����
select getdate()
--���ƶ�����ֵ��ӵ�ָ�������ڲ��ֺ������
select dateadd(mm,5,01/01/90)
select dateadd(dd,5,01/01/90)
select dateadd(yy,5,01/01/90)
--�������������·�
select datediff(mm,'01/01/20','01/05/20')
--��Ĳ��
select datediff(yy,'01/01/20','05/01/20')
--���ڵĲ��
select datediff(dd,'01/01/20','01/01/25')
--���ص������ڼ�
select datename(dw,'01/01/2000')
--��������ָ�����ڲ��ֵ�������ʽ--��������
select datepart(day,'01/15/2000')


-------------------------------��ѧ����-------------------------

--����ֵ����
select abs(-43)
--���ش��ڻ�����������Ա��ʽ���������
--����ȡ��
select ceiling(43.5)
--ȡС�ڻ����ָ�����ʽ���������
--����ȡ��
select floor(43.5)
--ȥ��ֵ���ʽ����ֵ
select power(5,2)
--��������
select round(43.543,1)
--������������+1�����ڸ�������-1,����0�򷵻�0
select sign(-43)
--ȡ���������ʽ��ƽ����
select sqrt(9)

------------------------------ϵͳ����----------------------

--����ת����������
select convert(varchar(5),12345) 
--���ص�ǰ�û�������
select current_user
--���ص�ǰ�û���¼�ļ��������
select Host_name()
--���ص�ǰ����¼���û�����
select System_User
--�Ӹ������û�Id�����û���
select User_name(1)
--��������ָ�����ʽ���ֽ���
select datalength('�й�A��')

-------------------------------�ۼ�����-------------------

select * from fun
--���Sum
select sum(Sun) from fun
--��ƽ��ֵ
select avg(sun) from fun
--���ܸ���
select count(*) from fun
--�����ֵ
select max(sun) from fun
--����Сֵ
select min(sun) from fun 
create table fun
(
    Sun int
)
insert into fun values(1)
insert into fun values(2)
insert into fun values(3)
insert into fun values(4)
insert into fun values(5)
insert into fun values(6)