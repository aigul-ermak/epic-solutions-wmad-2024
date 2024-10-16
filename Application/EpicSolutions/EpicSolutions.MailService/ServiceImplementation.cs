using MailKit.Net.Smtp;
using MimeKit;
using static EpicSolutions.MailService.EmailSender;



namespace EpicSolutions.MailService
{
    public class EmailConfiguration
    {
        public string? From { get; set; }
        public string? SmtpServer { get; set; }
        public int Port { get; set; }
        public string? Username { get; set; }
        public string? Password { get; set; }
    }

    public interface IEmailSender
    {
        void SendEmail(EmailMessage email);
    }

    public class EmailSender : IEmailSender
    {
        private readonly EmailConfiguration _configuration;
        public EmailSender(EmailConfiguration emailConfiguration)
        {
            _configuration = emailConfiguration;
        }

        public class EmailMessage
        {
            public List<MailboxAddress> To { get; set; }
            public string? Subject { get; set; }
            public string? Content { get; set; }
            public EmailMessage(IEnumerable<string> to, string subject, string content)
            {
                To = new List<MailboxAddress>();
                To.AddRange(to.Select(x => new MailboxAddress(String.Empty, x)));
                Subject = subject;
                Content = content;
            }
        }

        private MimeMessage CreateEmailMessage(EmailMessage message)
        {
            var emailMessage = new MimeMessage();
            emailMessage.From.Add(new MailboxAddress(String.Empty, _configuration.From));
            emailMessage.To.AddRange(message.To);
            emailMessage.Subject = message.Subject;
            emailMessage.Body = new TextPart(MimeKit.Text.TextFormat.Text) { Text = message.Content };
            return emailMessage;
        }

        public void SendEmail(EmailMessage email)
        {
            var mimeMessage = CreateEmailMessage(email);

            using (var client = new SmtpClient())
            {
                // Warning: The following line bypasses SSL certificate validation. Do not use in production.
                client.ServerCertificateValidationCallback = (s, c, h, e) => true;

                try
                {
                    client.Connect(_configuration.SmtpServer, _configuration.Port);
                    client.Send(mimeMessage);
                }
                finally
                {
                    client.Disconnect(true);
                    client.Dispose();
                }
            }
        }

    }
}
