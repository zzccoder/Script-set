--����
----ȫ�ֱ�����ϵͳ���� @@
--@@error:���һ��ִ��sql���Ĵ����
select @@ERROR

----�ֲ������� �û��Զ��� @ ������declare���ٸ�ֵset select

--��������
declare  @i int
--��ֵ
set @i=1
print @i

declare @j int,@k int
select @j=5,@k=10
print @j
print @k


--�жϵ�ǰ����Ƿ�������
declare @year int
select @year=DATEPART(YEAR,GETDATE())
if (@year%4=0 and @year%100<>0 or @year%400=0)
	print cast(@year as char(4)) +'������'
else
	print convert(char(4),@year)+'��������'
go
--1-100�ĺ�
declare @sum int,@i int
select @sum=0,@i=1
while(@i<=100)
	begin
		set @sum=@sum+@i
		 select @i=@i+1
	end
print @sum

Go
use [user] 
declare @sum int,@i int
select @sum=10000005,@i=1
while(@i<=@sum)
	begin
		insert into [user] values('li'+CONVERT(varchar, @i)+'',GETDATE(),'li1'+CONVERT(varchar, @i)+'')
		set @i=@i+1
	end
		

select COUNT(1) from [user]
select Name from [user] where Name='li190'