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
	WITH CUBE
