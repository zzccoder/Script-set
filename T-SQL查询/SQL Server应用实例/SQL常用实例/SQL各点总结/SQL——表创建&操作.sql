use BD_1110A         ----要使用的数据库
if exists(select * from sysobjects where name='[user]')  --检查[user]表是否存在,如果存在删除掉此表
	drop table [user]      -----删除表
	
create table [user]   ----创建表,因为user在sql中是关键字所以这里要是用中括号给包起来
(
	id int identity(1,1) primary key,
	name nvarchar(10) not null,      ----------非空约束
	sex char(4) check(sex='男' or sex='女') default '男',----检查约束：范围,默认为'男'
	age int check(age>=0 and age<=100),    
	phone char(15) unique       -----唯一约束 
)

Go
--创建表
create table info  
(
  --identity(1,1)自增列（种子，增量） primary key 主键约束
  stuNo int identity(1,1) primary key, 
  stuName varchar (20)	not null,
  
  --check()检查约束 check (列名 lick 条件) 
  StuEmail varchar(20) check(stuEmail like '%@%' ) not null,
  
  -- not null 非空
  stuID numeric(18,0) unique check(len(stuID)=18)not null,
  
  --check()检查约束 check (列名=条件 或 列名=条件)  or或and 
  stuSex char(2) check(stuSex='男' or stuSex='女') not null,
  
   --unique  唯一约束 check (len(列名)=11)   
  stuTel char(11) unique check(len(stuTel)=11) not null,
  
  --check()检查约束 check (列名>=条件 或 列名<=条件)
  stuAge int check(stuAge>='0' or stuAge<='100') not null,
  
  -- default()  默认约束 default('默认值')
  stuAddress varchar(50) default('北京海淀') 
)

Go
--查看goods表相关信息
exec sp_help [user]

------------修改表结构
--增加一列
alter table [user]
add aa varchar(20)
--修改一列
alter table [user]
alter column aa int
--删除一列
alter table [user]
drop column aa
Go ---批量处理

/*
1 增加数据
   1.1 语法
	insert [into] 表名 [(字段名)] values (值)
   1.2 一次插入多条数据
	 a 一次插入多行数据
		insert [into] 表名 [(字段名)] values (值),(值),(值)...
		
		insert [into] 表名 [(字段名)] 
		select 值 union
		select 值 union
		select 值
		
	b 将一张表中的数据插入到不存在的表中
		select 列名
		into 新表名   --不存在 
		from 旧表名
				
	c 将一张表中的数据赋值到存在的表中
		insert [into] 新表名 [(字段名)]
		select 列名
		from 旧表名
		
2 修改数据
	update 表名 set 字段1=值1[,字段2=值2,....] [where 条件]
	
3 删除数据
	delete [from] 表名 [where 条件]
4 查询数据
	select 列名 from 表名
	[where 条件]
	[group by 分组列]
	[having 分组条件]
	[order by 排序列[asc|desc]]
	说明：
		列名前面可以放：	
			限制行数：top n 
					  top n percent
			去掉重复项：distinct
*/
insert into [user] values('李继波','男','20','18210480488'),
                         ('韩超超','男','20','12332112311')------ 插入数据
                         
select * from [user]   ---查看[user]表

--模糊查询
--通配符：like
/*
		%：0个或多个字符
		_：一个字符
		[]:在范围内的一个字符
		[^]：不在范围内的一个字符
*/

select * from [user] where name like '李%'  ---模糊查询

update [user] set sex='女' where id='3';  ---修改表信息

delete from [user] where id=1;           ---删除
--删除表（先删除从表，再删除主表）



