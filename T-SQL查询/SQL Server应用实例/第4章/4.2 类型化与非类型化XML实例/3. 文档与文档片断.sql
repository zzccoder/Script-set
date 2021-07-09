USE tempdb
GO

-- 定义 xml schema collection 
CREATE XML SCHEMA COLLECTION dbo.xsc_Info
AS '<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema"
  targetNamespace="http://XMLSchema/Common">
  <xs:group name="PersonInfo">
    <xs:sequence>
      <xs:element name="Name" type="xs:string" />
      <xs:element name="Sex" type="xs:string" />
      <xs:element name="BirthDay" type="xs:date" minOccurs="0" />
    </xs:sequence>
  </xs:group>
  <xs:group name="ConnectInfo">
    <xs:sequence>
      <xs:element name="Phone" type="xs:string" minOccurs="0" />
      <xs:element name="Mobile" type="xs:string" minOccurs="0" />
      <xs:element name="Mail" type="xs:string" minOccurs="0" />
      <xs:element name="Address" type="xs:string" minOccurs="0" />
    </xs:sequence>
  </xs:group>
</xs:schema>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema"
  targetNamespace="http://XMLSchema/EmployeeInfo" xmlns:ns="http://XMLSchema/Common">
  <xs:import namespace="http://XMLSchemaCommon" />
  <xs:element name="Employee">
    <xs:complexType>
      <xs:sequence>
        <xs:group ref="ns:PersonInfo"/>
        <xs:group ref="ns:ConnectInfo"/>
      </xs:sequence>
    </xs:complexType>
  </xs:element>
</xs:schema>
'
GO

-- 在 xml schema collection 中添加新的XML架构
ALTER XML SCHEMA COLLECTION dbo.xsc_Info
ADD '<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema"
  targetNamespace="http://XMLSchema/CompanyInfo" xmlns:ns="http://XMLSchema/Common">
  <xs:import namespace="http://XMLSchema/Common" />
  <xs:element name="Company">
    <xs:complexType>
      <xs:sequence>
		<xs:element name="Name" type="xs:string" />
        <xs:group ref="ns:ConnectInfo"/>
      </xs:sequence>
    </xs:complexType>
  </xs:element>
</xs:schema>
'
GO

-- 1. DOCUMENT 标志
DECLARE @test xml(DOCUMENT xsc_Info)
--DECLARE @test xml(CONTENT xsc_Info)
-- 同时在变量中存储 Employee 和 Company 信息, 当指定 DOCUMENT 标志时, 存储失败
SET @test = '<x:Employee xmlns:x="http://XMLSchema/EmployeeInfo" >
	<Name>张三</Name>
	<Sex>M</Sex>	
</x:Employee>
<x:Company xmlns:x="http://XMLSchema/CompanyInfo" >
	<Name>新公司</Name>
</x:Company>
'
GO

-- 2. CONTENT 标志
--DECLARE @test xml(DOCUMENT xsc_Info)
DECLARE @test xml(CONTENT xsc_Info)
-- 同时在变量中存储 Employee 和 Company 信息, 当指定 DOCUMENT 标志时, 存储失败
SET @test = '<x:Employee xmlns:x="http://XMLSchema/EmployeeInfo" >
	<Name>张三</Name>
	<Sex>M</Sex>	
</x:Employee>
<x:Company xmlns:x="http://XMLSchema/CompanyInfo" >
	<Name>新公司</Name>
</x:Company>
'
GO

-- 删除示例
IF EXISTS(
		SELECT * FROM sys.xml_schema_collections
		WHERE name = N'xsc_Info')
	DROP XML SCHEMA COLLECTION xsc_Info
