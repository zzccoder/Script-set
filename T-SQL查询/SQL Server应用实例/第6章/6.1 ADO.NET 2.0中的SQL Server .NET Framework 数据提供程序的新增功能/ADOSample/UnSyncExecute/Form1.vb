Imports System.Data.SqlClient

Public Class Form1
    '��ǰ����ִ�е� T-SQL �����Ŀ
    Private m_RunningCount As Int32 = 0
    '�����ַ���, �ر�ע��, Ҫ֧���첽����, ��Ҫָ�� Asynchronous Processing=true
    Private m_ConnStr As String = "Data Source=.;Initial Catalog=tempdb;Integrated Security=SSPI;Asynchronous Processing=true"

    '��ȡһ���򿪵����Ӷ���
    Private Function GetConnection() As SqlConnection
        Dim iRe As New SqlConnection(m_ConnStr)
        iRe.Open()
        Return iRe
    End Function

    'ί�з���, �� TabControl ������һ�� TabPage
    Private Delegate Sub AddNewTabPageDelegate( _
            ByVal sTabPage As TabPage)

    'ί�з�����ʵ��, �� TabControl ������һ�� TabPage
    Private Sub AddNewTabPage( _
            ByVal sTabPage As TabPage)

        Me.Data_Tab.TabPages.Add(sTabPage)
    End Sub

    '�첽ִ�еĻص�����, �����첽ִ�з���ִ�����ʱ�Ĵ���
    Private Sub HandleCallback( _
            ByVal iResult As IAsyncResult)
        Try
            '��ȡ�첽ִ�е� SqlCommand ����
            Using iCmd As SqlCommand = CType(iResult.AsyncState, SqlCommand)
                Dim iTabPage As New TabPage(iCmd.CommandText)
                Dim iDataGridView As New DataGridView
                iDataGridView.Parent = iTabPage
                iDataGridView.Dock = DockStyle.Fill
                Using iDataTable As New DataTable
                    'ͨ�� EndExecuteReader ȡ���첽ִ�еĽ��
                    iDataTable.Load(iCmd.EndExecuteReader(iResult))
                    iDataGridView.DataSource = iDataTable
                End Using
                '�� TabControl ����ʾִ�еĽ��
                Me.Invoke(New AddNewTabPageDelegate(AddressOf AddNewTabPage), iTabPage)
            End Using
        Catch ex As Exception
            MsgBox(ex.Message)
        Finally
            m_RunningCount -= 1
        End Try
    End Sub

    '�첽ִ�� T-SQL ���, 
    Private Sub AsyncExecuteQuery( _
            ByVal sSQL As String)

        Dim iCmd As SqlCommand
        Try
            iCmd = New SqlCommand(sSQL, GetConnection)
            '��ʼ�첽ִ��, ͨ���ص����� HandleCallback ��ָ��, ��ʾ�첽ִ����ɺ���øûص�����
            iCmd.BeginExecuteReader(New AsyncCallback(AddressOf HandleCallback), iCmd)
            m_RunningCount += 1
        Catch ex As Exception
            MsgBox(ex.Message)
        End Try
    End Sub


    '�ؼ��¼�
    Private Sub Execute_Command_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Execute_Command.Click
        Dim iSQL As String = Me.SQL_Text.Text
        If String.IsNullOrEmpty(iSQL) = False Then
            AsyncExecuteQuery(iSQL)
        End If
    End Sub

    Private Sub Clear_Command_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Clear_Command.Click
        If m_RunningCount > 0 Then
            MsgBox(String.Format("��ǰ�� {0} ������ִ�еĲ�ѯ, ��ȴ�����ִ�����", m_RunningCount))
        Else
            Me.Data_Tab.TabPages.Clear()
        End If
    End Sub

    Private Sub Form1_FormClosing(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles Me.FormClosing
        If m_RunningCount > 0 Then
            MsgBox(String.Format("��ǰ�� {0} ������ִ�еĲ�ѯ, ��ȴ�����ִ�����", m_RunningCount))
            e.Cancel = True
        End If
    End Sub
End Class
