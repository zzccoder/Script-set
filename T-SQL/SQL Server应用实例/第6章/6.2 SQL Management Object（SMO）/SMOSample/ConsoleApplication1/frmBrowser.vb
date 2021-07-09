Imports System.Windows.Forms
Imports System.ComponentModel

Imports Microsoft.SqlServer.Management.Common
Imports Microsoft.SqlServer.Management.Smo
Imports Microsoft.SqlServer.Management.Smo.Wmi
Imports Microsoft.SqlServer.MessageBox

Public Class frmBrowser
    Private Const m_NodePlaceHolder As String = "*"
    Private Const m_SQLServerNodeName As String = "SQLServer [{0}]"
    Private Const m_ManagedComputerNodeName As String = "Managed Computer [{0}]"

    '���ָ���������Ƿ������ TreeView ����ʾ
    Private Shared Function IsExpandablePropertyType( _
            ByVal sType As Type _
            ) As Boolean
        If Type.GetTypeCode(sType) <> TypeCode.Object Then
            Return False
        End If

        If sType Is GetType(Guid) OrElse sType Is GetType(DateTime) Then
            Return False
        End If

        Return True
    End Function

    '���ָ���������Ƿ������ TreeView ����ʾ
    Private Shared Function IsExpandableProperty( _
            ByVal sProperty As PropertyDescriptor _
            ) As Boolean
        If IsExpandablePropertyType(sProperty.PropertyType) = False Then
            Return False
        End If

        If sProperty.PropertyType.IsArray Then
            If IsExpandablePropertyType(sProperty.PropertyType.GetElementType()) = False Then
                Return False
            End If
        End If

        If sProperty.Name = "Urn" _
                OrElse sProperty.Name = "UserData" _
                OrElse sProperty.Name = "Properties" _
                OrElse sProperty.Name = "ExtendedProperties" _
                OrElse sProperty.Name = "Parent" _
                OrElse sProperty.Name = "Events" Then
            Return False
        End If

        Return True
    End Function

    '���ָ����item�����Ƿ���������� TreeView ����ʾ������
    Private Shared Function HasExpandableProperties( _
            ByVal sItem As Object _
            ) As Boolean
        For Each iProperty As PropertyDescriptor In TypeDescriptor.GetProperties(sItem)
            If IsExpandableProperty(iProperty) Then
                Return True
            End If
        Next

        Return False
    End Function

    '����һ�����ָ�� item ��TreeNode
    Private Shared Function CreateNode( _
            ByVal sItem As Object _
            ) As TreeNode

        Dim iName As String = Nothing
        Dim iProperty As PropertyDescriptor

        For Each iPropertyName As String In New String() {"Name", "Urn"}
            iProperty = TypeDescriptor.GetProperties(sItem)(iPropertyName)
            If Not (iProperty Is Nothing) Then
                iName = iProperty.GetValue(sItem).ToString()
                Exit For
            End If
        Next

        If iName Is Nothing Then
            iName = sItem.ToString()
        End If

        Return CreateNode(iName, sItem)
    End Function

    '����һ�����ָ�� item ��TreeNode
    Private Shared Function CreateNode( _
            ByVal sName As String, _
            ByVal sItem As Object _
            ) As TreeNode

        Dim iNode As New TreeNode(sName)
        iNode.Tag = sItem
        '��� item ��һ����������(ICollection), �����ǰ��������� TreeView ����ʾ������, �����һ���յ� TreeNode
        If TypeOf sItem Is ICollection OrElse HasExpandableProperties(sItem) Then
            iNode.Nodes.Add(m_NodePlaceHolder)
        End If
        Return iNode
    End Function

    '�����û������ʵ����Ϣ, ����һ���򿪵����Ӷ���
    Private Function GetConnection() As ServerConnection
        Dim iConn As New ServerConnection
        With iConn
            .ServerInstance = Me.txtInstance.Text
            .LoginSecure = String.IsNullOrEmpty(Me.txtLogin.Text)
            If .LoginSecure = False Then
                .Login = Me.txtLogin.Text
                .Password = Me.txtPassword.Text
            End If
            .Connect()
        End With

        Return iConn
    End Function

    '�� TreeView ����ʾ SQL Server Instance �� Computer 
    Private Sub LoadTreeInstance()
        Me.treeInstance.Nodes.Clear()
        Dim mServer As New Server(GetConnection)
        '��� Server Instance ���
        Me.treeInstance.Nodes.Add( _
                CreateNode(String.Format(m_SQLServerNodeName, mServer.Name), mServer))
        '��� Computer Manager ���
        Me.treeInstance.Nodes.Add( _
                CreateNode(String.Format(m_ManagedComputerNodeName, mServer.Name), New ManagedComputer(mServer.Name)))
    End Sub

    'չ�� TreeNode, TreeNode ��Ӧ�Ķ���Ϊ ICollection
    Private Sub PopulateCollectionItems( _
            ByVal sNode As TreeNode)

        Dim iOldCursor As Cursor = Me.Cursor
        Me.Cursor = Cursors.WaitCursor
        Try
            For Each item As Object In CType(sNode.Tag, ICollection)
                sNode.Nodes.Add(CreateNode(item))
            Next
        Catch ex As Exception
            Dim iMsg As New ExceptionMessageBox(ex)
            iMsg.Show(Me)
        Finally
            Me.Cursor = iOldCursor
        End Try
    End Sub

    'չ�� TreeNode, TreeNode ��Ӧ�Ķ���Ϊ����
    Private Sub PopulateExpandableProperties( _
            ByVal sNode As TreeNode)

        Dim iOldCursor As Cursor = Me.Cursor
        Me.Cursor = Cursors.WaitCursor
        Try
            For Each iProperty As PropertyDescriptor In TypeDescriptor.GetProperties(sNode.Tag)
                If IsExpandableProperty(iProperty) = True Then
                    Try
                        sNode.Nodes.Add(CreateNode(iProperty.Name, iProperty.GetValue(sNode.Tag)))
                    Catch ex As Exception
                    End Try
                End If
            Next
        Catch ex As Exception
            Dim iMsg As New ExceptionMessageBox(ex)
            iMsg.Show(Me)
        Finally
            Me.Cursor = iOldCursor
        End Try
    End Sub


    '���ÿؼ��¼�, ʵ�� TreeNode �� PropertyGrid �е���ʾ
    '���� TreeView �е���ʾ��Ϣ
    Private Sub btnConnect_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnConnect.Click
        LoadTreeInstance()
    End Sub

    '���� PropertyGrid �е���ʾ
    Private Sub treeInstance_AfterSelect(ByVal sender As System.Object, ByVal e As System.Windows.Forms.TreeViewEventArgs) Handles treeInstance.AfterSelect
        Me.PropGrid.SelectedObject = e.Node.Tag
    End Sub

    'չ�� TreeNode
    Private Sub treeInstance_BeforeExpand(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewCancelEventArgs) Handles treeInstance.BeforeExpand
        Try
            If e.Node.Nodes.Count = 1 AndAlso e.Node.Nodes(0).Text = m_NodePlaceHolder Then
                e.Node.Nodes.RemoveAt(0)
                If TypeOf e.Node.Tag Is ICollection Then
                    PopulateCollectionItems(e.Node)
                Else
                    PopulateExpandableProperties(e.Node)
                End If
            End If
        Catch ex As Exception
            Dim iMsg As New ExceptionMessageBox(ex)
            iMsg.Show(Me)
        End Try
    End Sub
End Class