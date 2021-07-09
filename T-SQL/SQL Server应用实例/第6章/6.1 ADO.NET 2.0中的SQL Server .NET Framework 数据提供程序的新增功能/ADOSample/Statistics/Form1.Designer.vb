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
        Me.TextBox1 = New System.Windows.Forms.TextBox
        Me.PriveExecute_Button = New System.Windows.Forms.Button
        Me.DataGridView1 = New System.Windows.Forms.DataGridView
        Me.Label1 = New System.Windows.Forms.Label
        Me.Label2 = New System.Windows.Forms.Label
        Me.CommonExecute_Button = New System.Windows.Forms.Button
        Me.CloseCommConnection_Button = New System.Windows.Forms.Button
        Me.ResetStatistics_Check = New System.Windows.Forms.CheckBox
        CType(Me.DataGridView1, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'TextBox1
        '
        Me.TextBox1.Location = New System.Drawing.Point(264, 30)
        Me.TextBox1.Multiline = True
        Me.TextBox1.Name = "TextBox1"
        Me.TextBox1.Size = New System.Drawing.Size(291, 393)
        Me.TextBox1.TabIndex = 1
        '
        'PriveExecute_Button
        '
        Me.PriveExecute_Button.Location = New System.Drawing.Point(264, 429)
        Me.PriveExecute_Button.Name = "PriveExecute_Button"
        Me.PriveExecute_Button.Size = New System.Drawing.Size(94, 23)
        Me.PriveExecute_Button.TabIndex = 2
        Me.PriveExecute_Button.Text = "使用私有连接"
        Me.PriveExecute_Button.UseVisualStyleBackColor = True
        '
        'DataGridView1
        '
        Me.DataGridView1.AllowUserToAddRows = False
        Me.DataGridView1.AllowUserToDeleteRows = False
        Me.DataGridView1.AllowUserToOrderColumns = True
        Me.DataGridView1.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.DataGridView1.Location = New System.Drawing.Point(12, 30)
        Me.DataGridView1.Name = "DataGridView1"
        Me.DataGridView1.ReadOnly = True
        Me.DataGridView1.Size = New System.Drawing.Size(246, 422)
        Me.DataGridView1.TabIndex = 3
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(13, 13)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(55, 13)
        Me.Label1.TabIndex = 4
        Me.Label1.Text = "统计信息"
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(261, 13)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(134, 13)
        Me.Label2.TabIndex = 5
        Me.Label2.Text = "输入要执行的T-SQL语句"
        '
        'CommonExecute_Button
        '
        Me.CommonExecute_Button.Location = New System.Drawing.Point(379, 429)
        Me.CommonExecute_Button.Name = "CommonExecute_Button"
        Me.CommonExecute_Button.Size = New System.Drawing.Size(94, 23)
        Me.CommonExecute_Button.TabIndex = 2
        Me.CommonExecute_Button.Text = "使用公用连接"
        Me.CommonExecute_Button.UseVisualStyleBackColor = True
        '
        'CloseCommConnection_Button
        '
        Me.CloseCommConnection_Button.Location = New System.Drawing.Point(480, 429)
        Me.CloseCommConnection_Button.Name = "CloseCommConnection_Button"
        Me.CloseCommConnection_Button.Size = New System.Drawing.Size(75, 23)
        Me.CloseCommConnection_Button.TabIndex = 6
        Me.CloseCommConnection_Button.Text = "关闭公用连接"
        Me.CloseCommConnection_Button.UseVisualStyleBackColor = True
        '
        'ResetStatistics_Check
        '
        Me.ResetStatistics_Check.AutoSize = True
        Me.ResetStatistics_Check.Location = New System.Drawing.Point(379, 458)
        Me.ResetStatistics_Check.Name = "ResetStatistics_Check"
        Me.ResetStatistics_Check.Size = New System.Drawing.Size(74, 17)
        Me.ResetStatistics_Check.TabIndex = 7
        Me.ResetStatistics_Check.Text = "重新统计"
        Me.ResetStatistics_Check.UseVisualStyleBackColor = True
        '
        'Form1
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(561, 478)
        Me.Controls.Add(Me.ResetStatistics_Check)
        Me.Controls.Add(Me.CloseCommConnection_Button)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.Label1)
        Me.Controls.Add(Me.DataGridView1)
        Me.Controls.Add(Me.CommonExecute_Button)
        Me.Controls.Add(Me.PriveExecute_Button)
        Me.Controls.Add(Me.TextBox1)
        Me.Name = "Form1"
        Me.Text = "Statictics Info"
        CType(Me.DataGridView1, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents TextBox1 As System.Windows.Forms.TextBox
    Friend WithEvents PriveExecute_Button As System.Windows.Forms.Button
    Friend WithEvents DataGridView1 As System.Windows.Forms.DataGridView
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents CommonExecute_Button As System.Windows.Forms.Button
    Friend WithEvents CloseCommConnection_Button As System.Windows.Forms.Button
    Friend WithEvents ResetStatistics_Check As System.Windows.Forms.CheckBox

End Class
