
use LongForOne
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
	modulesAddress nvarchar(50) null,
	modulesParent_id int not null
)
Go	


create table role_modules     -----角色与模块的关系
(
	id int primary key identity(1,1) not null,
	modulesID int not null,
	roleId int not null	
)
Go

select * from [User]
select * from [role]
select * from user_role
select * from modules
select * from role_modules

drop table [User] 
drop table [role]
drop table user_role
drop table modules
drop table role_modules


Go

create proc AddRole      ----角色添加   
@id int,
@name nvarchar(50)         
as
	insert into [role] Values(@id,@name)
	
	exec AddRole
	@id=3,
	@name='游客'
Go

	create proc AddUser    ----用户添加
	@UserId int,
	@UserName nvarchar(50),
	@UserPwd nvarchar(50)
	as
	    insert into [user] values(@UserId,@UserName,@UserPwd);
	    
	    exec AddUser
	    @UserId =1,
	    @UserName =lijibo,
	    @UserPwd =lijibo	
	    
	DROP PROCEDURE   AddRole  
	
if exists(select * from sysobjects where name='AddUser_role')
		drop proc AddUser_role
		Go
create proc AddUser_role      ---添加用户和角色的关系
@roleId int,
@UserId int 
as
  insert into user_role values(@roleId,@UserId);
  
  exec AddUser_role
  @roleId=1,
  @UserId=1 

  
  Go
  
 if exists(select * from sysobjects where name='NewModules')
		drop proc NewModules
		Go 
create proc NewModules                         ----添加模块信息
@modulesID int,
@modulesName nvarchar(10),
@modulesAddress nvarchar(100)
as 
	insert into modules values(@modulesID,@modulesName,@modulesAddress);	
	
	drop proc NewModules
	
exec NewModules
@modulesID =2,
@modulesName ='2',
@modulesAddress ='/Home/Gtasks/';


if exists(select * from sysobjects where name='AddRole_modules')
	drop proc AddRole_modules
	Go	
	create proc AddRole_modules
	@modulesID int,
	@roleId  int
	as
	   insert into Role_modules values(@modulesID,@roleId);
	   
	   exec AddRole_modules
	   @modulesID=14,
	   @roleId=1;

select * from modules
select * from [Role]
select * from Role_modules
select * from [user] 

----------------------根据用户名查出用户权限-------------------
if exists(select * from sysobjects where name='UserPower')
	drop proc UserPower
	Go
	create proc UserPower
	@userName nvarchar(50)
	as
	
	select * from modules where modulesID in (
	select modulesID from role_modules where roleId=(
		select roleId from user_role where UserId=(
			select UserId from [user] where UserName=@userName)))
		 
		 exec  UserPower
		 @userName ='lijibo'			
			
			
			
	


---------------------------------------------------波兄著-----------------------



