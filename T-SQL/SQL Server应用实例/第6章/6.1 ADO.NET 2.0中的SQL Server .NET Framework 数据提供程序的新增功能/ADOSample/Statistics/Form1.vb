Imports System.Data.SqlClient

Public Class Form1
    Private Const m_ConnStr As String = "Data Source=.;Initial Catalog=tempdb;Integrated Security=SSPI;"
    '公用连接对象
    Private mConn As SqlConnection

    '在指定连接上执行输入的 T-SQL 脚本, 并且刷新统计信息
    Private Sub ExecteNoQuery( _
            ByRef sConn As SqlConnection)

        '打开连接
        If sConn Is Nothing Then
            sConn = New SqlConnection(m_ConnStr)
        End If
        If sConn.State = ConnectionState.Closed Then
            sConn.Open()
        End If
        sConn.StatisticsEnabled = True
        If ResetStatistics_Check.Checked = True Then
            sConn.ResetStatistics()
        End If

        '执行输入的 T-SQL 语句
        Dim iSQL As String = Me.TextBox1.Text
        If String.IsNullOrEmpty(iSQL) = False Then
            Using iCmd As New SqlCommand(iSQL, sConn)
                iCmd.ExecuteNonQuery()
            End Using
        End If

        '刷新统计信息
        Dim iEnum As IDictionaryEnumerator = sConn.RetrieveStatistics().GetEnumerator()
        Using iDataTable As New DataTable()
            iDataTable.Columns.Add("Key", Type.GetType("System.String"))
            iDataTable.Columns.Add("Value", Type.GetType("System.Int64"))
            While iEnum.MoveNext()
                Dim iRow As DataRow = iDataTable.NewRow()
                iRow(0) = iEnum.Key
                iRow(1) = iEnum.Value
                iDataTable.Rows.Add(iRow)
            End While
            Me.DataGridView1.DataSource = iDataTable
        End Using
    End Sub

    '关闭连接
    Private Sub CloseConnection()

        If mConn IsNot Nothing AndAlso mConn.State <> ConnectionState.Closed Then
            mConn.Close()
        End If
    End Sub


    '编写窗体和按钮事件，关联到对应的处理方法
    Private Sub PriveExecute_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles PriveExecute_Button.Click
        Using iConn As New SqlConnection(m_ConnStr)
            ExecteNoQuery(iConn)
        End Using
    End Sub

    Private Sub CommonExecute_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CommonExecute_Button.Click
        ExecteNoQuery(mConn)
    End Sub

    Private Sub CloseCommConnection_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CloseCommConnection_Button.Click
        CloseConnection()
    End Sub

    Private Sub Form1_FormClosing(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles Me.FormClosing
        CloseConnection()
    End Sub
End Class
