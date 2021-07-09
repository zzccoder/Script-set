

-----------------------------------------------------------------------------
Go
create table [user]    ----�û�
(
	Id int primary key identity(1,1) not null,
	UserId int not null,
	UserName nvarchar(50)  not null,
	UserPwd nvarchar(50) not null
)

Go 
create table [role]    ------��ɫ
(
	id int primary key identity(1,1) not null,
	roleId  int not null,
	roleName nvarchar(50) not null, 
)
Go
create table user_role    -----�û���ɫ��ϵ
(
	id int primary key identity(1,1) not null,
	roleId int not null,
	UserId int not null,
)
Go
create table modules     ------����ģ��
(
	id int primary key identity(1,1) not null,
	modulesID int null,
	modulesName nvarchar(50)  null,
	modulesAddress nvarchar(50) null
)
Go	


create table role_modules     -----��ɫ��ģ��Ĺ�ϵ
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




