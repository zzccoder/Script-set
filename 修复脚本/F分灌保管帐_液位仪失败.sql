use SinopecGSMIS

--update RM_TankDetail set  Reserve_Stock=9004.78 where WorkDay='2012-11-01' and TankNo =4
select WorkDay,TankNo,YesReserve_Stock,TodayPayout,Reserve_Stock,Actual_Reserves  from RM_TankDetail where WorkDay>='2012-10-30' and TankNo =4  order by WorkDay



use SinopecGSMIS

--update RM_TankDetail set YesReserve_Stock = Reserve_Stock+TodayPayout where WorkDay='2012-11-01' and TankNo =4
select WorkDay,TankNo,YesReserve_Stock,TodayPayout,Reserve_Stock,Actual_Reserves  from RM_TankDetail where WorkDay>='2012-10-30' and TankNo =4 order by WorkDay
