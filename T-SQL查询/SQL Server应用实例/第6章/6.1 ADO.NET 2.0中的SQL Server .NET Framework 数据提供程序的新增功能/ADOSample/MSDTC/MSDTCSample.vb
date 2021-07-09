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

                '������1��ִ��һ��command
                Dim iSQL As String = "CREATE TABLE dbo.tb_msdtc_test(id int)"
                Using iCmd1 As New SqlCommand(iSQL, iConn1)
                    iCmd1.ExecuteNonQuery()
                    Console.WriteLine("stop 2: Execute sql on connection 1 completed, press any key to continue")
                    Console.ReadKey()
                End Using

                '������1�д򿪵�2������,�����Ӵ򿪺�, TransactionScope����⵽��ҪMSDTC�����Զ�����������Ϊ�ֲ�ʽ����
                Using iconn2 As New SqlConnection(iConnStr)
                    iconn2.Open()
                    Console.WriteLine("stop 3: open connection 2 completed, press any key to continue")
                    Console.ReadKey()

                    '������2��ִ��һ��command
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
            '�ع�����, ���Ҫ�ύ����, ����� Complete ����
            iTs.Dispose()
        End Using
    End Sub
End Module
