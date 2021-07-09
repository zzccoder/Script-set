Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Data.SqlTypes
Imports Microsoft.SqlServer.Server

''' <summary>
''' 用户定义函数示例
''' </summary>
''' <remarks></remarks>
Partial Public Class UserDefinedFunctions
#Region "标量值函数示例"
    ''' <summary>
    ''' 使用指定格式，将datetime类型的值转换成其等效的字符串表示
    ''' </summary>
    ''' <param name="sDate">datetime类型的值</param>
    ''' <param name="sFormat">格式</param>
    ''' <returns>根据指定格式转换后datetime类型值的字符串表示</returns>
    ''' <remarks></remarks>
    <SqlFunction()> _
    Public Shared Function F_Format( _
            ByVal sDate As DateTime, _
            ByVal sFormat As String _
            ) As SqlString

        Return New SqlString(sDate.ToString(sFormat))
    End Function
#End Region

#Region "表值函数示例"
    ''' <summary>
    ''' 表值函数示例
    ''' 根据指定的分隔符拆分一个字符串
    ''' </summary>
    ''' <param name="sExpression">待拆分的字符串</param>
    ''' <param name="sDelimiters">分隔符</param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    <SqlFunction(FillRowMethodName:="FillSplitRow", TableDefinition:="Value nvarchar(128)")> _
    Public Shared Function SplitString( _
            ByVal sExpression As SqlString, _
            ByVal sDelimiters As SqlString _
            ) As IEnumerable

        Dim iValues As String
        If sExpression.IsNull Then
            iValues = String.Empty
        Else
            iValues = sExpression.Value
        End If

        Dim iDelimiters As String
        If sDelimiters.IsNull Then
            iDelimiters = ","
        Else
            iDelimiters = sDelimiters.Value
        End If

        Return iValues.Split(iDelimiters.ToCharArray())
    End Function

    ''' <summary>
    ''' 字符串拆分函数的迭代函数
    ''' 用于返回表值函数的每一条记录的值(字符串拆分后的每一个值)
    ''' </summary>
    ''' <param name="sRow">被拆分出的每一个字符串</param>
    ''' <param name="sValue">返回值</param>
    ''' <remarks></remarks>
    Private Shared Sub FillSplitRow( _
            ByVal sRow As Object, _
            ByRef sValue As String)

        sValue = TryCast(sRow, String)
    End Sub
#End Region
End Class
