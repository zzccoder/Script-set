<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class Form1
    Inherits System.Windows.Forms.Form

    'Form 重写 Dispose，以清理组件列表。
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing AndAlso components IsNot Nothing Then
            components.Dispose()
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Windows 窗体设计器所必需的
    Private components As System.ComponentModel.IContainer

    '注意: 以下过程是 Windows 窗体设计器所必需的
    '可以使用 Windows 窗体设计器修改它。
    '不要使用代码编辑器修改它。
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.ServerInfo = New System.Windows.Forms.GroupBox
        Me.text_Password = New System.Windows.Forms.TextBox
        Me.Label3 = New System.Windows.Forms.Label
        Me.text_Database = New System.Windows.Forms.TextBox
        Me.Label4 = New System.Windows.Forms.Label
        Me.text_Login = New System.Windows.Forms.TextBox
        Me.Label2 = New System.Windows.Forms.Label
        Me.text_Instance = New System.Windows.Forms.TextBox
        Me.Label1 = New System.Windows.Forms.Label
        Me.cmd_Save = New System.Windows.Forms.Button
        Me.cmd_Add = New System.Windows.Forms.Button
        Me.cmd_VerifyData = New System.Windows.Forms.Button
        Me.DataGridView1 = New System.Windows.Forms.DataGridView
        Me.ServerInfo.SuspendLayout()
        CType(Me.DataGridView1, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'ServerInfo
        '
        Me.ServerInfo.Controls.Add(Me.text_Password)
        Me.ServerInfo.Controls.Add(Me.Label3)
        Me.ServerInfo.Controls.Add(Me.text_Database)
        Me.ServerInfo.Controls.Add(Me.Label4)
        Me.ServerInfo.Controls.Add(Me.text_Login)
        Me.ServerInfo.Controls.Add(Me.Label2)
        Me.ServerInfo.Controls.Add(Me.text_Instance)
        Me.ServerInfo.Controls.Add(Me.Label1)
        Me.ServerInfo.Location = New System.Drawing.Point(12, 12)
        Me.ServerInfo.Name = "ServerInfo"
        Me.ServerInfo.Size = New System.Drawing.Size(298, 99)
        Me.ServerInfo.TabIndex = 0
        Me.ServerInfo.TabStop = False
        Me.ServerInfo.Text = "服务器信息"
        '
        'text_Password
        '
        Me.text_Password.Location = New System.Drawing.Point(204, 45)
        Me.text_Password.Name = "text_Password"
        Me.text_Password.PasswordChar = Global.Microsoft.VisualBasic.ChrW(42)
        Me.text_Password.Size = New System.Drawing.Size(85, 20)
        Me.text_Password.TabIndex = 1
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(155, 48)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(31, 13)
        Me.Label3.TabIndex = 0
        Me.Label3.Text = "密码"
        '
        'text_Database
        '
        Me.text_Database.Location = New System.Drawing.Point(57, 71)
        Me.text_Database.Name = "text_Database"
        Me.text_Database.Size = New System.Drawing.Size(232, 20)
        Me.text_Database.TabIndex = 1
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Location = New System.Drawing.Point(8, 74)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(43, 13)
        Me.Label4.TabIndex = 0
        Me.Label4.Text = "库    名"
        '
        'text_Login
        '
        Me.text_Login.Location = New System.Drawing.Point(57, 45)
        Me.text_Login.Name = "text_Login"
        Me.text_Login.Size = New System.Drawing.Size(85, 20)
        Me.text_Login.TabIndex = 1
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(8, 48)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(43, 13)
        Me.Label2.TabIndex = 0
        Me.Label2.Text = "登录名"
        '
        'text_Instance
        '
        Me.text_Instance.Location = New System.Drawing.Point(57, 19)
        Me.text_Instance.Name = "text_Instance"
        Me.text_Instance.Size = New System.Drawing.Size(232, 20)
        Me.text_Instance.TabIndex = 1
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(8, 22)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(43, 13)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "实例名"
        '
        'cmd_Save
        '
        Me.cmd_Save.Location = New System.Drawing.Point(330, 50)
        Me.cmd_Save.Name = "cmd_Save"
        Me.cmd_Save.Size = New System.Drawing.Size(92, 23)
        Me.cmd_Save.TabIndex = 1
        Me.cmd_Save.Text = "存储信息"
        Me.cmd_Save.UseVisualStyleBackColor = True
        '
        'cmd_Add
        '
        Me.cmd_Add.Location = New System.Drawing.Point(330, 21)
        Me.cmd_Add.Name = "cmd_Add"
        Me.cmd_Add.Size = New System.Drawing.Size(92, 23)
        Me.cmd_Add.TabIndex = 2
        Me.cmd_Add.Text = "添加信息"
        Me.cmd_Add.UseVisualStyleBackColor = True
        '
        'cmd_VerifyData
        '
        Me.cmd_VerifyData.Location = New System.Drawing.Point(330, 83)
        Me.cmd_VerifyData.Name = "cmd_VerifyData"
        Me.cmd_VerifyData.Size = New System.Drawing.Size(92, 23)
        Me.cmd_VerifyData.TabIndex = 2
        Me.cmd_VerifyData.Text = "验证信息"
        Me.cmd_VerifyData.UseVisualStyleBackColor = True
        '
        'DataGridView1
        '
        Me.DataGridView1.AllowUserToAddRows = False
        Me.DataGridView1.AllowUserToDeleteRows = False
        Me.DataGridView1.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.DataGridView1.Location = New System.Drawing.Point(12, 117)
        Me.DataGridView1.Name = "DataGridView1"
        Me.DataGridView1.ReadOnly = True
        Me.DataGridView1.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
        Me.DataGridView1.Size = New System.Drawing.Size(410, 150)
        Me.DataGridView1.TabIndex = 3
        '
        'Form1
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(434, 273)
        Me.Controls.Add(Me.DataGridView1)
        Me.Controls.Add(Me.cmd_VerifyData)
        Me.Controls.Add(Me.cmd_Add)
        Me.Controls.Add(Me.cmd_Save)
        Me.Controls.Add(Me.ServerInfo)
        Me.Name = "Form1"
        Me.Text = "CLR用户定义类型使用测试"
        Me.ServerInfo.ResumeLayout(False)
        Me.ServerInfo.PerformLayout()
        CType(Me.DataGridView1, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents ServerInfo As System.Windows.Forms.GroupBox
    Friend WithEvents text_Instance As System.Windows.Forms.TextBox
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents text_Password As System.Windows.Forms.TextBox
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents text_Database As System.Windows.Forms.TextBox
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents text_Login As System.Windows.Forms.TextBox
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents cmd_Save As System.Windows.Forms.Button
    Friend WithEvents cmd_Add As System.Windows.Forms.Button
    Friend WithEvents cmd_VerifyData As System.Windows.Forms.Button
    Friend WithEvents DataGridView1 As System.Windows.Forms.DataGridView

End Class
