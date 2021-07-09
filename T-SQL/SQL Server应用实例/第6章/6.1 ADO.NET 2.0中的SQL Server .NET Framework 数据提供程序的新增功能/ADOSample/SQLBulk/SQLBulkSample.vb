Imports System.Data.SqlClient
Imports System.Transactions

Module SQLBulkSample
    Private m_ConnStr As String = "Data Source=.;Initial Catalog=tempdb;Integrated Security=SSPI;"

    '�����������Ʋ�������Ҫ��Ŀ�ı�
    Public Sub InitTest( _
            ByVal sConn As SqlConnection)

        '�����������Ƶ�Ŀ�ı�
        Using iCmd As New SqlCommand()
            iCmd.Connection = sConn

            '����bulk���Ե�Ŀ�ı�1
            iCmd.CommandText = "SELECT TOP 0 * INTO dbo.tb_bulk_test_objects FROM sys.objects"
            iCmd.ExecuteNonQuery()

            '����bulk���Ե�Ŀ�ı�2
            iCmd.CommandText = "SELECT TOP 0 * INTO dbo.tb_bulk_test_columns FROM sys.columns"
            iCmd.ExecuteNonQuery()
        End Using
    End Sub

    '��ÿ�δ����� NotifyAfter ����ָ��������ʱ����
    Private Sub OnSqlRowsCopied(ByVal sender As Object, ByVal args As SqlRowsCopiedEventArgs)
        Console.WriteLine(String.Format("Copied {0} so fat...", args.RowsCopied.ToString()))
    End Sub

    ''' <summary>
    ''' ��������
    ''' </summary>
    ''' <param name="sConn">SqlConnection����,����Դ��Ŀ�ı�ʹ��ͬһ������</param>
    ''' <param name="sSourceSQL">��ѯ��������Դ�� T-SQL ���</param>
    ''' <param name="sDestinationTable">�������Ƶ�Ŀ�ı���</param>
    ''' <remarks></remarks>
    Private Sub Bulk( _
            ByVal sConn As SqlConnection, _
            ByVal sSourceSQL As String, _
            ByVal sDestinationTable As String)

        Using iCmd As New SqlCommand(sSourceSQL, sConn)
            Using iBcp As SqlBulkCopy = New SqlBulkCopy(sConn)
                iBcp.NotifyAfter = 5000            'ÿ��� 5000 ����¼֪ͨ
                iBcp.DestinationTableName = sDestinationTable
                AddHandler iBcp.SqlRowsCopied, AddressOf OnSqlRowsCopied
                Using iDataTable As New DataTable
                    '��ΪԴ��Ŀ�Ķ�ʹ��ͬһ������, ��ͬһ���Ӳ���ͬʱ��Դ��Ŀ�Ķ���, ������Ҫ��������䵽 DataTable ��
                    iDataTable.Load(iCmd.ExecuteReader())
                    '�������ݵ�Ŀ�ı���
                    iBcp.WriteToServer(iDataTable)
                End Using
                RemoveHandler iBcp.SqlRowsCopied, AddressOf OnSqlRowsCopied
            End Using
        End Using
    End Sub

    'ʹ��������ƶ���������Ʋ����Ĳ���
    Public Sub BulkTest1()
        'ͨ�� TransactionScope �������������ƽ���ͳһ���������
        Using iTs As New TransactionScope
            Using iConn As New SqlConnection(m_ConnStr)
                iConn.Open()

                '�������Ʋ�����Ҫ��Ŀ�ı�
                InitTest(iConn)

                Dim iDate As DateTime
                Dim iSQL As String
                '��1����������
                iDate = Now
                Console.WriteLine(String.Format("{0} ��ʼ��1���������ƴ���", iDate))
                iSQL = "SELECT O.* FROM sys.objects O, sys.columns C"
                Bulk(iConn, iSQL, "dbo.tb_bulk_test_objects")
                Console.WriteLine(String.Format("{0} ��ɵ�1���������ƴ���", Now))

                '��2����������
                iDate = Now
                Console.WriteLine(String.Format("{0} ��ʼ��2���������ƴ���", iDate))
                iSQL = "SELECT C.* FROM sys.objects O, sys.columns C"
                Bulk(iConn, iSQL, "dbo.tb_bulk_test_columns")
                Console.WriteLine(String.Format("{0} ��ɵ�2���������ƴ���", Now))
            End Using
            '���Բ���Ҫ��������, ���Իع�����
            iTs.Dispose()
        End Using
    End Sub

    'ʹ��������ƶ���������Ʋ����Ĳ���
    Public Sub BulkTest2()
        'ͨ�� TransactionScope �������������ƽ���ͳһ���������
        Using iTs As New TransactionScope
            Using iConn As New SqlConnection(m_ConnStr)
                iConn.Open()

                '�������Ʋ�����Ҫ��Ŀ�ı�
                InitTest(iConn)

                '����������Ʋ���
                Using iBcp As SqlBulkCopy = New SqlBulkCopy(iConn)
                    '�����������Ʋ����ļ�¼֪ͨ
                    iBcp.NotifyAfter = 5000            'ÿ��� 5000 ����¼֪ͨ
                    AddHandler iBcp.SqlRowsCopied, AddressOf OnSqlRowsCopied

                    Dim iDate As DateTime
                    Using iCmd As New SqlCommand()
                        iCmd.Connection = iConn

                        '��1����������
                        iDate = Now
                        Console.WriteLine(String.Format("{0} ��ʼ�� 1 ���������ƴ���", iDate))
                        iCmd.CommandText = "SELECT O.* FROM sys.objects O, sys.columns C"
                        iBcp.DestinationTableName = "dbo.tb_bulk_test_objects"
                        Using iDataTable As New DataTable
                            '��ΪԴ��Ŀ�Ķ�ʹ��ͬһ������, ��ͬһ���Ӳ���ͬʱ��Դ��Ŀ�Ķ���, ������Ҫ��������䵽 DataTable ��
                            iDataTable.Load(iCmd.ExecuteReader())
                            '�������ݵ�Ŀ�ı���
                            iBcp.WriteToServer(iDataTable)
                        End Using
                        Console.WriteLine(String.Format("{0} ��ɵ� 1 ���������ƴ���", Now))

                        '��2����������
                        iDate = Now
                        Console.WriteLine(String.Format("{0} ��ʼ�� 2 ���������ƴ���", iDate))
                        iCmd.CommandText = "SELECT C.* FROM sys.objects O, sys.columns C"
                        iBcp.DestinationTableName = "dbo.tb_bulk_test_columns"
                        Using iDataTable As New DataTable
                            '��ΪԴ��Ŀ�Ķ�ʹ��ͬһ������, ��ͬһ���Ӳ���ͬʱ��Դ��Ŀ�Ķ���, ������Ҫ��������䵽 DataTable ��
                            iDataTable.Load(iCmd.ExecuteReader())
                            '�������ݵ�Ŀ�ı���
                            iBcp.WriteToServer(iDataTable)
                        End Using
                        Console.WriteLine(String.Format("{0} ��ɵ� 2 ���������ƴ���", Now))
                    End Using

                    RemoveHandler iBcp.SqlRowsCopied, AddressOf OnSqlRowsCopied
                End Using
            End Using
            '���Բ���Ҫ��������, ���Իع�����
            iTs.Dispose()
        End Using
    End Sub


    Sub main()
        Console.WriteLine("����1. ʹ��������ƶ���������Ʋ����Ĳ���")
        BulkTest1()
        Console.WriteLine("����2. ʹ��������ƶ���������Ʋ����Ĳ���")
        BulkTest2()
        Console.WriteLine("�������, �����������...")
        Console.ReadKey()
    End Sub
End Module
