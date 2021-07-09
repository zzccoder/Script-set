Imports System.Data.SqlClient
Imports System.Data.Sql

Module Module1
    Sub Main()
        '�������������
        MARSTest()

        'ö�� SQL Server ʵ������
        EnumSQLServerInstance()

        '�����޸Ĳ���
        Using GetConnection("sa", "12345")

        End Using

        Console.WriteLine("�����������...")
        Console.ReadKey()
    End Sub

    '���������
    Sub MARSTest()
        '�������ַ�����, ����ָ�� MultipleActiveResultSets=True
        Dim iConnString As String = "Data Source=.;Initial Catalog=tempdb;Integrated Security=SSPI;MultipleActiveResultSets=True"
        Using iConn As New SqlConnection(iConnString)
            Dim iSQL As String = "SELECT Test = 1"
            Using iCmd As New SqlCommand(iSQL, iConn)
                iConn.Open()
                With iCmd.ExecuteReader()
                    .Read()
                    Console.WriteLine("{0}: {1}", .GetName(0), .GetInt32(0))
                End With
            End Using

            iSQL = "SELECT Test = 2"
            Using iCmd As New SqlCommand(iSQL, iConn)
                '����һ���������δ�رյ������, �򿪵�2�������
                '��������ַ�����δ���� ;MultipleActiveResultSets=True, ���������ִ�л����
                With iCmd.ExecuteReader()
                    .Read()
                    Console.WriteLine("{0}: {1}", .GetName(0), .GetInt32(0))
                End With
            End Using
        End Using
    End Sub

    'ö�� SQL Server ʵ��
    Sub EnumSQLServerInstance()
        Using iInstances As DataTable = SqlDataSourceEnumerator.Instance.GetDataSources()
            For Each iRow As DataRow In iInstances.Rows
                For Each iCol As DataColumn In iInstances.Columns
                    Console.Write("{0} = {1}", iCol.ColumnName, iRow(iCol))
                Next
                Console.WriteLine()
            Next
        End Using
    End Sub

    '���� SQL Server 2005 ����
    Function GetConnection( _
            ByVal sLoginName As String, _
            ByVal sPassword As String _
            ) As SqlConnection

        Dim iConn As New SqlConnection()

        '���������ַ���
        Dim iConnStringBuilder As New SqlConnectionStringBuilder("Data Source=.;")
        With iConnStringBuilder
            .IntegratedSecurity = String.IsNullOrEmpty(sLoginName)
            .UserID = sLoginName
            .Password = sPassword
            iConn.ConnectionString = .ConnectionString
        End With

        Try
            '������
            iConn.Open()
        Catch sqlex As SqlException When (sqlex.Number = 18487 Or sqlex.Number = 18488)
            '����������� 18487(�����ѹ���) �� 18488(��¼ǰ�����������), ��ʾ��Ҫ��������
            Dim iPassword As String = InputBox("����������", String.Format("������ĵ�¼[{0}]������, ������������", sPassword))
            With iConnStringBuilder
                .Password = iPassword
                '��������
                SqlConnection.ChangePassword(iConn.ConnectionString, iPassword)
                iConn.ConnectionString = .ConnectionString
            End With
            Try
                iConn.Open()
            Catch ex As Exception
                Console.WriteLine(ex.Message)
            End Try
        Catch sqlex As SqlException
            Console.WriteLine(sqlex.Message)
        End Try

        Return iConn
    End Function
End Module
