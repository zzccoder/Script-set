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

-- 1. �����ͻ�XMLʵ��(����)
-- �������ͻ��� xml ����
DECLARE @test xml(xsc_Info)
-- ͨ��ָ�������ռ� http://XMLSchema/EmployeeInfo , ָʾ�����д洢 Emplonee ��Ϣ
SET @test = '<x:Employee xmlns:x="http://XMLSchema/EmployeeInfo" >
	<Name>����</Name>
	<Sex>M</Sex>	
</x:Employee>
'

-- ͨ��ָ�������ռ� http://XMLSchema/CompanyInfo , ָʾ�����д洢 Company ��Ϣ
SET @test = '<x:Company xmlns:x="http://XMLSchema/CompanyInfo" >
	<Name>�¹�˾</Name>
</x:Company>
'
GO

-- 2. �����ͻ�XMLʵ��(��)
-- ����ʾ����
DECLARE @tb TABLE(
	col xml(xsc_Info))
-- ���������ͬ��Ϣ�ļ�¼
INSERT @tb(
	col)
-- Employee ��Ϣ
SELECT '<x:Employee xmlns:x="http://XMLSchema/EmployeeInfo" >
	<Name>����</Name>
	<Sex>M</Sex>	
</x:Employee>' UNION ALL
-- Company ��Ϣ
SELECT '<x:Company xmlns:x="http://XMLSchema/CompanyInfo" >
	<Name>�¹�˾</Name>
</x:Company>
'
GO

-- ɾ��ʾ��
IF EXISTS(
		SELECT * FROM sys.xml_schema_collections
		WHERE name = N'xsc_Info')
	DROP XML SCHEMA COLLECTION xsc_Info
