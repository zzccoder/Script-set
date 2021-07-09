Imports System.Data.SqlClient
Imports CLRSample

Public Class Form1
    ''' <summary>
    ''' 对 CLRSample 库的连接对象
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Function CLRSampConn() As SqlConnection

        Dim iConStr As String = "Data Source=;Initial Catalog=CLRSample;Integrated Security=SSPI"
        Return (New SqlConnection(iConStr))
    End Function

    ''' <summary>
    ''' 根据窗体控件输入的值建立 ServerInfo 对象
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Function CreateServerInfo() As TypeSample

        Dim iRe As New TypeSample()
        iRe.SetValue(text_Instance.Text, text_Login.Text, text_Password.Text, text_Database.Text, 15)
        Return iRe
    End Function

    ''' <summary>
    ''' 建立演示表
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub CreateSampleTable()

        Dim iSQL As String = "IF OBJECT_ID(N'dbo.tb_CLRUDTTest') IS NULL"
        iSQL &= vbCrLf
        iSQL &= "CREATE TABLE dbo.tb_CLRUDTTest(id int IDENTITY(1, 1), ServerInfo ServerInfo)"
        Using iCon As SqlConnection = CLRSampConn()
            iCon.Open()
            Using iCmd As New SqlCommand(iSQL, iCon)
                iCmd.ExecuteNonQuery()
            End Using
            iCon.Close()
        End Using
    End Sub

    ''' <summary>
    ''' 删除演示表
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub DropSampleTable()

        Dim iSQL As String = "IF OBJECT_ID(N'dbo.tb_CLRUDTTest') IS NOT NULL"
        iSQL &= vbCrLf
        iSQL &= "DROP TABLE dbo.tb_CLRUDTTest"
        Using iCon As SqlConnection = CLRSampConn()
            iCon.Open()
            Using iCmd As New SqlCommand(iSQL, iCon)
                iCmd.ExecuteNonQuery()
            End Using
            iCon.Close()
        End Using
    End Sub

    ''' <summary>
    ''' 加载数据到DataGridView
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub LoadData()

        Dim iSQL As String = "SELECT id, Instance = ServerInfo.Instance, Login = ServerInfo.Login, DefaultDatabase = ServerInfo.DefaultDatabase, ServerInfo FROM dbo.tb_CLRUDTTest"
        Using iCon As SqlConnection = CLRSampConn()
            iCon.Open()
            Using iCmd As New SqlCommand(iSQL, iCon)
                Using iDataTable As New DataTable
                    iDataTable.Load(iCmd.ExecuteReader())
                    DataGridView1.DataSource = iDataTable
                End Using
            End Using
            iCon.Close()
        End Using
    End Sub

    ''' <summary>
    ''' 根据窗体控件输入的值建立 ServerInfo 对象
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub SetServerInfo( _
            ByVal sServerInfo As TypeSample)

        If sServerInfo Is Nothing OrElse sServerInfo.IsNull = True Then
            Return
        End If
        text_Instance.Text = sServerInfo.Instance
        text_Login.Text = sServerInfo.Login
        text_Database.Text = sServerInfo.DefaultDatabase
    End Sub

    ''' <summary>
    ''' 根据窗体控件输入的值在数据库中记录新的 ServerInfo 对象
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub SaveServerInfo()

        Dim iSQL As String = "INSERT dbo.tb_CLRUDTTest(ServerInfo) VALUES( @ServerInfo)"
        Using iCon As SqlConnection = CLRSampConn()
            iCon.Open()
            Using iCmd As New SqlCommand(iSQL, iCon)
                iCmd.Parameters.Add(New SqlParameter("@ServerInfo", SqlDbType.Udt))
                With (iCmd.Parameters("@ServerInfo"))
                    .UdtTypeName = "ServerInfo"
                    .Value = CreateServerInfo()
                End With
                iCmd.ExecuteNonQuery()
            End Using
            iCon.Close()
        End Using

        LoadData()
    End Sub

    ''' <summary>
    ''' 根据窗体控件输入的值在数据库中更新 ServerInfo 对象
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub SaveServerInfo( _
            ByVal sID As Int32)

        Dim iSQL As String = "UPDATE dbo.tb_CLRUDTTest SET ServerInfo = @ServerInfo WHERE id = @id"
        Using iCon As SqlConnection = CLRSampConn()
            iCon.Open()
            Using iCmd As New SqlCommand(iSQL, iCon)
                iCmd.Parameters.Add(New SqlParameter("@id", SqlDbType.Int))
                iCmd.Parameters("@id").Value = sID
                iCmd.Parameters.Add(New SqlParameter("@ServerInfo", SqlDbType.Udt))
                With (iCmd.Parameters("@ServerInfo"))
                    .UdtTypeName = "ServerInfo"
                    .Value = CreateServerInfo()
                End With
                iCmd.ExecuteNonQuery()
            End Using
            iCon.Close()
        End Using

        LoadData()
    End Sub

    ''' <summary>
    ''' 显示当前 ServerInfo 的服务器信息
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub ShowServerInfo( _
            ByVal sServerInfo As TypeSample)

        Dim iSQL As String = "SELECT ServerName = @@SERVERNAME, [Database] = DB_NAME()"
        Using iCon As SqlConnection = sServerInfo.ConnectionObject
            iCon.Open()
            Using iCmd As New SqlCommand(iSQL, iCon)
                Using iDataTable As New DataTable
                    iDataTable.Load(iCmd.ExecuteReader())
                    Dim iRow As DataRow = iDataTable.Rows(0)
                    MsgBox(String.Format("ServerName: {0} {1} Database: {2}", iRow(0).ToString, vbCrLf, iRow(1).ToString))
                End Using
            End Using
            iCon.Close()
        End Using

        LoadData()
    End Sub


    Private Sub Form1_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        CreateSampleTable()
        LoadData()
    End Sub

    Private Sub Form1_FormClosed(ByVal sender As System.Object, ByVal e As System.Windows.Forms.FormClosedEventArgs) Handles MyBase.FormClosed
        DropSampleTable()
    End Sub

    Private Sub cmd_Add_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmd_Add.Click
        SaveServerInfo()
    End Sub

    Private Sub DataGridView1_CellClick(ByVal sender As Object, ByVal e As System.Windows.Forms.DataGridViewCellEventArgs) Handles DataGridView1.CellClick

        If e.RowIndex = -1 Then
            Return
        End If
        SetServerInfo(DataGridView1.Item("ServerInfo", e.RowIndex).Value)
    End Sub

    Private Sub cmd_Save_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmd_Save.Click

        If DataGridView1.CurrentCell IsNot Nothing AndAlso DataGridView1.CurrentCell.RowIndex >= 0 Then
            Dim iId As Int32 = DataGridView1.Item("id", DataGridView1.CurrentCell.RowIndex).Value
            SaveServerInfo(iId)
        End If
    End Sub

    Private Sub cmd_VerifyData_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmd_VerifyData.Click

        If DataGridView1.CurrentCell IsNot Nothing AndAlso DataGridView1.CurrentCell.RowIndex >= 0 Then
            Dim iServerInfo As TypeSample = DataGridView1.Item("ServerInfo", DataGridView1.CurrentCell.RowIndex).Value
            ShowServerInfo(iServerInfo)
        End If

    End Sub
End Class
