create database lianxi

use lianxi

create table score(
	id int primary key identity(1,1),
	name nvarchar(10),
	[object] nvarchar(10),
	mark int
)

insert into score values
('张三','语文',80),('张三','数学',90),('张三','英语',85),
('李四','语文',83),('李四','数学',95),('李四','英语',89)

select * from score

select 
	a.name, 
	(select b.mark from score as b where b.name = a.name and b.object = '语文' ) as 语文 
from 
	score as a 
group by name 

select score.name as 姓名 ,
语文=SUM(case score.object when '语文' then mark end),
数学=SUM(case score.object when '数学' then mark end),
英语=SUM(case score.object when '英语' then mark end)
from score  GROUP by name

select score.name as 姓名,score.object 语文 insert t1 from score
where score.object='语文'
select 姓名=score.name,数学=score.object insert t2 from score
where score.object='数学'
select 姓名=score.name,英语=score.object insert t3 from score
where score.object='英语'