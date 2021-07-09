Imports System.Data.SqlClient
Imports System.Transactions

Module MSDTCSample
    Sub main()
        Using iTs As New TransactionScope
            Dim iConnStr As String = "Data Source=.;Initial Catalog=tempdb;Integrated Security=SSPI;"
            Using iConn1 As New SqlConnection(iConnStr)
                iConn1.Open()
                Console.WriteLine("stop 1: open connection 1 completed, press any key to continue")
                Console.ReadKey()

                '在连接1中执行一个command
                Dim iSQL As String = "CREATE TABLE dbo.tb_msdtc_test(id int)"
                Using iCmd1 As New SqlCommand(iSQL, iConn1)
                    iCmd1.ExecuteNonQuery()
                    Console.WriteLine("stop 2: Execute sql on connection 1 completed, press any key to continue")
                    Console.ReadKey()
                End Using

                '在连接1中打开第2个连接,当连接打开后, TransactionScope会侦测到需要MSDTC，会自动将事务提升为分布式事务
                Using iconn2 As New SqlConnection(iConnStr)
                    iconn2.Open()
                    Console.WriteLine("stop 3: open connection 2 completed, press any key to continue")
                    Console.ReadKey()

                    '在连接2中执行一个command
                    iSQL = "INSERT dbo.tb_msdtc_test VALUES(1)"
                    Using iCmd2 As New SqlCommand(iSQL, iconn2)
                        iCmd2.ExecuteNonQuery()
                        Console.WriteLine("stop 4: Execute sql on connection 2 completed, press any key to continue")
                        Console.ReadKey()
                    End Using
                End Using
                Console.WriteLine("stop 5: connection 2 already close, press any key to continue")
                Console.ReadKey()
            End Using
            '回滚事务, 如果要提交事务, 则改用 Complete 方法
            iTs.Dispose()
        End Using
    End Sub
End Module
