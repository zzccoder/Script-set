--第一步：[RM_TankDetail]  安灌分类
/****** Script for SelectTopNRows command from SSMS  ******/
use SinopecGSMIS
DECLARE @Date datetime --日期
DECLARE @Num int--灌号
set @Num=3
set @date='2012-11-01'
SELECT TOP 1000 [BlockID]
       ,[WorkDay]
      ,[TankNo] 
      ,[YesReserve_Stock] as 上日帐存
      ,Im_Van_Volume as 应发升数
      ,TodayPayout as 本日付出
      ,[Reserve_Stock]  as 本日帐存
     ,[Actual_OilLitre]as 实测帐存
  FROM [SinopecGSMIS].[dbo].[RM_TankDetail] where tankno=@Num
  and WorkDay>DATEADD(DAY,-2,@Date) order by WorkDay
  
use SinopecGSMIS
DECLARE @Date datetime --日期
DECLARE @Num int--灌号
set @Num=3
set @date='2012-11-04'
update [SinopecGSMIS].[dbo].[RM_TankDetail]set [YesReserve_Stock]=
(select Reserve_Stock from [SinopecGSMIS].[dbo].[RM_TankDetail] where 
 tankno =@Num and WorkDay=DATEADD(DAY,-1,@Date))
where tankno =@Num and WorkDay=@Date
UPDATE  [SinopecGSMIS].[dbo].[RM_TankDetail]set [Reserve_Stock]=YesReserve_Stock+isnull(Im_Van_Volume,0)-TodayPayout
where tankno =@Num and WorkDay=@Date

--第二步：RD_OilBiz 按油品分类
use SinopecGSMIS
DECLARE @Date datetime --日期
DECLARE @Temp numeric
DECLARE @gas_cod varchar
set @date='2012-11-01'
set @gas_cod='60090935'

select workday,gascode,sum(YesReserve_Stock),sum(Reserve_Stock),sum(Actual_OilLitre) from RM_TankDetail
 where workday>=@Date
group by GasCode,workday
order by WorkDay
select WorkDay,GasCode,YesterdayReserves,TodayReserves,ActualReserves from RD_OilBiz 
where WorkDay>=@Date
order by WorkDay

use SinopecGSMIS
DECLARE @Date datetime --日期
DECLARE @Temp numeric
DECLARE @gas_cod varchar(20)
set @date='2012-11-01'
set @gas_cod='60090935'

--update RD_OilBiz  set YesterdayReserves=(YesterdayReserves+2094.48) where WorkDay=@Date and GasCode=@gas_cod
--update RD_OilBiz  set TodayReserves=(TodayReserves+2094.48) where WorkDay=@Date and GasCode=@gas_cod

--第三步：[RD_TempLastWorkday]  datatype=1 最近日结 datatype=2最近盘点
use SinopecGSMIS
DECLARE @Date datetime --日期
DECLARE @Temp numeric
DECLARE @gas_cod varchar
set @date='2012-11-01'
set @gas_cod='60090935'
SELECT 
      [DataType]
      ,[WorkDay]
      ,[TankNo]
      ,[GasCode]
      ,[Reserves]
      ,[TotalProfitLoss]
  FROM [SinopecGSMIS].[dbo].[RD_TempLastWorkday] where DataType=1 and WorkDay>=@Date and TankNo=3
  
select TankNo,workday,gascode, sum(YesReserve_Stock) ,sum(Reserve_Stock),sum(Actual_OilLitre)from RM_TankDetail
where workday>=@Date  and TankNo=3
group by GasCode,workday,TankNo
order by WorkDay

--update RD_TempLastWorkday set Reserves=19914.91 where TankNo=3 and WorkDay='2012-11-04' and GasCode='60090935'