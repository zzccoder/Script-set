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

-- 定义类型化的 xml 变量
DECLARE @test xml(xsc_Info)
SET @test = '<x:Employee xmlns:x="http://XMLSchema/EmployeeInfo" >
	<Name>aa</Name>
	<Sex>M</Sex>	
</x:Employee>
'

-- 试图为类型化的 xml 变量赋予不符合 xml 架构定义的数据
SET @test = '<x:Employee xmlns:x="http://XMLSchema/EmployeeInfo" >
	<Name>aa</Name>
</x:Employee>
'
GO

-- 删除示例
IF EXISTS(
		SELECT * FROM sys.xml_schema_collections
		WHERE name = N'xsc_Info')
	DROP XML SCHEMA COLLECTION xsc_Info
