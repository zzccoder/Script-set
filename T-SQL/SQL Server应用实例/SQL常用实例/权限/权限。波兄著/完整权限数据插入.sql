use ExtentOfPower
Go
insert into [user] values('1','admin'),('2','李继波'),('3','韩超'),('4','子豪');
----------对用户表添加数据
Go
insert into rols values('1','管理者'),('2','会员'),('3','普通用户'),('4','游客');
------------对角色添加数据
Go
insert into rols_user values('1','1'),('1','2'),('2','3'),('3','4')
----------对角色用户关系表添加数据
Go
insert into FunctionGroup values('1','增加'),('2','删除'),('3','修改'),('4','查看');
-----------------对功能组的添加数据
Go
insert into module Values('1','管理页面','0','www.baidu.com/application/index.axps','1'),
							('2','权限管理','0','www.baidu.com/application/index.axps','1'),
							('3','用户页面','1','www.baidu.com/application/index.axps','1');
-----------------对UI页面表添加数据
Go
insert into ButtonAll Values('1','添加','www.baidu.com/application/index.axps','1','1'),
							('2','删除','www.baidu.com/application/index.axps','1','2'),
							('3','查看','www.baidu.com/application/index.axps','1','3')
-----------------对button表添加数据
Go
insert into role_power values('1','1'),('1','2'),('1','3'),('1','4');
--------------对role_power表中添加数据

select * from [user]
select * from rols
select * from rols_user
select * from module
select * from FunctionGroup
select * from ButtonAll
select * from role_power

drop table [user]
drop table rols
drop table rols_user
drop table module
drop table FunctionGroup
drop table ButtonAll
drop table role_power

Go
-------------显示“admin”用户的所有可以操作的页面-------

select * from module where FunctionGroupId in
(
select FunctionGroupId from role_power where RolsId =
(select Rolsid from rols_user where userId=
(select userId from [user] where UserName='admin')) 
)

Go
---------------------显示“admin”用户的所有可以操作的button
select * from ButtonAll where FunctionGroupId in
(
	select FunctionGroupId from role_power where RolsId =
(select Rolsid from rols_user where userId=
(select userId from [user] where UserName='admin')) 
)