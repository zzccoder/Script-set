use ExtentOfPower
Go
if exists(select * from sysobjects where name='[user]')
	drop table [user]
create table [user]  ---用户表
(
	id int identity primary key, ---  用于排序Id
	userId int not null,      -----用户Id
	UserName nvarchar(40) not null,   ---用户姓名	
)	
if exists(select * from sysobjects where name='rols')
	drop table rols
create table rols     ---角色表
(
	id int identity primary key, -----用于排序Id
	rolsId int not null,
	RolsName nvarchar(50) not null
)
if exists(select * from sysobjects where name='rols_user')
	drop table rols_user
	create table rols_user     ---用户角色关系表
	(
		id int identity primary key, -----用于排序的ID
		RolsId int not null,   ---角色Id
		userId int not null  ---用户Id
	) 
if exists(select * from sysobjects where name='FunctionGroup')
	drop table FunctionGroup
	create table FunctionGroup   ---功能组表
	(
		id int Identity primary key,
		FunctionGroupId int not null,
		FunctionGroupName nvarchar(50) not null
	)
if exists(select * from sysobjects where name='module') 
	drop table module              ----页面表
	create table module
	(
		id int identity primary key,
		moduleId int not null,
		moduleName nvarchar(50) null,		
		parentId int default(0),
		moduleAddress nvarchar(50) not null,
		FunctionGroupId int not null
		
	)
if exists(select * from sysobjects where name='ButtonAll')
		drop table ButtonAll     -----全部的Button
		create table ButtonAll
		(
			id int identity primary key,
			buttonId int not null,
			buttonName nvarchar(50) not null,
			buttonAddress nvarchar(60) not null,
			ButtonEnabled int default(1) not null,			
			FunctionGroupId int not null						
		)
if exists(select * from sysobjects where name='role_power')	
		drop table role_power    ----权限分配
		create table role_power
		(
			id int identity primary key ,
			RolsId int not null,			
			FunctionGroupId int not null
		)
			

	
	-------------------------------------------------波兄著-----------------
	