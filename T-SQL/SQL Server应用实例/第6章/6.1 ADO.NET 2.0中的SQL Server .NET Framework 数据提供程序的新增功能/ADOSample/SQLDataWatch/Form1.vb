Imports System.Data.SqlClient
Imports System.Security.Permissions
Imports System.ComponentModel

Public Class Form1
    '״̬��Ϣ��ʾ�õ�ģ��
    Private Const m_StatusMessage As String = "{0} changes. Info: {1}, Source: {2}, Type: {3}"
    '���ݿ������ַ���
    Private Const m_ConnStr As String = "Data Source=.;Initial Catalog=tempdb;Integrated Security=SSPI;"

    '��ѯ֪ͨ��Ҫ��һЩ���ԺͶ���
    Private mChangeCount As Integer = 0
    Private mConn As SqlConnection = Nothing
    Private mCmd As SqlCommand = Nothing
    Private mDataToWatch As DataSet = Nothing

    '��֤Ӧ�ó����Ƿ���Ȩ�����������֪ͨ
    Private Function CanRequestNotifications() As Boolean
        Try
            Dim iPerm As New SqlClientPermission(PermissionState.Unrestricted)
            iPerm.Demand()
            Return True
        Catch ex As Exception
            Return False
        End Try
    End Function

    '���ص�ǰ����, �������û�д�, �����
    Private Function GetConnection() As SqlConnection

        If mConn Is Nothing Then
            mConn = New SqlConnection(m_ConnStr)
            If mConn.State = ConnectionState.Closed Then
                mConn.Open()
            End If
        End If
        Return mConn
    End Function

    '�ڵ�ǰ������ִ��һ�������ؽ���Ĳ�ѯ
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

    '��ʼ�����Ի���
    Private Sub InitTest()

        Dim iSQL As String = "CREATE TABLE dbo.tb_Test_ta(id int PRIMARY KEY, name varchar(10));"
        iSQL &= "CREATE TABLE dbo.tb_Test_tb(id int PRIMARY KEY, a_id int REFERENCES dbo.tb_Test_ta(id), value varchar(10))"
        ExecuteNoQuery(iSQL)
    End Sub

    'ɾ�����Ի���
    Private Sub RemoveTest()

        Dim iSQL As String = "DROP TABLE dbo.tb_Test_tb,dbo.tb_Test_ta"
        ExecuteNoQuery(iSQL)
    End Sub

    'ƥ�� OnChangeEventHandler ί��ǩ���Ĳ�ѯ֪ͨ�¼��������
    Private Sub dependency_OnChange( _
            ByVal sender As Object, _
            ByVal e As SqlNotificationEventArgs)

        '���¼���������ڹ����߳��б�����, ���, �������̰߳�ȫ��ʽ���ÿؼ�
        '����Ĵ������Ƿ���Ҫ���̰߳�ȫ��ʽ���ÿؼ�
        Dim i As ISynchronizeInvoke = CType(Me, ISynchronizeInvoke)
        If i.InvokeRequired Then    '�����Ҫ���̰߳�ȫ��ʽ���ÿؼ�
            '����һ��ί��ʵ�������л�
            Dim iTempDelegate As New OnChangeEventHandler(AddressOf dependency_OnChange)
            Dim args() As Object = {sender, e}
            '�����ݴӹ����̴߳��ݵ� UI �߳�
            i.BeginInvoke(iTempDelegate, args)
            Return
        End If

        '��Ϊÿ��ֻ����һ����ѯ֪ͨ, ������ȷ�յ�֪ͨ��ȡ���¼���
        Dim iDependency As SqlDependency = CType(sender, SqlDependency)
        RemoveHandler iDependency.OnChange, AddressOf dependency_OnChange

        '����Ĵ����� UI �߳���ִ��, ���Ը��� UI �ǰ�ȫ��
        mChangeCount += 1
        With Me.Status_List.Items
            .Add(String.Format(m_StatusMessage, mChangeCount, e.Info, e.Source, e.Type))
        End With

        '���¼��ذ󶨵� DataGridView ������, �����������, ���������¼�֪ͨ�Ľ��մ���
        GetData()
    End Sub

    '�����ڻ�ȡӦ�ó������ݵ� SqlCommand ������ע�� SqlDependency ����, �Խ��ղ�ѯ֪ͨ
    Private Sub GetData()
        '��� dataset, ��ȡ�� SqlCommand ������ע��� SqlDependency ����
        mDataToWatch.Clear()
        mCmd.Notification = Nothing

        '������ע�� SqlDependency ���� SqlCommand ������
        Dim iDependency As New SqlDependency(mCmd)
        AddHandler iDependency.OnChange, AddressOf dependency_OnChange

        Using iDataTable As New DataTable()
            iDataTable.Load(mCmd.ExecuteReader)
            Me.DataGridView1.DataSource = iDataTable
        End Using
    End Sub


    '��ʼ��ѯ֪ͨ����
    Private Sub StartTest()

        '��ʼ���ؼ�
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

    'ֹͣ����
    Private Sub StopTest()

        '��ʼ���ؼ�
        Stop_Button.Enabled = False
        Execute_Button.Enabled = False

        SqlDependency.Stop(m_ConnStr)
        RemoveTest()

        Start_Button.Enabled = True
    End Sub

    Private Sub Form1_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        'ʹ�� CanRequestNotifications �ķ���ֵ�����Ƿ���������¼�֪ͨ����Ĳ���
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
