USE [SinopecGSMIS]
GO

IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='workday')
 DROP INDEX dbo.CR_Checked.workday
/****** Object:  Index [workday]    Script Date: 2013/7/19 10:23:13 ******/
CREATE NONCLUSTERED INDEX [workday] ON [dbo].[CR_Checked]
(
	[WorkDay] ASC,
	[Shift] ASC,
	[GunNo] ASC,
	[PosTTC] ASC
)
INCLUDE ( 	[VolTotal]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

