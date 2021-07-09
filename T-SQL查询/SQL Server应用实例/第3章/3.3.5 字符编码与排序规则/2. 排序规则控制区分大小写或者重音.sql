-- 使用排序规则控制比较是否区分大小写和重音
SELECT
	[区分大小写] = CASE
			WHEN 'a' COLLATE Chinese_PRC_90_CS_AS = 'A'
				THEN 1
			ELSE 0 END,
	[区分全角与半角] = CASE
			WHEN 'a' COLLATE Chinese_PRC_90_CI_AS = 'Ａ'
				THEN 1
			ELSE 0 END,
	[不区全角与半角] = CASE
			WHEN 'a' COLLATE Chinese_PRC_90_CI_AS_WS = 'Ａ'
				THEN 1
			ELSE 0 END
GO

-- 查询有效排序规则
SELECT *
FROM ::fn_helpcollations()
