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
        Dim DataGridViewCellStyle1 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle
        Me.DataGridView1 = New System.Windows.Forms.DataGridView
        Me.SQL_Text = New System.Windows.Forms.TextBox
        Me.Status_List = New System.Windows.Forms.ListBox
        Me.Start_Button = New System.Windows.Forms.Button
        Me.Execute_Button = New System.Windows.Forms.Button
        Me.Stop_Button = New System.Windows.Forms.Button
        Me.Label1 = New System.Windows.Forms.Label
        CType(Me.DataGridView1, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'DataGridView1
        '
        Me.DataGridView1.AllowUserToAddRows = False
        Me.DataGridView1.AllowUserToDeleteRows = False
        Me.DataGridView1.AllowUserToOrderColumns = True
        DataGridViewCellStyle1.BackColor = System.Drawing.Color.FromArgb(CType(CType(224, Byte), Integer), CType(CType(224, Byte), Integer), CType(CType(224, Byte), Integer))
        Me.DataGridView1.AlternatingRowsDefaultCellStyle = DataGridViewCellStyle1
        Me.DataGridView1.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.DataGridView1.Location = New System.Drawing.Point(1, 12)
        Me.DataGridView1.Name = "DataGridView1"
        Me.DataGridView1.ReadOnly = True
        Me.DataGridView1.Size = New System.Drawing.Size(336, 366)
        Me.DataGridView1.TabIndex = 0
        '
        'SQL_Text
        '
        Me.SQL_Text.Location = New System.Drawing.Point(344, 32)
        Me.SQL_Text.Multiline = True
        Me.SQL_Text.Name = "SQL_Text"
        Me.SQL_Text.Size = New System.Drawing.Size(318, 109)
        Me.SQL_Text.TabIndex = 1
        '
        'Status_List
        '
        Me.Status_List.FormattingEnabled = True
        Me.Status_List.HorizontalScrollbar = True
        Me.Status_List.Location = New System.Drawing.Point(343, 173)
        Me.Status_List.Name = "Status_List"
        Me.Status_List.Size = New System.Drawing.Size(319, 199)
        Me.Status_List.TabIndex = 2
        '
        'Start_Button
        '
        Me.Start_Button.Location = New System.Drawing.Point(344, 148)
        Me.Start_Button.Name = "Start_Button"
        Me.Start_Button.Size = New System.Drawing.Size(78, 23)
        Me.Start_Button.TabIndex = 3
        Me.Start_Button.Text = "开始测试"
        Me.Start_Button.UseVisualStyleBackColor = True
        '
        'Execute_Button
        '
        Me.Execute_Button.Location = New System.Drawing.Point(584, 148)
        Me.Execute_Button.Name = "Execute_Button"
        Me.Execute_Button.Size = New System.Drawing.Size(78, 23)
        Me.Execute_Button.TabIndex = 3
        Me.Execute_Button.Text = "执行SQL"
        Me.Execute_Button.UseVisualStyleBackColor = True
        '
        'Stop_Button
        '
        Me.Stop_Button.Location = New System.Drawing.Point(428, 148)
        Me.Stop_Button.Name = "Stop_Button"
        Me.Stop_Button.Size = New System.Drawing.Size(78, 23)
        Me.Stop_Button.TabIndex = 3
        Me.Stop_Button.Text = "停止测试"
        Me.Stop_Button.UseVisualStyleBackColor = True
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(344, 13)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(134, 13)
        Me.Label1.TabIndex = 4
        Me.Label1.Text = "输入要执行的T-SQL脚本"
        '
        'Form1
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(666, 382)
        Me.Controls.Add(Me.Label1)
        Me.Controls.Add(Me.Execute_Button)
        Me.Controls.Add(Me.Stop_Button)
        Me.Controls.Add(Me.Start_Button)
        Me.Controls.Add(Me.Status_List)
        Me.Controls.Add(Me.SQL_Text)
        Me.Controls.Add(Me.DataGridView1)
        Me.Name = "Form1"
        Me.Text = "SQL Data Watch"
        CType(Me.DataGridView1, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents DataGridView1 As System.Windows.Forms.DataGridView
    Friend WithEvents SQL_Text As System.Windows.Forms.TextBox
    Friend WithEvents Status_List As System.Windows.Forms.ListBox
    Friend WithEvents Start_Button As System.Windows.Forms.Button
    Friend WithEvents Execute_Button As System.Windows.Forms.Button
    Friend WithEvents Stop_Button As System.Windows.Forms.Button
    Friend WithEvents Label1 As System.Windows.Forms.Label

End Class
