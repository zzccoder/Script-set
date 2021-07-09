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
        Me.TableLayoutPanel1 = New System.Windows.Forms.TableLayoutPanel
        Me.Data_Tab = New System.Windows.Forms.TabControl
        Me.SQL_Text = New System.Windows.Forms.TextBox
        Me.Execute_Command = New System.Windows.Forms.Button
        Me.Clear_Command = New System.Windows.Forms.Button
        Me.TableLayoutPanel1.SuspendLayout()
        Me.SuspendLayout()
        '
        'TableLayoutPanel1
        '
        Me.TableLayoutPanel1.ColumnCount = 2
        Me.TableLayoutPanel1.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 150.0!))
        Me.TableLayoutPanel1.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle)
        Me.TableLayoutPanel1.Controls.Add(Me.Data_Tab, 0, 2)
        Me.TableLayoutPanel1.Controls.Add(Me.SQL_Text, 1, 0)
        Me.TableLayoutPanel1.Controls.Add(Me.Execute_Command, 0, 0)
        Me.TableLayoutPanel1.Controls.Add(Me.Clear_Command, 0, 1)
        Me.TableLayoutPanel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.TableLayoutPanel1.Location = New System.Drawing.Point(0, 0)
        Me.TableLayoutPanel1.Name = "TableLayoutPanel1"
        Me.TableLayoutPanel1.RowCount = 2
        Me.TableLayoutPanel1.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 30.0!))
        Me.TableLayoutPanel1.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 30.0!))
        Me.TableLayoutPanel1.RowStyles.Add(New System.Windows.Forms.RowStyle)
        Me.TableLayoutPanel1.Size = New System.Drawing.Size(409, 314)
        Me.TableLayoutPanel1.TabIndex = 0
        '
        'Data_Tab
        '
        Me.TableLayoutPanel1.SetColumnSpan(Me.Data_Tab, 2)
        Me.Data_Tab.Dock = System.Windows.Forms.DockStyle.Fill
        Me.Data_Tab.Location = New System.Drawing.Point(3, 63)
        Me.Data_Tab.Name = "Data_Tab"
        Me.Data_Tab.SelectedIndex = 0
        Me.Data_Tab.Size = New System.Drawing.Size(403, 248)
        Me.Data_Tab.TabIndex = 0
        '
        'SQL_Text
        '
        Me.SQL_Text.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SQL_Text.Location = New System.Drawing.Point(153, 3)
        Me.SQL_Text.Multiline = True
        Me.SQL_Text.Name = "SQL_Text"
        Me.TableLayoutPanel1.SetRowSpan(Me.SQL_Text, 2)
        Me.SQL_Text.Size = New System.Drawing.Size(253, 54)
        Me.SQL_Text.TabIndex = 1
        '
        'Execute_Command
        '
        Me.Execute_Command.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Execute_Command.Location = New System.Drawing.Point(3, 3)
        Me.Execute_Command.Name = "Execute_Command"
        Me.Execute_Command.Size = New System.Drawing.Size(144, 23)
        Me.Execute_Command.TabIndex = 2
        Me.Execute_Command.Text = "执行输入的T-SQL"
        Me.Execute_Command.UseVisualStyleBackColor = True
        '
        'Clear_Command
        '
        Me.Clear_Command.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Clear_Command.Location = New System.Drawing.Point(3, 33)
        Me.Clear_Command.Name = "Clear_Command"
        Me.Clear_Command.Size = New System.Drawing.Size(144, 23)
        Me.Clear_Command.TabIndex = 3
        Me.Clear_Command.Text = "清理执行结果"
        Me.Clear_Command.UseVisualStyleBackColor = True
        '
        'Form1
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(409, 314)
        Me.Controls.Add(Me.TableLayoutPanel1)
        Me.Name = "Form1"
        Me.Text = "Async Execute"
        Me.TableLayoutPanel1.ResumeLayout(False)
        Me.TableLayoutPanel1.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents TableLayoutPanel1 As System.Windows.Forms.TableLayoutPanel
    Friend WithEvents Data_Tab As System.Windows.Forms.TabControl
    Friend WithEvents SQL_Text As System.Windows.Forms.TextBox
    Friend WithEvents Execute_Command As System.Windows.Forms.Button
    Friend WithEvents Clear_Command As System.Windows.Forms.Button

End Class
