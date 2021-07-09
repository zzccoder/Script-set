--变量
----全局变量：系统定义 @@
--@@error:最后一次执行sql语句的错误号
select @@ERROR

----局部变量： 用户自定义 @ 先声明declare，再赋值set select

--声明变量
declare  @i int
--赋值
set @i=1
print @i

declare @j int,@k int
select @j=5,@k=10
print @j
print @k


--判断当前年份是否是闰年
declare @year int
select @year=DATEPART(YEAR,GETDATE())
if (@year%4=0 and @year%100<>0 or @year%400=0)
	print cast(@year as char(4)) +'是闰年'
else
	print convert(char(4),@year)+'不是闰年'
go
--1-100的和
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