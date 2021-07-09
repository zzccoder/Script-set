cr±í
ho±í


declare


use SinopecGSMIS

begin tran

DECLARE @setWrokDay datetime
DECLARE @setShift tinyint
DECLARE @currWorkDay datetime
DECLARE @currShift tinyint

set @setWrokDay = ''
set @setShift = 0
set @currWorkDay = ''
set @currShift = 0

update CR_Abandon set WorkDay = @setWrokDay, Shift = @setShift
where WorkDay = @currWorkDay and Shift = @currShift

update CR_Checked set WorkDay = @setWrokDay, Shift = @setShift
where WorkDay = @currWorkDay and Shift = @currShift

update CR_InvoiceRec set WorkDay = @setWrokDay, Shift = @setShift
where WorkDay = @currWorkDay and Shift = @currShift

update CR_Refueled set WorkDay = @setWrokDay, Shift = @setShift
where WorkDay = @currWorkDay and Shift = @currShift

update HO_CashierHandOver set WorkDay = @setWrokDay, Shift = @setShift
where WorkDay = @currWorkDay and Shift = @currShift

update HO_Daily set WorkDay = @setWrokDay
where WorkDay = @currWorkDay

update HO_PumpInfo set WorkDay = @setWrokDay, Shift = @setShift
where WorkDay = @currWorkDay and Shift = @currShift

update HO_Shift set WorkDay = @setWrokDay, Shift = @setShift
where WorkDay = @currWorkDay and Shift = @currShift

update HO_StaffCardBalance set WorkDay = @setWrokDay, Shift = @setShift
where WorkDay = @currWorkDay and Shift = @currShift

update HO_TankInfo set WorkDay = @setWrokDay, Shift = @setShift
where WorkDay = @currWorkDay and Shift = @currShift

commit tran



