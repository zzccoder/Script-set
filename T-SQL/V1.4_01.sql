BEGIN TRANSACTION

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE


PRINT 'Updating dbo.CR_Checked Table'


SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, QUOTED_IDENTIFIER, CONCAT_NULL_YIELDS_NULL ON


SET NUMERIC_ROUNDABORT OFF



IF @@ERROR <> 0
   IF @@TRANCOUNT = 1 ROLLBACK TRANSACTION


IF @@TRANCOUNT = 1
if not exists(
select 1 from sys.all_columns  c INNER JOIN sys.objects obj on c.object_id = obj.object_id
where c.name='PosCardNo' and obj.name='CR_Checked')

   ALTER TABLE [dbo].[CR_Checked]
      ADD [PosCardNo] [varchar] (20) COLLATE Chinese_PRC_CI_AS NULL


IF @@ERROR <> 0
   IF @@TRANCOUNT = 1 ROLLBACK TRANSACTION


IF @@TRANCOUNT = 1
if not exists(
select 1 from sys.all_columns  c INNER JOIN sys.objects obj on c.object_id = obj.object_id
where c.name='PosCode' and obj.name='CR_Checked')
   ALTER TABLE [dbo].[CR_Checked]
      ADD [PosCode] [varchar] (20) COLLATE Chinese_PRC_CI_AS NULL


IF @@ERROR <> 0
   IF @@TRANCOUNT = 1 ROLLBACK TRANSACTION


IF @@TRANCOUNT = 1
   IF NOT EXISTS(SELECT 1 FROM sys.indexes  WHERE  name='posttc_check')
   CREATE INDEX [posttc_check] ON [dbo].[CR_Checked] ([PosTTC], [GunNo])


IF @@ERROR <> 0
   IF @@TRANCOUNT = 1 ROLLBACK TRANSACTION


IF @@TRANCOUNT = 1
BEGIN
   PRINT 'dbo.CR_Checked Table Updated Successfully'
   COMMIT TRANSACTION
END ELSE
BEGIN
   PRINT 'Failed To Update dbo.CR_Checked Table'
END


--
-- Script To Update dbo.CR_Refueled Table In .\sqlexpress.SinopecGSMIS
-- Generated ���ڶ�, ���� 7, 2013, at 11:18 AM
--
-- Please backup .\sqlexpress.SinopecGSMIS before executing this script
--


BEGIN TRANSACTION

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE


PRINT 'Updating dbo.CR_Refueled Table'


SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, QUOTED_IDENTIFIER, CONCAT_NULL_YIELDS_NULL ON


SET NUMERIC_ROUNDABORT OFF



IF @@ERROR <> 0
   IF @@TRANCOUNT = 1 ROLLBACK TRANSACTION


IF @@TRANCOUNT = 1
IF NOT EXISTS(SELECT 1 FROM sys.indexes  WHERE  name='posttc')
   CREATE INDEX [posttc] ON [dbo].[CR_Refueled] ([POSTTC], [GunNo])


IF @@ERROR <> 0
   IF @@TRANCOUNT = 1 ROLLBACK TRANSACTION


IF @@TRANCOUNT = 1
BEGIN
   PRINT 'dbo.CR_Refueled Table Updated Successfully'
   COMMIT TRANSACTION
END ELSE
BEGIN
   PRINT 'Failed To Update dbo.CR_Refueled Table'
END


--
-- Script To Create dbo.S_PosInfo Table In .\sqlexpress.SinopecGSMIS
-- Generated ���ڶ�, ���� 7, 2013, at 11:18 AM
--
-- Please backup .\sqlexpress.SinopecGSMIS before executing this script
--


BEGIN TRANSACTION

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE


PRINT 'Creating dbo.S_PosInfo Table'


SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, QUOTED_IDENTIFIER, CONCAT_NULL_YIELDS_NULL ON


SET NUMERIC_ROUNDABORT OFF

IF NOT EXISTS(SELECT 1 FROM sys.objects WHERE name='S_PosInfo')
CREATE TABLE [dbo].[S_PosInfo] (
   [ID] [uniqueidentifier] NOT NULL,
   [PosCode] [varchar] (20) COLLATE Chinese_PRC_CI_AS NOT NULL,
   [PosName] [nvarchar] (20) COLLATE Chinese_PRC_CI_AS NULL
)


IF @@ERROR <> 0
   IF @@TRANCOUNT = 1 ROLLBACK TRANSACTION


IF @@TRANCOUNT = 1
IF NOT EXISTS (SELECT name FROM sysobjects WHERE name = N'PK_S_POSINFO')
   ALTER TABLE [dbo].[S_PosInfo] ADD CONSTRAINT [PK_S_POSINFO] PRIMARY KEY CLUSTERED ([ID])


IF @@ERROR <> 0
   IF @@TRANCOUNT = 1 ROLLBACK TRANSACTION


IF @@TRANCOUNT = 1
BEGIN
   PRINT 'dbo.S_PosInfo Table Added Successfully'
   COMMIT TRANSACTION
END ELSE
BEGIN
   PRINT 'Failed To Add dbo.S_PosInfo Table'
END


 

BEGIN TRANSACTION

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE


PRINT 'Updating dbo.usp_Create_RD_FundsSummary Procedure'


SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, QUOTED_IDENTIFIER, CONCAT_NULL_YIELDS_NULL ON


SET NUMERIC_ROUNDABORT OFF



exec('ALTER PROCEDURE [dbo].[usp_Create_RD_FundsSummary]
	@WorkDay SMALLDATETIME
AS
BEGIN

	SET NOCOUNT ON;

	--DECLARE @WorkDay SMALLDATETIME
	--set @WorkDay=''2012-5-31''

	DECLARE @ReportId uniqueidentifier
	set @ReportId=newid()


	DECLARE @Sale_CashTotal NUMERIC(19,2)
	DECLARE @Sale_LubeTotal NUMERIC(19,2)
	DECLARE @Sale_ICTotal NUMERIC(19,2)

	DECLARE @Cash_Total NUMERIC(19,2)
	DECLARE @Cash_Lube NUMERIC(19,2)

	DECLARE @InitalArrears NUMERIC(19,2)
	DECLARE @Should_Total NUMERIC(19,2)
	DECLARE @Should_Cash NUMERIC(19,2)
	DECLARE @Should_Receivables NUMERIC(19,2)
	DECLARE @Should_Deposit NUMERIC(19,2)
	DECLARE @Should_DepositIncome NUMERIC(19,2)
	DECLARE @Should_Pos NUMERIC(19,2)

	DECLARE @Actual_Cash NUMERIC(19,2)
	DECLARE @Actual_Check NUMERIC(19,2)
	DECLARE @Actual_Deposit NUMERIC(19,2)
	DECLARE @Actual_Transfer NUMERIC(19,2)
	DECLARE @Actual_Pos NUMERIC(19,2)
	DECLARE @Actual_Total NUMERIC(19,2)
	DECLARE @Actual_Takeback NUMERIC(19,2)
	DECLARE @AccumulativeArrears NUMERIC(19,2)


	declare @Actual_Pledge  NUMERIC(19,2)




		--��������-�ֽ𼰼������۽��(�ֽ�Ӧ�տ�ͣ�Ԥ�տ�ͣ�POS����������)
	select @Sale_CashTotal=SUM(Amount)
	from cr_checked
	where checkmode =2 and WorkDay=@WorkDay and IsCancelled=0

	--��������-�������۽��
	select @Sale_LubeTotal=SUM(Amount)
	from LB_LubeSale
	where WorkDay=@WorkDay and IsCancelled=0

	--��������-IC��ˢ�����
	select @Sale_ICTotal=SUM(Amount)
	from cr_checked
	where checkmode=1 and WorkDay=@WorkDay and IsCancelled=0

	--�ֽ�����-�ֽ𼰼������۽��
	select @Cash_Total= SUM(amount) from CR_Checked where CheckMode=2 and WorkDay=@WorkDay and IsCancelled=0

	--�ֽ�����-�������۽��С��
	select @Cash_Lube= SUM(amount) from LB_LubeSale where WorkDay=@WorkDay and  CheckMode=2 and IsCancelled=0

    --���һ���ս�ʱ��
    declare @lastworkday datetime
    select @lastworkday = MAX(workday) from ho_daily where workday<@WorkDay
	--�����ۼ�Ƿ�����
	select @InitalArrears= AccumulativeArrears from RD_FundsSummary where workday=@lastworkday

	/* Ӧ�����(���͡�����) */

	--Ӧ��-�����ֽ����۽��	=(�ֽ�����.�ֽ𼰼������۽��)+(�ֽ�����.�������۽��С��)
	set @Should_Cash = ISNULL(@Cash_Total,0) + ISNULL(@Cash_Lube,0)

	--Ӧ��-����Ӧ�տ��
	select @Should_Receivables=SUM(Amount)
	from cr_checked
	where checkmode=6 and WorkDay=@WorkDay and IsCancelled=0

	--Ӧ��-Ԥ�տ��
	select @Should_Deposit=SUM(Amount)
	from cr_checked
	where checkmode=7 and WorkDay=@WorkDay and IsCancelled=0
	
	--Ӧ��-Ԥ�տ�����
	select @Should_DepositIncome= SUM(a.Amount) FROM dbo.CL_Payment a JOIN dbo.CL_Customer b
ON a.CustomerCode=b.CustomerCode WHERE a.WorkDay=@WorkDay AND b.CustomerType=1 AND a.IsCancelled=0

	select @Should_Pos = SUM(Amount) from cr_checked where checkmode=3 and WorkDay=@WorkDay and IsCancelled=0

	--Ӧ��-С��=(Ӧ��.�����ֽ����۽��)+ Ӧ��Ӧ�տ��+;Ӧ��Ԥ�տ��+Ԥ�տ�����+POS
	set @Should_Total = isnull(@Should_Cash,0) + isnull(@Should_Deposit,0) + ISNULL(@Should_Receivables,0)+ISNULL(@Should_DepositIncome,0)+ isnull(@Should_Pos,0)
	

	/* ʵ�����(���͡�����) */
	--ʵ��-�ֽ�=(Ӧ��.�����ֽ����۽��)+(Ӧ��.Ԥ�տ�����)
	select @Actual_Cash =  sum(amount) from CN_CoinRec where  WorkDay=@WorkDay and  IsCancel =0 and CoinType=1

	--ʵ��-֧Ʊ
	select @Actual_Check = SUM(amount) from CL_Payment where TypeID=2 and WorkDay=@WorkDay and IsCancelled=0
	
	DECLARE @temp NUMERIC(19,2)
	SELECT @temp = SUM(amount) FROM dbo.HO_Turnover WHERE IsCancel=0 AND WorkDay=@WorkDay AND PayType=4 AND SellItem=1
   
     SET @Actual_Check=ISNULL(@Actual_Check,0)+ISNULL(@temp,0)	

	--ʵ��-Ѻ����Ϳ�
	select @Actual_Pledge = 0
	
	--ʵ��-Ԥ�տ���Ϳ�
	select @Actual_Deposit = @Should_Deposit

	--ʵ��-��˾ת��
	select @Actual_Transfer=SUM(Amount) from cl_payment where typeid=1 and WorkDay=@WorkDay and IsCancelled=0
	
	SELECT @temp = SUM(amount) FROM dbo.HO_Turnover WHERE IsCancel=0 AND WorkDay=@WorkDay AND PayType=3 AND SellItem=1
	SET @Actual_Transfer = ISNULL(@Actual_Transfer,0)+ISNULL(@temp,0)
 

	--ʵ��-POS��=Ӧ��-POS��+���˿ͻ�POS
	select @Actual_Pos= SUM(amount) FROM cl_payment WHERE typeid=4 AND workday=@workDay AND IsCancelled=0
	
	SELECT @temp = SUM(amount) FROM dbo.HO_Turnover WHERE IsCancel=0 AND WorkDay=@WorkDay AND PayType=2 AND SellItem=1
 
	SET @Actual_Pos = ISNULL(@Actual_Pos,0)+ ISNULL(@Should_Pos,0)+ISNULL(@temp,0)

	--ʵ��-�����ջص�Ӧ�տ�
	select @Actual_Takeback=SUM(a.Amount) FROM dbo.CL_Payment a JOIN dbo.CL_Customer b
ON a.CustomerCode=b.CustomerCode WHERE a.WorkDay=@WorkDay AND b.CustomerType=2 AND a.IsCancelled=0

	--ʵ��-С��=(ʵ��-�ֽ�)+(ʵ��-֧Ʊ)+Ԥ�տ���Ϳ�+(ʵ��-��˾ת��)+(ʵ��-POS��)
	set @Actual_Total= + ISNULL(@Actual_Cash,0) + ISNULL(@Actual_Check,0) + ISNULL(@Actual_Deposit,0)+ISNULL(@Actual_Transfer,0) + ISNULL(@Actual_Pos,0)

	--�ۼ�Ƿ�����
	set @AccumulativeArrears=ISNULL(@InitalArrears,0)+@Should_Total-@Actual_Total
	
	delete from RD_FundsSummary where WorkDay=@WorkDay

	-- ����
	INSERT INTO [RD_FundsSummary]
			([ReportID], [WorkDay]
           ,[Sale_CashTotal], [Sale_LubeTotal], [Sale_ICTotal]
           ,[Cash_Total], [Cash_Lube]
           ,[InitalArrears]
           ,[Should_Total], [Should_Cash], [Should_Receivables], [Should_Deposit], [Should_DepositIncome], [Should_Pos]
           ,[Actual_Cash], [Actual_Check],Actual_Pledge, [Actual_Deposit], [Actual_Transfer], [Actual_Pos], [Actual_Total], [Actual_Takeback]
           ,[AccumulativeArrears])
	VALUES
			(@ReportID, @WorkDay
           , @Sale_CashTotal, @Sale_LubeTotal, @Sale_ICTotal
           , @Cash_Total, @Cash_Lube
           , @InitalArrears
           , @Should_Total, @Should_Cash, @Should_Receivables, @Should_Deposit, @should_DepositIncome, @Should_Pos
           , @Actual_Cash, @Actual_Check, @Actual_Pledge, @Actual_Deposit, @Actual_Transfer, @Actual_Pos, @Actual_Total, @Actual_Takeback
           , @AccumulativeArrears)

END')


IF @@ERROR <> 0
   IF @@TRANCOUNT = 1 ROLLBACK TRANSACTION


IF @@TRANCOUNT = 1
BEGIN
   PRINT 'dbo.usp_Create_RD_FundsSummary Procedure Updated Successfully'
   COMMIT TRANSACTION
END ELSE
BEGIN
   PRINT 'Failed To Update dbo.usp_Create_RD_FundsSummary Procedure'
END

update st_param set paramvalue=1 where id=14

