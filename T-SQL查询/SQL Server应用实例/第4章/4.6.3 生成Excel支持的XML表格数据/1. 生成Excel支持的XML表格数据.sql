DECLARE @template xml
SET @template = N'<?xml version="1.0"?>
<?mso-application progid="Excel.Sheet"?>
<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"
 xmlns:o="urn:schemas-microsoft-com:office:office"
 xmlns:x="urn:schemas-microsoft-com:office:excel"
 xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
 xmlns:html="http://www.w3.org/TR/REC-html40">
	<DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">
		<Author>zj</Author>
		<LastAuthor>zj</LastAuthor>
		<Created>2007-03-19T08:00:14Z</Created>
		<Company>zjcxc</Company>
		<Version>11.8107</Version>
	</DocumentProperties>
	<ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">
		<WindowHeight>13590</WindowHeight>
		<WindowWidth>19200</WindowWidth>
		<WindowTopX>0</WindowTopX>
		<WindowTopY>285</WindowTopY>
		<ProtectStructure>False</ProtectStructure>
		<ProtectWindows>False</ProtectWindows>
	</ExcelWorkbook>
	<Styles>
		<Style ss:ID="Default" ss:Name="Normal">
			<Alignment ss:Vertical="Center"/>
			<Borders/>
			<Font ss:FontName="宋体" x:CharSet="134" ss:Size="12"/>
			<Interior/>
			<NumberFormat/>
			<Protection/>
		</Style>
		<Style ss:ID="s21">
			<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
			<Borders>
				<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
				<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
				<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
				<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
			</Borders>
			<Font ss:FontName="宋体" x:CharSet="134" ss:Size="12" ss:Color="#FF0000"/>
			<Interior ss:Color="#99CCFF" ss:Pattern="Solid"/>
		</Style>
		<Style ss:ID="s22">
			<Borders>
				<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
				<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
				<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
				<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
			</Borders>
		</Style>
	</Styles>
	<Worksheet ss:Name="Sheet1">
		<Table ss:ExpandedColumnCount="2" ss:ExpandedRowCount="1" x:FullColumns="1"
		 x:FullRows="1" ss:DefaultColumnWidth="54" ss:DefaultRowHeight="14.25" ss:FullColumns="1" ss:FullRows="1">
			<Column ss:Width="69.75"/>
			<Column ss:Width="143.25"/>
			<Row ss:AutoFitHeight="0">
				<Cell ss:StyleID="s21">
					<Data ss:Type="String">name</Data>
				</Cell>
				<Cell ss:StyleID="s21">
					<Data ss:Type="String">type</Data>
				</Cell>
			</Row>
		</Table>
		<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
			<Unsynced/>
			<Selected/>
			<DoNotDisplayGridlines/>
			<Panes>
				<Pane>
					<Number>3</Number>
					<ActiveRow>1</ActiveRow>
					<ActiveCol>1</ActiveCol>
				</Pane>
			</Panes>
			<ProtectObjects>False</ProtectObjects>
			<ProtectScenarios>False</ProtectScenarios>
		</WorksheetOptions>
	</Worksheet>
</Workbook>'

-- 检索数据行数
DECLARE 
	@ExpandedRowCount int
SELECT
	@ExpandedRowCount = COUNT(*)
FROM sys.tables

-- 查询生成的xml结果
DECLARE @re xml
;WITH 
XMLNAMESPACES(
	DEFAULT 'urn:schemas-microsoft-com:office:spreadsheet',
	'urn:schemas-microsoft-com:office:office' as o,
	'urn:schemas-microsoft-com:office:excel' as x,
	'urn:schemas-microsoft-com:office:spreadsheet' as ss,
	'http://www.w3.org/TR/REC-html40' as html
)
SELECT @re = (
SELECT
	[*] = @template.query('/Workbook/*[local-name()!="Worksheet"]'),
	[Worksheet/@ss:Name] = 'Sheet1',
	[Worksheet/Table/@ss:ExpandedColumnCount] = 2,
	[Worksheet/Table/@ss:ExpandedRowCount] = @ExpandedRowCount + 100,
	[Worksheet/Table/@ss:FullColumns] = 1,
	[Worksheet/Table/@ss:FullRows] = 1,
	[Worksheet/Table/@ss:DefaultColumnWidth] = 54,
	[Worksheet/Table/@ss:DefaultRowHeight] = 14.25,
	[Worksheet/Table] = @template.query('
			/Workbook/Worksheet/Table/Row[1]'),
	[Worksheet/Table] = (
			SELECT
				[@ss:AutoFitHeight] = 0,
				[Cell/@ss:StyleID] = 's22',
				[Cell/Data/@ss:Type] = 'String',
				[Cell/Data] = name,
				NULL,
				[Cell/@ss:StyleID] = 's22',
				[Cell/Data/@ss:Type] = 'String',
				[Cell/Data] = type
			FROM sys.tables
			FOR XML PATH('Row'), TYPE, ROOT('Table')
		).query('/Table/*'),
	[Worksheet] = @template.query('
			/Workbook/Worksheet/*[local-name()="WorksheetOptions"]')
FOR XML PATH('Workbook')
)
-- 添加指令
SET @re.modify('
insert <?mso-application progid="Excel.Sheet"?>
as first into /')

-- 需要注意的是:由于SQL Server 的 xml 类型不接受以 'xml' 开头的 XML 声明和处理指令
-- 故在写入这个XML结果到文件的时候, 应该手工在文件的最前面加上一行, 内容如下:
-- <?xml version="1.0"?>
-- 如果不加上此行, 则不是 Excel 支持的标准的 "xml 表格" 文件

-- 显示结果
SELECT @re
