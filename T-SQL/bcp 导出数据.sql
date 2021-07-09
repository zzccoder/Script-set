EXEC sp_configure 'show advanced options', 1

GO

RECONFIGURE

GO

EXEC sp_configure 'xp_cmdshell', 1

GO

RECONFIGURE

GO

EXEC userinfo..xp_cmdshell 'bcp userinfo.dbo.students out D:studentes.txt -c -T -U''sa'' -P''123456'''

EXEC userinfo..xp_cmdshell 'bcp userinfo.dbo.students in D:studentes.txt -c -T -U''sa'' -P''123456'''

EXEC sp_configure 'show advanced options', 1

GO

RECONFIGURE

GO

EXEC sp_configure 'xp_cmdshell', 0

GO

RECONFIGURE

GO