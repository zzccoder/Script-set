USE [HappyLifeOA]
GO
/****** 对象:  StoredProcedure [dbo].[proc_Base_GetEmployeeList]    脚本日期: 06/21/2017 21:52:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER  PROCEDURE [dbo].[proc_Base_GetEmployeeList] 
@ID		int OUTPUT 
AS
BEGIN
--'将AD中的信息导入到表Employee中
--'该存储过程由SQL server Agent执行
CREATE TABLE [dbo].[#TempUserList] (
	[sAMAccountName] [varchar] (80) NOT NULL ,
	[cn] [varchar] (80) NULL ,
	[company] [varchar] (200) NULL,
	[department] [varchar] (200) NULL,
	[mail] [varchar] (80) NULL ,
	[objectGUID] [varbinary] (256) NULL 
) ON [PRIMARY]

--'从AD中取得用户信息到临时表中
insert into #TempUserList(sAMAccountName,cn,company,department,mail,objectGUID)
(SELECT replace(sAMAccountName,char(10),''),
replace(cn,char(10),''),
replace(replace(company,char(10),''),'幸福人寿',''),
replace(department,char(10),''),
replace(mail,char(10),''),
objectGUID 
FROM OPENQUERY(ADSI,
      'SELECT sAMAccountName,cn,company,department,mail,objectGUID FROM ''GC://hlic.cn'' WHERE objectCategory = ''Person'' and objectClass= ''user''')
WHERE  (company IS NOT NULL) and (company <> '') and (company <> '外来人员') 
AND (sAMAccountName NOT IN (select Account from Base_Employee where IsDel=0))
)

	declare @RealName varchar(50)
    declare @OrgID int,@OrgPID int,@RealOrgID INT 
	declare @OU1 varchar(100),@OU2 varchar(100),@OUTemp varchar(100)

	declare @sAMAccountName varchar(50)
	declare @cn varchar(50)
	declare @company varchar(200)
	declare @department varchar(200)
	declare @mail varchar(80)
	declare @objectGUID varbinary(256)
	
	declare userlista cursor for
	select replace(sAMAccountName,' ',''),replace(cn,' ',''),replace(company,' ',''),
	replace(department,' ',''),replace(mail,' ',''),objectGUID from #TempUserList
	for read only

	open userlista
	--从临时表中将AD中的人员信息导入到用户表(Employee)中
	fetch next from userlista into @sAMAccountName ,@cn ,@company,@department,@mail ,@objectGUID
	while @@fetch_status<>-1
	begin
	    IF NOT EXISTS(SELECT ID FROM Base_Employee WHERE ObjectGUID=@objectGUID)
		BEGIN
			SET @OrgPID=0
			SET @OrgID = 0
			SET @RealOrgID = 0
			SET @OU1 = ''
			SET @OU2 = ''
			set @OUTemp=''
			set @RealName=@cn
			if CHARINDEX('&',@company)>0
			begin
				set @OU1 = substring(@company,0,CHARINDEX('&',@company))
				--sET @OU2 = substring(@company,CHARINDEX('&',@company)+1,len(@company)-len(@OU1)+1)
				set @OUTemp=substring(@company,CHARINDEX('&',@company)+1,len(@company)-len(@OU1)+1)
				if CHARINDEX('&',@OUTemp)>0
					set @OU2 = substring(@OUTemp,0,CHARINDEX('&',@OUTemp))
				else
					sET @OU2 = @OUTemp
			end
			ELSE
				SET @OU1=@company
			IF @OU1<>'' AND @OU1 IS NOT NULL
			BEGIN
				select @OrgPID=ID from Base_Organize where FatherID=0 AND IsDel=0 and OrgName=@OU1
			END
			IF @OU2 <>'' AND @OU2 IS NOT NULL
			BEGIN
				if exists(SELECT ID from Base_Organize where FatherID=@OrgPID AND IsDel=0 and OrgName=@OU2)
				begin
					SELECT @OrgID=ID from Base_Organize where FatherID=@OrgPID AND IsDel=0 and OrgName=@OU2
				end
				else
					set @OrgID=@OrgPID
			END
			ELSE
				SET @OrgID=@OrgPID
			IF @department<>'' AND @department IS NOT NULL
			BEGIN
				if exists(SELECT ID from Base_Organize where FatherID=@OrgID AND IsDel=0 and OrgName=@department)
				begin
					SELECT @RealOrgID=ID from Base_Organize where FatherID=@OrgID AND IsDel=0 and OrgName=@department
				end
				else
					set @RealOrgID=@OrgID
			END
			ELSE
			begin
				set @RealOrgID=@OrgID
				set @department=''
			end
			/*
			IF @RealOrgID=0
				set @RealOrgID=1 
			*/
			if CHARINDEX('(',@cn)>0 
			begin
				set @RealName = substring(@cn,0,CHARINDEX('(',@cn))
			end
			if CHARINDEX('（',@cn)>0 
			begin
				set @RealName = substring(@cn,0,CHARINDEX('（',@cn))
			end
			--插入人员数据,大于30个字被认为是AD的脏数据,不导入数据库。
			if len(@cn)<=30 and @RealOrgID>0
			BEGIN
				insert into Base_Employee(Account,name,Email,IsDel,UpdateTime,ObjectGUID) 
				values(@sAMAccountName ,@RealName ,@mail ,0,getdate(),@objectGUID)
			    insert into Base_OrganizeEmployee (EmployID,OrganizeID,State) values (@@IDENTITY,@RealOrgID,1)
			end
				
		END
		
	    fetch next from userlista into @sAMAccountName ,@cn ,@company,@department,@mail ,@objectGUID
	end
	drop table #TempUserList
	close userlista
	deallocate userlista

SET @ID=1
IF @@ERROR > 0
		BEGIN
			select @ID = -1 -- 操作失败
		END
END












