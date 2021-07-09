

-----------------------------------------------------------------------------
Go
create table [user]    ----用户
(
	Id int primary key identity(1,1) not null,
	UserId int not null,
	UserName nvarchar(50)  not null,
	UserPwd nvarchar(50) not null
)

Go 
create table [role]    ------角色
(
	id int primary key identity(1,1) not null,
	roleId  int not null,
	roleName nvarchar(50) not null, 
)
Go
create table user_role    -----用户角色关系
(
	id int primary key identity(1,1) not null,
	roleId int not null,
	UserId int not null,
)
Go
create table modules     ------功能模块
(
	id int primary key identity(1,1) not null,
	modulesID int null,
	modulesName nvarchar(50)  null,
	modulesAddress nvarchar(50) null
)
Go	


create table role_modules     -----角色与模块的关系
(
	id int primary key identity(1,1) not null,
	modulesID int not null,
	roleId int not null	
)
Go

drop table [User] 
drop table T_UserGroup
drop table T_modules
drop table T_manage_Modules




