Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Data.SqlTypes
Imports Microsoft.SqlServer.Server

Imports System.Text

<Serializable()> _
<SqlUserDefinedType(Format.UserDefined, Name:="ServerInfo", MaxByteSize:=256, isbyteordered:=False, isfixedlength:=False)> _
Public Class TypeSample
    Implements INullable, IBinarySerialize

    Private m_Null As Boolean
    Private mInstance As String
    Private mLogin As String
    Private mPassword As String
    Private mDefaultDatabase As String
    Private mConnectimeOut As Int32

    Public ReadOnly Property IsNull() As Boolean Implements INullable.IsNull
        Get
            Return m_Null
        End Get
    End Property

    Public Shared ReadOnly Property Null() As TypeSample
        Get
            Return (New TypeSample)
        End Get
    End Property

    Public ReadOnly Property LoginSecure() As SqlBoolean
        Get
            Return (New SqlBoolean(String.IsNullOrEmpty(mLogin)))
        End Get
    End Property

    Public ReadOnly Property ConnectionObject() As SqlConnection
        Get
            If IsNull = True Then
                Return Nothing
            Else
                Dim iConStr As String = ConnectionString.Value
                If LoginSecure = False Then
                    iConStr = String.Format("{0};Password={1}", iConStr, mPassword)
                End If
                Return New SqlConnection(iConStr)
            End If
        End Get
    End Property

    Public Property Instance() As SqlString
        Get
            Return New SqlString(mInstance)
        End Get
        Set(ByVal value As SqlString)
            If value.IsNull = True Then
                mInstance = ""
            Else
                mInstance = value.Value
            End If
        End Set
    End Property

    Public Property Login() As SqlString
        Get
            Return New SqlString(mLogin)
        End Get
        Set(ByVal value As SqlString)
            If value.IsNull = True Then
                mLogin = ""
            Else
                mLogin = value.Value
            End If
        End Set
    End Property

    Public WriteOnly Property Password() As SqlString
        Set(ByVal value As SqlString)
            If value.IsNull = True Then
                mPassword = ""
            Else
                mPassword = value.Value
            End If
        End Set
    End Property

    Public Property DefaultDatabase() As SqlString
        Get
            Return New SqlString(mDefaultDatabase)
        End Get
        Set(ByVal value As SqlString)
            If value.IsNull = True Then
                mDefaultDatabase = ""
            Else
                mDefaultDatabase = value.Value
            End If
        End Set
    End Property

    Public Property ConnectimeOut() As SqlInt32
        Get
            Return New SqlInt32(mConnectimeOut)
        End Get
        Set(ByVal value As SqlInt32)
            If value.IsNull = True OrElse value.Value < 0 Then
                mConnectimeOut = 15
            Else
                mConnectimeOut = value.Value
            End If
        End Set
    End Property


    Public Sub New()

        m_Null = True
        mConnectimeOut = 15
    End Sub

    ''' <summary>
    ''' 将实例转换为字符串
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Overrides Function ToString() As String

        Return Me.ConnectionString.Value
    End Function

    ''' <summary>
    ''' 将字符串转换为实例
    ''' </summary>
    ''' <param name="s"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared Function Parse( _
            ByVal s As SqlString _
            ) As TypeSample

        If s.IsNull Then
            Return Null
        End If

        Dim u As TypeSample = New TypeSample
        Dim iStr As String = String.Format("{0};;;;", s.Value)
        Dim iStrSplit() As String = iStr.Split(";".ToCharArray())
        u.SetValue(iStrSplit(0), iStrSplit(1), iStrSplit(2), iStrSplit(3), CInt(Val(iStrSplit(4))))
        Return u
    End Function

    ''' <summary>
    ''' 生成连接字符串
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Function ConnectionString() As SqlString

        If IsNull = True Then
            Return (New SqlString())
        End If

        Dim iRe As String
        If LoginSecure = True Then
            iRe = String.Format("Data Source={0};Initial Catalog={1};Connect Timeout={2};Integrated Security=SSPI;", _
                    mInstance, mDefaultDatabase, mConnectimeOut)
        Else
            iRe = String.Format("Data Source={0};Initial Catalog={1};Connect Timeout={2};Integrated Security=False;User ID={3};Integrated Security=True", _
                    mInstance, mDefaultDatabase, mConnectimeOut, mLogin)
        End If
        Return New SqlString(iRe)
    End Function

    ''' <summary>
    ''' 设置服务器各项信息的值
    ''' </summary>
    ''' <param name="sInstance"></param>
    ''' <param name="sLogin"></param>
    ''' <param name="sPassword"></param>
    ''' <param name="sDefaultDatabase"></param>
    ''' <param name="sConnectimeOut"></param>
    ''' <remarks></remarks>
    <SqlMethod(IsMutator:=True, OnNullCall:=True)> _
    Public Sub SetValue( _
            ByVal sInstance As String, _
            ByVal sLogin As String, _
            ByVal sPassword As String, _
            ByVal sDefaultDatabase As String, _
            ByVal sConnectimeOut As SqlInt32 _
            )

        m_Null = False
        Instance = New SqlString(sInstance)
        Login = New SqlString(sLogin)
        Password = New SqlString(sPassword)
        DefaultDatabase = New SqlString(sDefaultDatabase)
        ConnectimeOut = sConnectimeOut
    End Sub


#Region "实现 IBinarySerialize 接口所必须实现的方法"
    ''' <summary>
    ''' 从媒介(磁盘,网络)中读取各属性值
    ''' </summary>
    ''' <param name="r"></param>
    ''' <remarks></remarks>
    Public Sub Read(ByVal r As IO.BinaryReader) Implements IBinarySerialize.Read
        m_Null = r.ReadBoolean()
        If m_Null = False Then
            mInstance = r.ReadString()
            mLogin = r.ReadString()
            mPassword = r.ReadString()
            mDefaultDatabase = r.ReadString()
            mConnectimeOut = r.ReadInt32
        End If
    End Sub

    ''' <summary>
    ''' 将各属性值写入媒介(磁盘,网络)
    ''' </summary>
    ''' <param name="w"></param>
    ''' <remarks></remarks>
    Public Sub Write(ByVal w As IO.BinaryWriter) Implements IBinarySerialize.Write
        w.Write(m_Null)
        If m_Null = False Then
            w.Write(mInstance)
            w.Write(mLogin)
            w.Write(mPassword)
            w.Write(mDefaultDatabase)
            w.Write(mConnectimeOut)
        End If
    End Sub
#End Region
End Class

