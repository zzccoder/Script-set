using System;
using System.Collections.Generic;
using System.Text;
using System.Net.Mail;

namespace BLL
{
    public static class Messager
    {
        // 邮件服务器地址
        private static string _mailDomain;
        private static bool _html = true;
        private static string _from;
        private static string _fromName;
        private static int _mailserverport = 25;
        private static string _username;
        private static string _password;
        static Messager()
        {
            Messager._mailDomain = System.Configuration.ConfigurationSettings.AppSettings["SmtpServer"].ToString();
            Messager._from = System.Configuration.ConfigurationSettings.AppSettings["SendUser"].ToString();
            Messager._fromName = System.Configuration.ConfigurationSettings.AppSettings["SendUserName"].ToString(); ;
            Messager._username = System.Configuration.ConfigurationSettings.AppSettings["SendUser"].ToString();
            Messager._password = System.Configuration.ConfigurationSettings.AppSettings["SendPassword"].ToString();        
            //Messager.SmtpServerAddress = System.Configuration.ConfigurationSettings.AppSettings["SmtpServer"].ToString();
        }

        /// <summary>
        /// 发送邮件


        /// </summary>
        /// <param name="to">收件人列表</param>
        /// <param name="from">发件人</param>
        /// <param name="subject">邮件主题</param>
        /// <param name="body">邮件内容</param>
        public static void SendMail(string[] to, string from,string UserName, string subject, string body)
        {
            if (!string.IsNullOrEmpty(_mailDomain))
            {
                System.Net.Mail.MailMessage myEmail = new System.Net.Mail.MailMessage();
                Encoding eEncod = Encoding.GetEncoding("utf-8");
                myEmail.From = new System.Net.Mail.MailAddress(Messager._from, Messager._fromName, eEncod);
                foreach (string address in to)
                {
                    myEmail.To.Add(address);
                }
                //myEmail.To.Add(this._recipient);
                myEmail.Subject = subject;
               
                myEmail.IsBodyHtml = true;
                myEmail.Body = body;
                myEmail.Priority = System.Net.Mail.MailPriority.Normal;
                myEmail.BodyEncoding = Encoding.GetEncoding("utf-8");
                //myEmail.BodyFormat = this.Html?MailFormat.Html:MailFormat.Text; //邮件形式，.Text、.Html 


                System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
                smtp.Host = Messager._mailDomain;
                smtp.Port = Messager._mailserverport;
                smtp.Credentials = new System.Net.NetworkCredential(Messager._username, Messager._password);
                //smtp.UseDefaultCredentials = true;
                //smtp.DeliveryMethod = System.Net.Mail.SmtpDeliveryMethod.Network;

                //当不是25端口(gmail:587)
                if (Messager._mailserverport != 25)
                {
                    smtp.EnableSsl = true;
                }
                //System.Web.Mail.SmtpMail.SmtpServer = this.MailDomain;
                try
                {
                    smtp.Send(myEmail);
                }
                catch (System.Net.Mail.SmtpException e)
                {
                    
                }
            }
            else
            {
                
            }

            /*
            MailMessage mail = new MailMessage();

            MailAddress addresser = new MailAddress(from,UserName);
            mail.From = addresser;
            foreach (string address in to)
            {
                mail.To.Add(new MailAddress(address));
            }
            mail.Subject = subject;
            mail.Body = body;            

            SmtpClient smtp = new SmtpClient(Messager.SmtpServerAddress);
            try
            {
                smtp.Send(mail);
            }
            catch
            {
            }*/
        }

        /// <summary>
        /// 发送消息。（暂时取消此功能）
        /// </summary>
        /// <param name="to"></param>
        /// <param name="from"></param>
        /// <param name="subject"></param>
        /// <param name="content"></param>
        public static void SendMessage(string to, string from, string subject, string content)
        {
            //throw new System.NotImplementedException();
        }

    }// class end
}
