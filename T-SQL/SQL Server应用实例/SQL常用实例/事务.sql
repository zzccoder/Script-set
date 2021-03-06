USE [Books]
GO
/****** Object:  StoredProcedure [dbo].[InserSignUp]    Script Date: 11/08/2012 11:43:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE  [dbo].[InserSignUp]
@name varchar(20),--名字
@sex varchar(4)--性别
as
begin
BEGIN TRANSACTION  --开启事务 –transaction
begin try
DECLARE @ERRNO INT--定义@ERRNO

	INSERT INTO SignUp(name,sex) VALUES(@name,@sex);
	INSERT INTO SignUp(name,sex) VALUES(@name,'女');
	SET @ERRNO =0--如果没有报错则赋值0
COMMIT TRANSACTION--提交事务
    return @ERRNO--返回值
  END try--结束
 begin catch --报错跳到catch
ROLLBACK TRANSACTION--回滚
SET @ERRNO =1--赋值1
   return @ERRNO--返回值
	END catch
	end
	
	GO
create procedure insersing
@name varchar(20),
@sex varchar(4)
as
 begin Transaction
 begin try
	declare @e int
		insert into SingUp(Name,sex) Values(@name,@sex);
		insert into singup(Name,sex) values(@name,'女');
	set @e=0;
	commit Transaction
	return @e
	end try
	begin catch
	rollback transaction
	set @e=1
	return @e
	end catch
	end
