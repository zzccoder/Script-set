function sendEmail(strEmail_From, strEmail_To, strCC_List, strEmail_Subject, strEmail_Body)

     Set cdoMail = CreateObject("CDO.Message")  '����CDO����
     Set cdoConf = CreateObject("CDO.Configuration") '����CDO�����ļ�����
     cdoMail.From = strEmail_From
     cdoMail.To = strEmail_To
     cdoMail.CC = strCC_List
     cdoMail.Subject = strEmail_Subject
     cdoMail.HTMLbody = strEmail_Body & "</table></body></html>"
   
     cdoConf.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2    'ʹ�������ϵ�SMTP�����������Ǳ��ص�SMTP������
     'cdoConf.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "9.56.224.215"
     cdoConf.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "smtp.263.net"    'SMTP��������ַ, ���Ի���������Ҫ�õ��������������ip
     cdoConf.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25    '�ʼ��������˿�
     cdoConf.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1    '��������֤��ʽ
     cdoConf.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = "admin@happyinsurance.com.cn" '�������˺�
     cdoConf.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = "pass@word01"    '�����˵�½��������
     cdoConf.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 60    '���ӷ������ĳ�ʱʱ��
     cdoConf.Fields.Update  
     Set cdoMail.Configuration = cdoConf
     
     '�����ʼ�����Ҫ�Ⱥ����ȼ�
     cdoMail.Fields.Item("urn:schemas:mailheader:X-MSMail-Priority") = "High"
     cdoMail.Fields.Item("urn:schemas:mailheader:X-Priority") = 2 
     cdoMail.Fields.Item("urn:schemas:httpmail:importance") = 2 
     cdoMail.Fields.Update
     
     '�����ʼ�
     dim sleepSeconds     
     sleepSeconds = 5
     cdoMail.Send
     WScript.Sleep(1000 * sleepSeconds)
     
     Set cdoMail = nothing
     Set cdoConf = nothing
End Function

sendEmail "admin@happyinsurance.com.cn", "admin@happyinsurance.com.cn", "", "vbs�����ʼ�", "vbs�����ʼ�"