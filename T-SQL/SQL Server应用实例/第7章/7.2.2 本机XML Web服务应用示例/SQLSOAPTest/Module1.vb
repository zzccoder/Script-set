Module Module1
    Sub Main()
        Console.WriteLine("1. ���� sp_who ��������")
        sp_who()
        Console.WriteLine("�����������")
        Console.ReadKey()

        Console.WriteLine("2.a ���� sqlbatch ����ִ�� T-SQL���")
        sqlbatch("SELECT ServerName = @@SERVERNAME, Version = @@VERSION", Nothing)
        Console.WriteLine("�����������")
        Console.ReadKey()

        Console.WriteLine("2.b ���� sqlbatch ����ִ�з�����Ϣ�����")
        sqlbatch("RAISERROR(N'��Ϣ����')", Nothing)
        Console.WriteLine("�����������")
        Console.ReadKey()

        Console.WriteLine("2.c ���� sqlbatch ����ִ�д������� T-SQL���")
        Dim iSQL As String = "SELECT name, database_id FROM sys.databases WHERE recovery_model = @recovery_model"
        Dim iPara(0) As SOAP_Test.SqlParameter
        iPara(0) = New SOAP_Test.SqlParameter()
        With iPara(0)
            .name = "recovery_model"
            .sqlDbType = SOAP_Test.sqlDbTypeEnum.TinyInt
            .Value = 1
        End With
        sqlbatch(iSQL, iPara)
        Console.WriteLine("�����������")
        Console.ReadKey()
    End Sub

    '�ṩ�Զ�����û���¼ƾ��
    Private Function UserDefineCredentials() As Net.NetworkCredential
        Return New Net.NetworkCredential("SQLTest", "SQLTest.Password")
    End Function

    '���� XML Web �������, �����úõ�½ƾ��
    Private Function SOAPTestSrv() As SOAP_Test.SOAP_test
        Dim iSrv As New SOAP_Test.SOAP_test
        'ʹ��Ĭ�ϵĵ�½ƾ��, ���Ҫʹ���û�����ĵ�½ƾ��,������ Credentials ����ֵΪָ�����û�ƾ��
        iSrv.UseDefaultCredentials = True
        'iSrv.Credentials = UserDefineCredentials()
        Return iSrv
    End Function

    ''' <summary>
    ''' ��Console����ʾDataSet�е�����
    ''' </summary>
    ''' <param name="sDataSet">Ҫ��ʾ��DataSet</param>
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

    '���� Web ����ķ��� sp_who
    Private Sub sp_who()
        Using iSrv As SOAP_Test.SOAP_test = SOAPTestSrv()
            Using iRe As DataSet = iSrv.sp_who(String.Empty)
                ShowDataSet(iRe)
            End Using
        End Using
    End Sub

    '���� Web ����� sqlbatch ����
    Private Sub sqlbatch(ByVal sSQL As String, ByVal sSQLParameters() As SOAP_Test.SqlParameter)
        Using iSrv As SOAP_Test.SOAP_test = SOAPTestSrv()
            Dim iRes As Array = iSrv.sqlbatch(sSQL, sSQLParameters)
            For Each iRe As Object In iRes
                If TypeOf iRe Is DataSet Then
                    ShowDataSet(CType(iRe, DataSet))
                ElseIf TypeOf iRe Is SOAP_Test.SqlRowCount Then
                    Console.WriteLine("({0} ����Ӱ��)", CType(iRe, SOAP_Test.SqlRowCount).Count)
                ElseIf TypeOf iRe Is SOAP_Test.SqlMessage Then
                    Dim iMsg As SOAP_Test.SqlMessage = CType(iRe, SOAP_Test.SqlMessage)
                    Console.WriteLine("���� {0}����Ϣ {1}������ {2}��״̬ {3}���� {4} ��{5}{6}", iMsg.Procedure, iMsg.Number, iMsg.Class, iMsg.State, iMsg.LineNumber, vbCrLf, iMsg.Message)
                End If
            Next
        End Using
    End Sub
End Module
