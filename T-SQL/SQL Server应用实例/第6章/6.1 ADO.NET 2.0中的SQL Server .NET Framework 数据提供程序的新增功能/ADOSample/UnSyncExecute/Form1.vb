Imports System.Data.SqlClient

Public Class Form1
    '当前正在执行的 T-SQL 语句数目
    Private m_RunningCount As Int32 = 0
    '连接字符串, 特别注意, 要支持异步处理, 需要指定 Asynchronous Processing=true
    Private m_ConnStr As String = "Data Source=.;Initial Catalog=tempdb;Integrated Security=SSPI;Asynchronous Processing=true"

    '获取一个打开的连接对象
    Private Function GetConnection() As SqlConnection
        Dim iRe As New SqlConnection(m_ConnStr)
        iRe.Open()
        Return iRe
    End Function

    '委托方法, 在 TabControl 中增加一个 TabPage
    Private Delegate Sub AddNewTabPageDelegate( _
            ByVal sTabPage As TabPage)

    '委托方法的实现, 在 TabControl 中增加一个 TabPage
    Private Sub AddNewTabPage( _
            ByVal sTabPage As TabPage)

        Me.Data_Tab.TabPages.Add(sTabPage)
    End Sub

    '异步执行的回调函数, 用于异步执行方法执行完成时的处理
    Private Sub HandleCallback( _
            ByVal iResult As IAsyncResult)
        Try
            '获取异步执行的 SqlCommand 对象
            Using iCmd As SqlCommand = CType(iResult.AsyncState, SqlCommand)
                Dim iTabPage As New TabPage(iCmd.CommandText)
                Dim iDataGridView As New DataGridView
                iDataGridView.Parent = iTabPage
                iDataGridView.Dock = DockStyle.Fill
                Using iDataTable As New DataTable
                    '通过 EndExecuteReader 取回异步执行的结果
                    iDataTable.Load(iCmd.EndExecuteReader(iResult))
                    iDataGridView.DataSource = iDataTable
                End Using
                '在 TabControl 中显示执行的结果
                Me.Invoke(New AddNewTabPageDelegate(AddressOf AddNewTabPage), iTabPage)
            End Using
        Catch ex As Exception
            MsgBox(ex.Message)
        Finally
            m_RunningCount -= 1
        End Try
    End Sub

    '异步执行 T-SQL 语句, 
    Private Sub AsyncExecuteQuery( _
            ByVal sSQL As String)

        Dim iCmd As SqlCommand
        Try
            iCmd = New SqlCommand(sSQL, GetConnection)
            '开始异步执行, 通过回调函数 HandleCallback 的指定, 表示异步执行完成后调用该回调函数
            iCmd.BeginExecuteReader(New AsyncCallback(AddressOf HandleCallback), iCmd)
            m_RunningCount += 1
        Catch ex As Exception
            MsgBox(ex.Message)
        End Try
    End Sub


    '控件事件
    Private Sub Execute_Command_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Execute_Command.Click
        Dim iSQL As String = Me.SQL_Text.Text
        If String.IsNullOrEmpty(iSQL) = False Then
            AsyncExecuteQuery(iSQL)
        End If
    End Sub

    Private Sub Clear_Command_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Clear_Command.Click
        If m_RunningCount > 0 Then
            MsgBox(String.Format("当前有 {0} 个正在执行的查询, 请等待它们执行完成", m_RunningCount))
        Else
            Me.Data_Tab.TabPages.Clear()
        End If
    End Sub

    Private Sub Form1_FormClosing(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles Me.FormClosing
        If m_RunningCount > 0 Then
            MsgBox(String.Format("当前有 {0} 个正在执行的查询, 请等待它们执行完成", m_RunningCount))
            e.Cancel = True
        End If
    End Sub
End Class
