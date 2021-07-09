Imports System.Data.SqlClient
Imports System.Data.Sql

Module Module1
    Sub Main()
        '多个活动结果集测试
        MARSTest()

        '枚举 SQL Server 实例测试
        EnumSQLServerInstance()

        '密码修改测试
        Using GetConnection("sa", "12345")

        End Using

        Console.WriteLine("按任意键继续...")
        Console.ReadKey()
    End Sub

    '多个活动结果集
    Sub MARSTest()
        '在连接字符串中, 必须指定 MultipleActiveResultSets=True
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
                '在上一个结果集并未关闭的情况下, 打开第2个结果集
                '如果连接字符串中未设置 ;MultipleActiveResultSets=True, 则下面这句执行会出错
                With iCmd.ExecuteReader()
                    .Read()
                    Console.WriteLine("{0}: {1}", .GetName(0), .GetInt32(0))
                End With
            End Using
        End Using
    End Sub

    '枚举 SQL Server 实例
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

    '更改 SQL Server 2005 密码
    Function GetConnection( _
            ByVal sLoginName As String, _
            ByVal sPassword As String _
            ) As SqlConnection

        Dim iConn As New SqlConnection()

        '生成连接字符串
        Dim iConnStringBuilder As New SqlConnectionStringBuilder("Data Source=.;")
        With iConnStringBuilder
            .IntegratedSecurity = String.IsNullOrEmpty(sLoginName)
            .UserID = sLoginName
            .Password = sPassword
            iConn.ConnectionString = .ConnectionString
        End With

        Try
            '打开连接
            iConn.Open()
        Catch sqlex As SqlException When (sqlex.Number = 18487 Or sqlex.Number = 18488)
            '如果错误编号是 18487(密码已过期) 或 18488(登录前必须更改密码), 表示需要更改密码
            Dim iPassword As String = InputBox("输入新密码", String.Format("必须更改登录[{0}]的密码, 请输入新密码", sPassword))
            With iConnStringBuilder
                .Password = iPassword
                '更改密码
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
