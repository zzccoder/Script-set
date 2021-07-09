
-----------------最新留言查询过程-------------------------------
use blogs
Go
create procedure selectNewMessage
@userId int 
as
begin
	select top 3* from [message] where userId=@userId  order by  messagetime desc 
end 

---------------------用户验证存储过程----------------------------
use blogs
Go
create procedure user_proving
@u_name nvarchar,
@u_pwd nvarchar
as 
begin
	select * from [T_User] where u_name = @u_name and u_pwd= @u_pwd;
end 


