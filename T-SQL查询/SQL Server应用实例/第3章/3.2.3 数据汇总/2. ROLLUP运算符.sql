-- 1. 简单的ROLLUP使用示例
;WITH
TB AS(
	SELECT Item = 'Table', Color = 'Blue', Quantity = 124 UNION ALL
	SELECT Item = 'Table', Color = 'Red', Quantity = 23 UNION ALL
	SELECT Item = 'Chair', Color = 'Blue', Quantity = 101 UNION ALL
	SELECT Item = 'Chair', Color = 'Red', Quantity = 34
)
SELECT 
	Item, Color,
	Quantity = SUM(Quantity)	
FROM TB
GROUP BY Item, Color
	WITH ROLLUP
GO

-- 2. GROUPING函数使用示例
;WITH
TB AS(
	SELECT Groups = 'a', Item = 'Table', Color = 'Blue', Quantity = 124 UNION ALL
	SELECT Groups = 'b', Item = 'Table', Color = 'Red', Quantity = 23 UNION ALL
	SELECT Groups = 'b', Item = 'Cup', Color = 'Green', Quantity = 35 UNION ALL
	SELECT Groups = 'a', Item = 'Chair', Color = 'Blue', Quantity = 101 UNION ALL
	SELECT Groups = 'a', Item = 'Chair', Color = 'Red', Quantity = 34
)
SELECT 
	Groups, Item, Color,
	Quantity = SUM(Quantity),
	Groups_flag = GROUPING(Groups),
	Item_flag = GROUPING(Item),
	Color_flag = GROUPING(Color)
FROM TB
GROUP BY Groups, Item, Color
	WITH ROLLUP
GO

-- 3. 使用GROUPING函数过滤,优化显示格式及排序
;WITH
TB AS(
	SELECT Groups = 'a', Item = 'Table', Color = 'Blue', Quantity = 124 UNION ALL
	SELECT Groups = 'b', Item = 'Table', Color = 'Red', Quantity = 23 UNION ALL
	SELECT Groups = 'b', Item = 'Cup', Color = 'Green', Quantity = 35 UNION ALL
	SELECT Groups = 'a', Item = 'Chair', Color = 'Blue', Quantity = 101 UNION ALL
	SELECT Groups = 'a', Item = 'Chair', Color = 'Red', Quantity = 34
)
SELECT
	Groups = CASE 
		WHEN GROUPING(Color) = 0 THEN Groups
		WHEN GROUPING(Groups) = 1 THEN '总计'
		ELSE '' END,
	Item = CASE 
		WHEN GROUPING(Color) = 0 THEN Item
		WHEN GROUPING(Item) = 1 AND GROUPING(Groups) = 0
			THEN Groups + ' 合计'
		ELSE '' END,
	Color=CASE 
		WHEN GROUPING(Color) = 0 THEN Color
		WHEN GROUPING(Color) = 1 AND GROUPING(Item) = 0
			THEN Item + ' 小计'
		ELSE '' END,
	Quantity=SUM(Quantity)
FROM TB
GROUP BY Groups, Item, Color 
	WITH ROLLUP
HAVING GROUPING(Item) = 0 OR GROUPING(Groups) = 1
GO
