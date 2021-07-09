Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Data.SqlTypes
Imports Microsoft.SqlServer.Server

Partial Public Class UserDefinedFunctions
    <Microsoft.SqlServer.Server.SqlFunction()> _
    Public Shared Function F_Format( _
            ByVal sDate As DateTime, _
            ByVal sFormat As String _
            ) As SqlString

        Return New SqlString(sDate.ToString(sFormat))
    End Function
End Class
