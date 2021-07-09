Imports System.Data.SqlClient
Imports System.Security.Permissions
Imports System.ComponentModel

Public Class Form1
    '状态信息显示用的模板
    Private Const m_StatusMessage As String = "{0} changes. Info: {1}, Source: {2}, Type: {3}"
    '数据库连接字符串
    Private Const m_ConnStr As String = "Data Source=.;Initial Catalog=tempdb;Integrated Security=SSPI;"

    '查询通知需要的一些属性和对象
    Private mChangeCount As Integer = 0
    Private mConn As SqlConnection = Nothing
    Private mCmd As SqlCommand = Nothing
    Private mDataToWatch As DataSet = Nothing

    '验证应用程序是否有权向服务器请求通知
    Private Function CanRequestNotifications() As Boolean
        Try
            Dim iPerm As New SqlClientPermission(PermissionState.Unrestricted)
            iPerm.Demand()
            Return True
        Catch ex As Exception
            Return False
        End Try
    End Function

    '返回当前连接, 如果连接没有打开, 则打开它
    Private Function GetConnection() As SqlConnection

        If mConn Is Nothing Then
            mConn = New SqlConnection(m_ConnStr)
            If mConn.State = ConnectionState.Closed Then
                mConn.Open()
            End If
        End If
        Return mConn
    End Function

    '在当前连接上执行一个不返回结果的查询
    Private Function ExecuteNoQuery( _
            ByVal sSQL As String _
            ) As Boolean

        Try
            Using iCmd As New SqlCommand(sSQL, GetConnection)
                iCmd.ExecuteNonQuery()
            End Using
            Return True
        Catch ex As Exception
            Return False
        End Try
    End Function

    '初始化测试环境
    Private Sub InitTest()

        Dim iSQL As String = "CREATE TABLE dbo.tb_Test_ta(id int PRIMARY KEY, name varchar(10));"
        iSQL &= "CREATE TABLE dbo.tb_Test_tb(id int PRIMARY KEY, a_id int REFERENCES dbo.tb_Test_ta(id), value varchar(10))"
        ExecuteNoQuery(iSQL)
    End Sub

    '删除测试环境
    Private Sub RemoveTest()

        Dim iSQL As String = "DROP TABLE dbo.tb_Test_tb,dbo.tb_Test_ta"
        ExecuteNoQuery(iSQL)
    End Sub

    '匹配 OnChangeEventHandler 委托签名的查询通知事件处理过程
    Private Sub dependency_OnChange( _
            ByVal sender As Object, _
            ByVal e As SqlNotificationEventArgs)

        '此事件处理过程在工作线程中被激活, 因此, 必须以线程安全方式调用控件
        '下面的代码检测是否需要以线程安全方式调用控件
        Dim i As ISynchronizeInvoke = CType(Me, ISynchronizeInvoke)
        If i.InvokeRequired Then    '如果需要以线程安全方式调用控件
            '创建一个委托实现线种切换
            Dim iTempDelegate As New OnChangeEventHandler(AddressOf dependency_OnChange)
            Dim args() As Object = {sender, e}
            '将数据从工作线程传递到 UI 线程
            i.BeginInvoke(iTempDelegate, args)
            Return
        End If

        '因为每次只处理一个查询通知, 所以正确收到通知后取消事件绑定
        Dim iDependency As SqlDependency = CType(sender, SqlDependency)
        RemoveHandler iDependency.OnChange, AddressOf dependency_OnChange

        '这里的代码在 UI 线程中执行, 所以更新 UI 是安全的
        mChangeCount += 1
        With Me.Status_List.Items
            .Add(String.Format(m_StatusMessage, mChangeCount, e.Info, e.Source, e.Type))
        End With

        '重新加载绑定到 DataGridView 的数据, 在这个方法中, 包含对新事件通知的接收处理
        GetData()
    End Sub

    '在用于获取应用程序数据的 SqlCommand 对象中注册 SqlDependency 对象, 以接收查询通知
    Private Sub GetData()
        '清空 dataset, 并取消 SqlCommand 对象中注册的 SqlDependency 对象
        mDataToWatch.Clear()
        mCmd.Notification = Nothing

        '创建并注册 SqlDependency 对象到 SqlCommand 对象中
        Dim iDependency As New SqlDependency(mCmd)
        AddHandler iDependency.OnChange, AddressOf dependency_OnChange

        Using iDataTable As New DataTable()
            iDataTable.Load(mCmd.ExecuteReader)
            Me.DataGridView1.DataSource = iDataTable
        End Using
    End Sub


    '开始查询通知测试
    Private Sub StartTest()

        '初始化控件
        InitTest()
        Start_Button.Enabled = False
        mChangeCount = 0
        Me.Status_List.Items.Clear()

        SqlDependency.Start(m_ConnStr)

        If mCmd Is Nothing Then
            Dim iSQL As String = "SELECT B.A_id, A.name, B_id = B.id, B.value FROM dbo.tb_Test_ta A JOIN dbo.tb_Test_tb B ON A.id = B.A_id"
            mCmd = New SqlCommand(iSQL, GetConnection())
        End If

        If mDataToWatch Is Nothing Then
            mDataToWatch = New DataSet()
        End If
        GetData()

        Stop_Button.Enabled = True
        Execute_Button.Enabled = True
    End Sub

    '停止测试
    Private Sub StopTest()

        '初始化控件
        Stop_Button.Enabled = False
        Execute_Button.Enabled = False

        SqlDependency.Stop(m_ConnStr)
        RemoveTest()

        Start_Button.Enabled = True
    End Sub

    Private Sub Form1_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        '使用 CanRequestNotifications 的返回值设置是否允许进行事件通知处理的测试
        Me.Start_Button.Enabled = CanRequestNotifications()
        Me.Stop_Button.Enabled = False
        Me.Execute_Button.Enabled = False
    End Sub

    Private Sub Form1_FormClosing(ByVal sender As System.Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles MyBase.FormClosing
        StopTest()
    End Sub

    Private Sub Start_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Start_Button.Click
        StartTest()
    End Sub

    Private Sub Stop_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Stop_Button.Click
        StopTest()
    End Sub

    Private Sub Execute_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Execute_Button.Click
        ExecuteNoQuery(Me.SQL_Text.Text)
    End Sub
End Class
