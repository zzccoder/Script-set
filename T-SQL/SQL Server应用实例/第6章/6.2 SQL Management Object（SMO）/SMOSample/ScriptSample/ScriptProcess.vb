Imports Microsoft.SqlServer.Management.Smo
Imports Microsoft.SqlServer.Management.Common
Imports System.Text

Module ScriptProcess
    Sub Main()
        '默认连接到当前服务器上的默认实例
        Dim iServer As New Server()
        '生成 AdventureWorks 库的表 dbo.ErrorLog 的脚本
        Console.WriteLine(Script(iServer, "AdventureWorks.dbo.ErrorLog"))
        '生成 AdventureWorks 库的构架 Production 的脚本
        Console.WriteLine(Script(iServer, "AdventureWorks..Production"))
        '生成 AdventureWorks 库的用户 dbo 的脚本
        Console.WriteLine(Script(iServer, "AdventureWorks..dbo"))
        Console.WriteLine("按任意键继续")
        Console.ReadKey()
    End Sub

    '根据指定的对象名称生成脚本, 对象名称为三部分名称: 库名.构架名.对象名
    Private Function Script( _
            ByVal sServer As Server, _
            ByVal sObjectName As String _
            ) As String

        Dim iRe As New StringBuilder
        '定义脚本对象
        Dim iScript As New Scripter(sServer)
        '对象 ScriptingOptions 属性的设置, 指定在生成的脚本中包含说明性标题. ScriptingOptions 包含非常多的脚本生成控制选项,可以根据需要设置
        iScript.Options.IncludeHeaders = True

        '生成脚本, 对象的信息使用 UrnCollection, 通过 ObjectNameToUrn 方法生成
        For Each iStr As String In iScript.Script(ObjectNameToUrn(sServer, sObjectName))
            iRe.Append(iStr)
            iRe.Append(vbCrLf)
            iRe.Append("GO")
            iRe.Append(vbCrLf)
        Next
        Return iRe.ToString()
    End Function

    '取得符合对象名称的所有对象的 UrnCollection
    Private Function ObjectNameToUrn( _
            ByVal sServer As Server, _
            ByVal sObjectName As String _
            ) As UrnCollection

        '分解对象名称中的各个部分
        Dim iObjects() As String = String.Format("..{0}", sObjectName).Split(".".ToCharArray)
        Array.Reverse(iObjects)
        Dim iObjecName As String = iObjects(0)
        Dim iSchema As String = iObjects(1)
        Dim iDatabase As String = iObjects(2)
        If String.IsNullOrEmpty(iDatabase) = True Then
            iDatabase = "master"
        End If

        '取得对象的 Urn
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
