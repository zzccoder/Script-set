USE BD_1110A
GO
/*
   使用游标有四种基本的步骤:声明游标、打开游标、提取数据、关闭游标。 
   
一 1、创建游标的基本格式：

	DECLARE 游标名称 [INSENSITIVE] [SCROLL]
    CURSOR FOR select语句 
   [FOR{READ ONLY|UPDATE[OF 列名字表]}]
	
   2、各点详解:
	
	insensitive 选项: 说明所定义的游标中使用select语句查询结果的拷贝,
					对游标的操作都基于该拷贝进行,因此,这期间对游标
					基本表的数据修改不能反映到游标中,这种游标也不允许通过它修改基本表的数据。
					
	scroll选项：指定该游标可用所有的游标数据定位方法提取数据，
				游标定位方法包括
				prior（优先的）、first（第一）、last（最后）、
				absolute（绝对的） n 和relative（相对） n 选项
				
	Select语句：为标准的select查询语句，其查询结果为游标的数据集合，
				构成游标数据集合的一个或多个表称作游标的基表。
				在游标声明语句中，有下列条件之一时，
				系统自动把游标定义为（insensitive）游标：
				SELECT语句中使用了
				（distinct（明显的））（union（联合的））（GROUP BY（分组）） 或HAVING（所有）等关键字；
				 任一个游标基表中不存在唯一索引。
	read only 选项：说明定义只读游标。
	
	update [OF 列名字表]选项：定义游标可修改的列。如果使用OF 列名字表选项，
	                          说明只允许修改所指定的列，否则，所有列均可修改。 
	  
 */
 
declare authors_cursor cursor for
select name from [user]
where name like '李%'
order by name

open authors_cursor     --打开游标  在打开时将产生一个临时表，将定义的游标数据集合从其基表中拷贝过来。 

-----------游标打开后，可以从全局变量@@CURSOR_ROWS中读取游标结果集合中的行数。
 
 
/*
 二 1、读游标区中的当前元组
 
		 FETCH [[NEXT|PRIOR|FIRST|LAST| ABSOLUTE n| RELATIVE n]  
		 FROM  游标名
		 [INTO @变量1, @变量2, ….]
		 
	2、	各点详解:
	
	 NEXT：说明读取游标中的下一行，
	       第一次对游标实行读取操作时，
	       NEXT返回结果集合中的第一行。
	       
	PRIOR、FIRST、LAST、ABSOLUTE n 和RELATIVE n 选项只适用于SCROLL游标。
			   fetch first; 读取第一行
 
             fetch next; 读取下一行
 
             fetch prior; 读取上一行
 
             fetch last; 读取最后一行
 
             fetch absolute n; 读取某一行
	 
					如果n为正整数，则读取第n条记录
	 
					如果n为负数，则倒数提取第n条记录
	 
					如果n为，则不读取任何记录
 
             fetch pelative n
 
					如果n为正整数，则读取上次读取记录之后第n条记录
	 
					如果n为负数，则读取上次读取记录之前第n条记录
	 
					如果n为，则读取上次读取的记录

			
	INTO子句 说明将读取的数据存放到指定的局部变量中，
			每一个变量的数据类型应与游标所返回的数据类型严格匹配，
			否则将产生错误。		 
*/

 

fetch next from authors_cursor  ---读取游标
FETCH RELATIVE 2 FROM authors_cursor

/*
三 1、 利用游标修改数据
		update语句和delete语句也支持游标操作，
		它们可以通过游标修改或删除游标基表中的当前数据行。
		
	UPDATE语句的格式为：
		 UPDATE table_name
		 SET 列名=表达式}[,…n]
		 WHERE CURRENT OF authors_cursor
		 DELETE语句的格式为：
		 DELETE FROM table_name
		 WHERE CURRENT OF authors_cursor
		 
	2、 各点详解：
		
		CURRENT OF authors_cursor：
				表示当前游标指针所指的当前行数据。
				CURRENT OF 只能在UPDATE和DELETE语句中使用。  
*/
use BD_1110A
CLOSE authors_cursor    --close 关闭游标
DEALLOCATE authors_cursor  ----删除游标
Go

create procedure [pro_cusor]    ----创建存储过程
as
begin
declare mycusor cursor for
select  name from [user] 
open mycusor 
declare @name nvarchar(10)
fetch next from mycusor into @name
while(@@FETCH_STATUS=0)
begin
	DELETE FROM NewUser WHERE Name =@name
     fetch next from mycusor into @name
end 
close mycusor
deallocate mycusor
end
-------------------上面创建一个带游标的存储过程---------------
exec  pro_cusor    -----执行存储过程


select * from NewUser
select * from [user]

  --创建一个游标
	declare cursor_stu cursor scroll for
	select [sid], sname, age from student;
	--打开游标
	open cursor_stu;
	--存储读取的值
	declare	@id int, 
			@sname varchar(20),
	        @age int;
	--读取第一条记录
	fetch first from cursor_stu into @id, @sname, @age;
	--循环读取游标记录
	print '读取的数据如下：';
	--全局变量
	while (@@fetch_status = 0)
	begin    
	print  @sname
	--继续读取下一条记录    
	fetch next from cursor_stu into @id, @sname, @age;
	end
	--关闭游标
	close cursor_stu;
	--删除游标--
	deallocate cursor_stu;



