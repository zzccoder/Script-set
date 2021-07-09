Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Data.SqlTypes
Imports Microsoft.SqlServer.Server

''' <summary>
''' 存储过程示例
''' </summary>
''' <remarks></remarks>
Partial Public Class StoredProcedures
    ''' <summary>
    ''' 输出参数
    ''' </summary>
    ''' <param name="sID"></param>
    ''' <returns>如果执行成功, 返回0, 否则返回 -1</returns>
    ''' <remarks></remarks>
    <SqlProcedure()> _
    Public Shared Function SplitStringToTable( _
            ByRef sID As SqlInt32 _
            ) As SqlInt32

        Try
            sID = New SqlInt32(sID.Value + 1)
        Catch ex As Exception
            Return -1
        End Try

        Return 0
    End Function
End Class
