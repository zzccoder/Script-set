Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Data.SqlTypes
Imports Microsoft.SqlServer.Server


''' <summary>
''' 触发器示例
''' </summary>
''' <remarks></remarks>
Partial Public Class Triggers
#Region "针对指定表,指定操作的确专用触发器"
    ''' <summary>
    ''' 针对表 tb 的触发器, 触发器针对的是 INSERT 和 DELETE 事件
    ''' </summary>
    ''' <remarks></remarks>
    <SqlTrigger(Target:="tb", Event:="FOR INSERT,DELETE")> _
    Public Shared Sub tb_UPDATE_DELETE()

        Select Case SqlContext.TriggerContext.TriggerAction
            '如果是插入或删除操作, 则向客户端发送信息
            Case TriggerAction.Delete, TriggerAction.Insert
                '获取触发类型
                Dim iAction As String = "delete"
                If SqlContext.TriggerContext.TriggerAction = TriggerAction.Insert Then
                    iAction = "insert"
                End If
                '向客户端发送信息
                SqlContext.Pipe.Send( _
                        String.Format("{0} action.", iAction))

                '向客户端发送触发器影响的记录
                If iAction = "insert" Then
                    iAction += "ed"
                Else
                    iAction += "d"
                End If
                Dim iSQL As String = String.Format("SELECT * FROM {0}", iAction)
                Using iConn As New SqlConnection("context connection=True")
                    iConn.Open()
                    Using iCmd As New SqlCommand(iSQL, iConn)
                        SqlContext.Pipe.ExecuteAndSend(iCmd)
                    End Using
                End Using
            Case Else
                '如果不是插入或删除操作, 则向客户端发出提示信息, 未定义处理
                SqlContext.Pipe.Send( _
                        String.Format("not define process for action {0}", SqlContext.TriggerContext.TriggerAction))
        End Select
    End Sub
#End Region


#Region "不针对特定对象的公用触发器"
    ''' <summary>
    ''' 返回 DDL 事件信息的触发器
    ''' </summary>
    ''' <remarks></remarks>
    Public Shared Sub DDLEventDataInfo()

        Select Case SqlContext.TriggerContext.TriggerAction
            '如果是DML操作, 则向客户端发送信息, 
            Case TriggerAction.Delete, TriggerAction.Insert, TriggerAction.Update
                '如果是DML操作, 则向客户端发送信息, 表明未定义处理
                SqlContext.Pipe.Send( _
                        String.Format("not define process for action {0}", SqlContext.TriggerContext.TriggerAction))
            Case Else
                With SqlContext.Pipe
                    '定义返回的结果集的结构
                    Dim iRes(1) As SqlMetaData
                    iRes(0) = New SqlMetaData("Action", SqlDbType.NVarChar, 100)
                    iRes(1) = New SqlMetaData("EventData", SqlDbType.Xml)

                    '定义返回的结果集对象
                    Dim iRe As New SqlDataRecord(iRes)
                    .SendResultsStart(iRe)

                    '设置返回结果集数据并发送结果集到客户端
                    iRe.SetSqlString(0, SqlContext.TriggerContext.TriggerAction.ToString)
                    iRe.SetSqlString(1, SqlContext.TriggerContext.EventData.Value)
                    .SendResultsRow(iRe)
                    .SendResultsEnd()
                End With
        End Select
    End Sub
#End Region
End Class
