--����ת������,ֵ���ղ�
select CONVERT(varchar, getdate(), 120 )
2004-09-12 11:06:08 

select replace(replace(replace(CONVERT(varchar, getdate(), 120 ),'-',''),' ',''),':','')
20040912110608 

select CONVERT(varchar(12) , getdate(), 111 )
2004/09/12 

select CONVERT(varchar(12) , getdate(), 23 )   
2004/09/12 

select CONVERT(varchar(12) , getdate(), 112 )
20040912 

select CONVERT(varchar(12) , getdate(), 102 )
2004.09.12 

select CONVERT(varchar(12) , getdate(), 101 )
09/12/2004 

select CONVERT(varchar(12) , getdate(), 103 )
12/09/2004 

select CONVERT(varchar(12) , getdate(), 104 )
12.09.2004 

select CONVERT(varchar(12) , getdate(), 105 )
12-09-2004 

select CONVERT(varchar(12) , getdate(), 106 )
12 09 2004 

select CONVERT(varchar(12) , getdate(), 107 )
09 12, 2004 

select CONVERT(varchar(12) , getdate(), 108 )
11:06:08 

select CONVERT(varchar(12) , getdate(), 109 )
09 12 2004 1 

select CONVERT(varchar(12) , getdate(), 110 )
09-12-2004 

select CONVERT(varchar(12) , getdate(), 113 )
12 09 2004 1 

select CONVERT(varchar(12) , getdate(), 114 )
11:06:08.177

SELECT CONVERT(VARCHAR(5),GETDATE(),114)
15:43
--saleTime.FormateDate("yyyy-MM-dd HH:mm:ss.fff");

--���ں���
--��õ�ǰʱ��
select GETDATE()

--����ʱ�䣺dateadd�����ڲ��֣�������ʱ�䣩
select dateadd(DAY,5,GETDATE())
select DATEADD(day,-5,getdate())

--datediff(���ڲ��֣�����1������2):��������1������2֮���ʱ���

DECLARE @i int 
SELECT  @i =  DATEDIFF(d,'1989-01-12','1994-11-27')
PRINT(@i)

select DATEDIFF(SECOND,'2011-03-21',getdate())
select DATEDIFF(dd,'1992-02-12',GETDATE())
select DATEDIFF(dd,getdate(),DATEADD(yy,70,'1992-02-12'))

--datepart(���ڲ��֣�ʱ��)��������ڲ���
select DATEPART(yy,getdate())-20
SELECT DATEPART(yymmdd,CONVERT(VARCHAR(10),'2012-02-03 00:00:00',121))

