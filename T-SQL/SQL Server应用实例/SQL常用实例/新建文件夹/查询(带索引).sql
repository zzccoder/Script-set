USE [Books]
GO
/****** Object:  StoredProcedure [dbo].[AllSignUp]    Script Date: 11/08/2012 08:58:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE  [dbo].[AllSignUp]
@name varchar(20)
as
begin
select * from SignUp with(index(UpIndex)) where name=@name
end

create unique index NameUser on T_user(T_UserName);  ---唯一索引创建

create index NameUser on T_user(T_userName);   ----非聚集索引

create nonclustered index NameUser on T_user(T_userName)  ---非聚集索引

create clustered index NameUser on T_user(T_userName)   ---聚集索引


		F EXISTS (SELECT name FROM  sysindexes
          WHERE name = 'index_School')
          create  index index_67School on Schools(School_name)
go