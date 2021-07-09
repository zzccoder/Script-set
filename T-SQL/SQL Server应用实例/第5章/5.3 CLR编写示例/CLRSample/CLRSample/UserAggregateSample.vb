Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Data.SqlTypes
Imports Microsoft.SqlServer.Server

Imports System.Text

''' <summary>
''' 聚合函数示例
''' 聚合字符串, 各值之间用逗号(,)分隔
''' </summary>
''' <remarks></remarks>
<Serializable()> _
<SqlUserDefinedAggregate( _
        Format.UserDefined, MaxByteSize:=8000, _
        IsInvariantToNulls:=False, IsInvariantToDuplicates:=False, IsInvariantToOrder:=True, IsNullifEmpty:=True)> _
Public Class ConcatString
    Implements IBinarySerialize

    Private m_Values As StringBuilder

    ''' <summary>
    ''' 初始化, 每个正在聚合的组会调用
    ''' </summary>
    ''' <remarks></remarks>
    Public Sub Init()
        m_Values = New StringBuilder
    End Sub

    ''' <summary>
    ''' 正在聚合的组中的每个值会调用一次Accumulate方法，该方法更新实例的状态，以反映传入的参数值的累积
    ''' </summary>
    ''' <param name="value"></param>
    ''' <remarks></remarks>
    Public Sub Accumulate(ByVal value As SqlString)

        If value.IsNull = False Then
            m_Values.AppendFormat(",{0}", value.Value)
        End If
    End Sub

    ''' <summary>
    ''' 将此聚合类的另一个实例与当前实例合并在一起
    ''' </summary>
    ''' <param name="value"></param>
    ''' <remarks></remarks>
    Public Sub Merge(ByVal value As ConcatString)
        m_Values.Append(value.m_Values)
    End Sub

    ''' <summary>
    ''' 完成聚合计算并返回聚合的结果
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Function Terminate() As SqlString

        Dim iRe As String = String.Empty
        If m_Values IsNot Nothing AndAlso m_Values.Length > 0 Then
            iRe = m_Values.ToString(1, m_Values.Length - 1)
        End If
        Return New SqlString(iRe)
    End Function


#Region "实现 IBinarySerialize 接口所必须实现的方法"
    ''' <summary>
    ''' 从媒介(磁盘,网络)中读取各属性值
    ''' </summary>
    ''' <param name="r"></param>
    ''' <remarks></remarks>
    Public Sub Read(ByVal r As IO.BinaryReader) Implements IBinarySerialize.Read
        m_Values = New StringBuilder(r.ReadString())
    End Sub

    ''' <summary>
    ''' 将各属性值写入媒介(磁盘,网络)
    ''' </summary>
    ''' <param name="w"></param>
    ''' <remarks></remarks>
    Public Sub Write(ByVal w As IO.BinaryWriter) Implements IBinarySerialize.Write
        w.Write(m_Values.ToString)
    End Sub
#End Region
End Class

