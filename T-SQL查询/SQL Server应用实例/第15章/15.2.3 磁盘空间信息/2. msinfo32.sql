-- �� xp_cmdshell ѡ��
EXEC sp_configure 'show advanced options', 1
RECONFIGURE

EXEC sp_configure 'xp_cmdshell', 1
RECONFIGURE
GO

-- ʹ�� msinfo32 ��ѯ���̿ռ���Ϣ
DECLARE
	@temp_file nvarchar(250),
	@s nvarchar(4000)

-- ͨ�� msinfo32 ��������Ϣ�洢���ļ���
SELECT
	@temp_file = N'c:\'
		+ CONVERT(nvarchar(36), NEWID())
		+ N'.nfo',
	@s = N'start /wait msinfo32.exe /nfo '
		+ QUOTENAME(@temp_file, N'"')
		+ N' /categories +ComponentsStorage-ComponentsStorageDisks-ComponentsStorageSCSI-ComponentsStorageIDE'
EXEC master.dbo.xp_cmdshell @s, NO_OUTPUT

-- ���ļ��л�ȡ������Ϣ
DECLARE 
	@xml xml

SELECT
	@s = N'
SELECT
	@xml = CONVERT(xml, T.c)
FROM OPENROWSET(BULK N' + QUOTENAME(@temp_file, N'''')
	+ N', SINGLE_BLOB) T(c)'
EXEC sp_executesql @s, N'@xml xml OUTPUT', @xml OUTPUT

-- ɾ��������Ϣ�ļ�
SELECT
	@s = N'DEL ' 
		+ QUOTENAME(@temp_file, N'"')
EXEC master.dbo.xp_cmdshell @s, NO_OUTPUT

-- ��ʾ������Ϣ
SELECT
	Item = T.c.value(N'(��Ŀ)[1]', 'nvarchar(500)'),
	Value = T.c.value(N'(��ֵ)[1]', 'nvarchar(500)')
FROM @xml.nodes(N'/MsInfo
	/Category[@name="ϵͳժҪ"]
	/Category[@name="���"]
	/Category[@name="�洢"]
	/Category[@name="������"]
	/Data') T(c)