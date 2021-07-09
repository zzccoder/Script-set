USE tempdb
GO

-- ���� xml schema collection 
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

-- �� xml schema collection ������µ�XML�ܹ�
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

-- �������ͻ��� xml ����
DECLARE @test xml(xsc_Info)
SET @test = '<x:Employee xmlns:x="http://XMLSchema/EmployeeInfo" >
	<Name>aa</Name>
	<Sex>M</Sex>	
</x:Employee>
'

-- ��ͼΪ���ͻ��� xml �������費���� xml �ܹ����������
SET @test = '<x:Employee xmlns:x="http://XMLSchema/EmployeeInfo" >
	<Name>aa</Name>
</x:Employee>
'
GO

-- ɾ��ʾ��
IF EXISTS(
		SELECT * FROM sys.xml_schema_collections
		WHERE name = N'xsc_Info')
	DROP XML SCHEMA COLLECTION xsc_Info
