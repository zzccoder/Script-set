Module Module1
    Sub Main()
        Console.WriteLine("1. 调用 sp_who 方法测试")
        sp_who()
        Console.WriteLine("按任意键继续")
        Console.ReadKey()

        Console.WriteLine("2.a 调用 sqlbatch 方法执行 T-SQL语句")
        sqlbatch("SELECT ServerName = @@SERVERNAME, Version = @@VERSION", Nothing)
        Console.WriteLine("按任意键继续")
        Console.ReadKey()

        Console.WriteLine("2.b 调用 sqlbatch 方法执行返回消息的语句")
        sqlbatch("RAISERROR(N'消息测试')", Nothing)
        Console.WriteLine("按任意键继续")
        Console.ReadKey()

        Console.WriteLine("2.c 调用 sqlbatch 方法执行带参数的 T-SQL语句")
        Dim iSQL As String = "SELECT name, database_id FROM sys.databases WHERE recovery_model = @recovery_model"
        Dim iPara(0) As SOAP_Test.SqlParameter
        iPara(0) = New SOAP_Test.SqlParameter()
        With iPara(0)
            .name = "recovery_model"
            .sqlDbType = SOAP_Test.sqlDbTypeEnum.TinyInt
            .Value = 1
        End With
        sqlbatch(iSQL, iPara)
        Console.WriteLine("按任意键继续")
        Console.ReadKey()
    End Sub

    '提供自定义的用户登录凭据
    Private Function UserDefineCredentials() As Net.NetworkCredential
        Return New Net.NetworkCredential("SQLTest", "SQLTest.Password")
    End Function

    '建立 XML Web 服务对象, 并设置好登陆凭据
    Private Function SOAPTestSrv() As SOAP_Test.SOAP_test
        Dim iSrv As New SOAP_Test.SOAP_test
        '使用默认的登陆凭据, 如果要使用用户定义的登陆凭据,则设置 Credentials 属性值为指定的用户凭据
        iSrv.UseDefaultCredentials = True
        'iSrv.Credentials = UserDefineCredentials()
        Return iSrv
    End Function

    ''' <summary>
    ''' 在Console中显示DataSet中的内容
    ''' </summary>
    ''' <param name="sDataSet">要显示的DataSet</param>
    ''' <remarks></remarks>
    Private Sub ShowDataSet(ByVal sDataSet As DataSet)
        For Each iTb As DataTable In sDataSet.Tables
            If iTb Is Nothing Then
                Continue For
            End If
            Dim iLine As String = "---------------------------------------------------------------"
            Console.WriteLine(iLine)
            Console.WriteLine("Table:{0}", iTb.Namespace)
            Console.WriteLine(iLine)

            For Each iCol As DataColumn In iTb.Columns
                Console.Write("{0}{1}", iCol.ColumnName, vbTab)
            Next
            Console.WriteLine()
            Console.WriteLine(iLine)
            Dim iColCount As Integer = iTb.Columns.Count - 1
            For Each iRow As DataRow In iTb.Rows
                For iCol As Integer = 0 To iColCount
                    Console.Write("{0}{1}", iRow(iCol).ToString, vbTab)
                Next
                Console.WriteLine()
            Next
        Next
    End Sub

    '调用 Web 服务的方法 sp_who
    Private Sub sp_who()
        Using iSrv As SOAP_Test.SOAP_test = SOAPTestSrv()
            Using iRe As DataSet = iSrv.sp_who(String.Empty)
                ShowDataSet(iRe)
            End Using
        End Using
    End Sub

    '调用 Web 服务的 sqlbatch 方法
    Private Sub sqlbatch(ByVal sSQL As String, ByVal sSQLParameters() As SOAP_Test.SqlParameter)
        Using iSrv As SOAP_Test.SOAP_test = SOAPTestSrv()
            Dim iRes As Array = iSrv.sqlbatch(sSQL, sSQLParameters)
            For Each iRe As Object In iRes
                If TypeOf iRe Is DataSet Then
                    ShowDataSet(CType(iRe, DataSet))
                ElseIf TypeOf iRe Is SOAP_Test.SqlRowCount Then
                    Console.WriteLine("({0} 行受影响)", CType(iRe, SOAP_Test.SqlRowCount).Count)
                ElseIf TypeOf iRe Is SOAP_Test.SqlMessage Then
                    Dim iMsg As SOAP_Test.SqlMessage = CType(iRe, SOAP_Test.SqlMessage)
                    Console.WriteLine("过程 {0}，消息 {1}，级别 {2}，状态 {3}，第 {4} 行{5}{6}", iMsg.Procedure, iMsg.Number, iMsg.Class, iMsg.State, iMsg.LineNumber, vbCrLf, iMsg.Message)
                End If
            Next
        End Using
    End Sub
End Module
