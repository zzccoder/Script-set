Imports Microsoft.SqlServer.Management.Smo
Imports Microsoft.SqlServer.Management.Common
Imports System.Text

Module ScriptProcess
    Sub Main()
        'Ĭ�����ӵ���ǰ�������ϵ�Ĭ��ʵ��
        Dim iServer As New Server()
        '���� AdventureWorks ��ı� dbo.ErrorLog �Ľű�
        Console.WriteLine(Script(iServer, "AdventureWorks.dbo.ErrorLog"))
        '���� AdventureWorks ��Ĺ��� Production �Ľű�
        Console.WriteLine(Script(iServer, "AdventureWorks..Production"))
        '���� AdventureWorks ����û� dbo �Ľű�
        Console.WriteLine(Script(iServer, "AdventureWorks..dbo"))
        Console.WriteLine("�����������")
        Console.ReadKey()
    End Sub

    '����ָ���Ķ����������ɽű�, ��������Ϊ����������: ����.������.������
    Private Function Script( _
            ByVal sServer As Server, _
            ByVal sObjectName As String _
            ) As String

        Dim iRe As New StringBuilder
        '����ű�����
        Dim iScript As New Scripter(sServer)
        '���� ScriptingOptions ���Ե�����, ָ�������ɵĽű��а���˵���Ա���. ScriptingOptions �����ǳ���Ľű����ɿ���ѡ��,���Ը�����Ҫ����
        iScript.Options.IncludeHeaders = True

        '���ɽű�, �������Ϣʹ�� UrnCollection, ͨ�� ObjectNameToUrn ��������
        For Each iStr As String In iScript.Script(ObjectNameToUrn(sServer, sObjectName))
            iRe.Append(iStr)
            iRe.Append(vbCrLf)
            iRe.Append("GO")
            iRe.Append(vbCrLf)
        Next
        Return iRe.ToString()
    End Function

    'ȡ�÷��϶������Ƶ����ж���� UrnCollection
    Private Function ObjectNameToUrn( _
            ByVal sServer As Server, _
            ByVal sObjectName As String _
            ) As UrnCollection

        '�ֽ���������еĸ�������
        Dim iObjects() As String = String.Format("..{0}", sObjectName).Split(".".ToCharArray)
        Array.Reverse(iObjects)
        Dim iObjecName As String = iObjects(0)
        Dim iSchema As String = iObjects(1)
        Dim iDatabase As String = iObjects(2)
        If String.IsNullOrEmpty(iDatabase) = True Then
            iDatabase = "master"
        End If

        'ȡ�ö���� Urn
        Dim iRe As New UrnCollection
        With sServer.Databases(iDatabase).EnumObjects(DatabaseObjectTypes.All)
            Dim iRowFilter As String = String.Format("Name='{0}'", iObjecName)
            If String.IsNullOrEmpty(iSchema) = False Then
                iRowFilter = String.Format("{0} and Schema='{1}'", iRowFilter, iSchema)
            End If
            .DefaultView.RowFilter = iRowFilter

            For Each iRow As DataRow In .DefaultView.ToTable().Rows
                iRe.Add(iRow("Urn").ToString)
            Next
        End With
        Return iRe
    End Function
End Module
