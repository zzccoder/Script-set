using System;
using System.Collections.Generic;
using System.Text;
using System.Net.Mail;

namespace BLL
{
    public static class Messager
    {
        // �ʼ���������ַ
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
        /// �����ʼ�


        /// </summary>
        /// <param name="to">�ռ����б�</param>
        /// <param name="from">������</param>
        /// <param name="subject">�ʼ�����</param>
        /// <param name="body">�ʼ�����</param>
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
                //myEmail.BodyFormat = this.Html?MailFormat.Html:MailFormat.Text; //�ʼ���ʽ��.Text��.Html 


                System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
                smtp.Host = Messager._mailDomain;
                smtp.Port = Messager._mailserverport;
                smtp.Credentials = new System.Net.NetworkCredential(Messager._username, Messager._password);
                //smtp.UseDefaultCredentials = true;
                //smtp.DeliveryMethod = System.Net.Mail.SmtpDeliveryMethod.Network;

                //������25�˿�(gmail:587)
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
        /// ������Ϣ������ʱȡ���˹��ܣ�
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
