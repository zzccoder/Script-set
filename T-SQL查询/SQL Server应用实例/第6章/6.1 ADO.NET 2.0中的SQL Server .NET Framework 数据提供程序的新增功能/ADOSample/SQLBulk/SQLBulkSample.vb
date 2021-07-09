Imports System.Data.SqlClient
Imports System.Transactions

Module SQLBulkSample
    Private m_ConnStr As String = "Data Source=.;Initial Catalog=tempdb;Integrated Security=SSPI;"

    '建立批量复制测试所需要的目的表
    Public Sub InitTest( _
            ByVal sConn As SqlConnection)

        '构建批量复制的目的表
        Using iCmd As New SqlCommand()
            iCmd.Connection = sConn

            '建立bulk测试的目的表1
            iCmd.CommandText = "SELECT TOP 0 * INTO dbo.tb_bulk_test_objects FROM sys.objects"
            iCmd.ExecuteNonQuery()

            '建立bulk测试的目的表2
            iCmd.CommandText = "SELECT TOP 0 * INTO dbo.tb_bulk_test_columns FROM sys.columns"
            iCmd.ExecuteNonQuery()
        End Using
    End Sub

    '在每次处理完 NotifyAfter 属性指定的行数时发生
    Private Sub OnSqlRowsCopied(ByVal sender As Object, ByVal args As SqlRowsCopiedEventArgs)
        Console.WriteLine(String.Format("Copied {0} so fat...", args.RowsCopied.ToString()))
    End Sub

    ''' <summary>
    ''' 批量复制
    ''' </summary>
    ''' <param name="sConn">SqlConnection对象,数据源和目的表使用同一个连接</param>
    ''' <param name="sSourceSQL">查询复制数据源的 T-SQL 语句</param>
    ''' <param name="sDestinationTable">批量复制的目的表名</param>
    ''' <remarks></remarks>
    Private Sub Bulk( _
            ByVal sConn As SqlConnection, _
            ByVal sSourceSQL As String, _
            ByVal sDestinationTable As String)

        Using iCmd As New SqlCommand(sSourceSQL, sConn)
            Using iBcp As SqlBulkCopy = New SqlBulkCopy(sConn)
                iBcp.NotifyAfter = 5000            '每完成 5000 条记录通知
                iBcp.DestinationTableName = sDestinationTable
                AddHandler iBcp.SqlRowsCopied, AddressOf OnSqlRowsCopied
                Using iDataTable As New DataTable
                    '因为源和目的都使用同一个连接, 而同一连接不能同时打开源和目的对象, 所以需要把数据填充到 DataTable 中
                    iDataTable.Load(iCmd.ExecuteReader())
                    '复制数据到目的表中
                    iBcp.WriteToServer(iDataTable)
                End Using
                RemoveHandler iBcp.SqlRowsCopied, AddressOf OnSqlRowsCopied
            End Using
        End Using
    End Sub

    '使用事务控制多个批量复制操作的测试
    Public Sub BulkTest1()
        '通过 TransactionScope 对两个批量复制进行统一的事务控制
        Using iTs As New TransactionScope
            Using iConn As New SqlConnection(m_ConnStr)
                iConn.Open()

                '建立复制测试需要的目的表
                InitTest(iConn)

                Dim iDate As DateTime
                Dim iSQL As String
                '第1个批量复制
                iDate = Now
                Console.WriteLine(String.Format("{0} 开始第1个批量复制处理", iDate))
                iSQL = "SELECT O.* FROM sys.objects O, sys.columns C"
                Bulk(iConn, iSQL, "dbo.tb_bulk_test_objects")
                Console.WriteLine(String.Format("{0} 完成第1个批量复制处理", Now))

                '第2个批量复制
                iDate = Now
                Console.WriteLine(String.Format("{0} 开始第2个批量复制处理", iDate))
                iSQL = "SELECT C.* FROM sys.objects O, sys.columns C"
                Bulk(iConn, iSQL, "dbo.tb_bulk_test_columns")
                Console.WriteLine(String.Format("{0} 完成第2个批量复制处理", Now))
            End Using
            '测试不需要保留数据, 所以回滚事务
            iTs.Dispose()
        End Using
    End Sub

    '使用事务控制多次批量复制操作的测试
    Public Sub BulkTest2()
        '通过 TransactionScope 对两次批量复制进行统一的事务控制
        Using iTs As New TransactionScope
            Using iConn As New SqlConnection(m_ConnStr)
                iConn.Open()

                '建立复制测试需要的目的表
                InitTest(iConn)

                '多次批量复制操作
                Using iBcp As SqlBulkCopy = New SqlBulkCopy(iConn)
                    '设置批量复制操作的记录通知
                    iBcp.NotifyAfter = 5000            '每完成 5000 条记录通知
                    AddHandler iBcp.SqlRowsCopied, AddressOf OnSqlRowsCopied

                    Dim iDate As DateTime
                    Using iCmd As New SqlCommand()
                        iCmd.Connection = iConn

                        '第1个批量复制
                        iDate = Now
                        Console.WriteLine(String.Format("{0} 开始第 1 个批量复制处理", iDate))
                        iCmd.CommandText = "SELECT O.* FROM sys.objects O, sys.columns C"
                        iBcp.DestinationTableName = "dbo.tb_bulk_test_objects"
                        Using iDataTable As New DataTable
                            '因为源和目的都使用同一个连接, 而同一连接不能同时打开源和目的对象, 所以需要把数据填充到 DataTable 中
                            iDataTable.Load(iCmd.ExecuteReader())
                            '复制数据到目的表中
                            iBcp.WriteToServer(iDataTable)
                        End Using
                        Console.WriteLine(String.Format("{0} 完成第 1 个批量复制处理", Now))

                        '第2个批量复制
                        iDate = Now
                        Console.WriteLine(String.Format("{0} 开始第 2 个批量复制处理", iDate))
                        iCmd.CommandText = "SELECT C.* FROM sys.objects O, sys.columns C"
                        iBcp.DestinationTableName = "dbo.tb_bulk_test_columns"
                        Using iDataTable As New DataTable
                            '因为源和目的都使用同一个连接, 而同一连接不能同时打开源和目的对象, 所以需要把数据填充到 DataTable 中
                            iDataTable.Load(iCmd.ExecuteReader())
                            '复制数据到目的表中
                            iBcp.WriteToServer(iDataTable)
                        End Using
                        Console.WriteLine(String.Format("{0} 完成第 2 个批量复制处理", Now))
                    End Using

                    RemoveHandler iBcp.SqlRowsCopied, AddressOf OnSqlRowsCopied
                End Using
            End Using
            '测试不需要保留数据, 所以回滚事务
            iTs.Dispose()
        End Using
    End Sub


    Sub main()
        Console.WriteLine("测试1. 使用事务控制多个批量复制操作的测试")
        BulkTest1()
        Console.WriteLine("测试2. 使用事务控制多次批量复制操作的测试")
        BulkTest2()
        Console.WriteLine("测试完成, 按任意键继续...")
        Console.ReadKey()
    End Sub
End Module
