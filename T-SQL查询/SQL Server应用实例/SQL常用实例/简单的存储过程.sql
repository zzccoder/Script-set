-------------------------��������ѯ�洢����--------------
CREATE PROCEDURE  User_T_select
as 
begin
select * from [user];
end
        -----ִ�й���------


------------------------��������ѯ�洢����----------------
Go
create procedure User_T_where_select
@ID int
as
begin
select * from [user] where u_id=@ID;
end

------------------------ɾ���洢����------------------------------------
Go
create procedure User_T_where_Delete
@ID int
as
begin
	delete [user] where u_id=@ID;
end


-------------------------�򵥵����Ӵ洢����------------------
Go
 create proc User_T_Add
 @u_name nvarchar,
 @u_pwd nvarchar
 as
 begin
  insert into [user] values('@u_name','@u_pwd');
 end
  
Go
-------------------------�޸ı���--------------------
create procedure User_T_update
@ID int,
@u_name nvarchar,
@u_pwd nvarchar
as
begin
	update [user] set u_name=@u_name,u_pwd=@u_pwd where u_id=@ID;
end
	
Go
---------------------------���Է�ҳ�洢����---------------------
create procedure leave_paging
@pagsize int,
@pagIndex int
as
begin
	select top (@pagsize)* from [message] where messagetime not in(select top ((@pagIndex-1)*@pagsize) messagetime  from [message] order by messagetime desc) order by messagetime desc; 
end
Go

exec leave_paging
@pagsize=3,
@pagIndex=1
	
	Go
------------------------��������  �����û�ID  ���ҳ�洢����----------------------
create procedure new_leave_pading
@deletemessageId int,

@pagsize int,
@pagIndex int
as
begin



	select top (@pagsize) t1.messagecontent,t1.messagetime,t1.u_name from ( select messagecontent,messagetime,u_name from message inner join T_User
on message.userId=T_User.u_id  where u_id= @deletemessageId ) as t1 where messagetime not in 
	(select top((@pagIndex-1)*@pagsize) messagetime from
		( select messagecontent,messagetime,u_name from message inner join T_User
on message.userId=T_User.u_id  where u_id= @deletemessageId ) as t
	order by t.messagetime desc) order by messagetime desc;

end

Go
exec new_leave_pading
@deletemessageId =1,

@pagsize =2,
@pagIndex =1

drop proc new_leave_pading
	Go
	
	---------------------------------��������  ��  ���û�ID���ҳ�洢����--------------
	
create procedure new_leave_pading_1
@pagsize int,
@pagIndex int
as
begin



	select top (@pagsize) t1.messagecontent,t1.messagetime,t1.u_name from ( select messagecontent,messagetime,u_name from message inner join T_User
on message.userId=T_User.u_id) as t1 where messagetime not in 
	(select top((@pagIndex-1)*@pagsize) messagetime from
		( select messagecontent,messagetime,u_name from message inner join T_User
on message.userId=T_User.u_id) as t
	order by t.messagetime desc) order by messagetime desc;

end

exec new_leave_pading_1
@pagsize=7,
@pagIndex=1

Go

------------------------
create proc select_leave
as
begin
	select * from [message];
end
Go
exec  select_leave

----------------ɾ����ɾ�Ĳ�--------------------------------
drop proc User_T_select 
drop procedure User_T_where_select;
drop procedure User_T_where_Delete
drop procedure User_T_Add
drop procedure User_T_update

