function sendEmail(strEmail_From, strEmail_To, strCC_List, strEmail_Subject, strEmail_Body)

     Set cdoMail = CreateObject("CDO.Message")  '创建CDO对象
     Set cdoConf = CreateObject("CDO.Configuration") '创建CDO配置文件对象
     cdoMail.From = strEmail_From
     cdoMail.To = strEmail_To
     cdoMail.CC = strCC_List
     cdoMail.Subject = strEmail_Subject
     cdoMail.HTMLbody = strEmail_Body & "</table></body></html>"
   
     cdoConf.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2    '使用网络上的SMTP服务器而不是本地的SMTP服务器
     'cdoConf.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "9.56.224.215"
     cdoConf.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "smtp.263.net"    'SMTP服务器地址, 可以换成其他你要用的邮箱服务器或者ip
     cdoConf.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25    '邮件服务器端口
     cdoConf.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1    '服务器认证方式
     cdoConf.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = "admin@happyinsurance.com.cn" '发件人账号
     cdoConf.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = "pass@word01"    '发件人登陆邮箱密码
     cdoConf.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 60    '连接服务器的超时时间
     cdoConf.Fields.Update  
     Set cdoMail.Configuration = cdoConf
     
     '设置邮件的重要度和优先级
     cdoMail.Fields.Item("urn:schemas:mailheader:X-MSMail-Priority") = "High"
     cdoMail.Fields.Item("urn:schemas:mailheader:X-Priority") = 2 
     cdoMail.Fields.Item("urn:schemas:httpmail:importance") = 2 
     cdoMail.Fields.Update
     
     '发送邮件
     dim sleepSeconds     
     sleepSeconds = 5
     cdoMail.Send
     WScript.Sleep(1000 * sleepSeconds)
     
     Set cdoMail = nothing
     Set cdoConf = nothing
End Function

sendEmail "admin@happyinsurance.com.cn", "admin@happyinsurance.com.cn", "", "vbs测试邮件", "vbs测试邮件"