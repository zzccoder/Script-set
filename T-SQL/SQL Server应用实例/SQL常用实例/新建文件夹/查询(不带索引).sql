USE [Books]
GO
/****** Object:  StoredProcedure [dbo].[SelSignUp]    Script Date: 11/08/2012 08:58:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE  [dbo].[SelSignUp]
@name varchar(20)
as
begin
select * from SignDown where name=@name
end
