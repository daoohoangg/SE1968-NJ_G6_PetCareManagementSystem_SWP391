package com.petcaresystem.service.email;
import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;

public class EmailService {
    private static String fromEmail = "hahshe186536@fpt.edu.vn";
    private static String appPassword = "qhbt asof xjdv xbpm";
    private static String smtpHost = "smtp.gmail.com";
    private static int smtpPort = 587;
    private static boolean smtpAuth = true;
    private static boolean startTlsEnable = true;

    public static String getFromEmail() {
        return fromEmail;
    }

    public static void setFromEmail(String email) {
        fromEmail = email;
    }

    public static String getAppPassword() {
        return appPassword;
    }

    public static void setAppPassword(String password) {
        appPassword = password;
    }

    public static String getSmtpHost() {
        return smtpHost;
    }

    public static void setSmtpHost(String host) {
        smtpHost = host;
    }

    public static int getSmtpPort() {
        return smtpPort;
    }

    public static void setSmtpPort(int port) {
        smtpPort = port;
    }

    public static boolean isSmtpAuth() {
        return smtpAuth;
    }

    public static void setSmtpAuth(boolean auth) {
        smtpAuth = auth;
    }

    public static boolean isStartTlsEnable() {
        return startTlsEnable;
    }

    public static void setStartTlsEnable(boolean enable) {
        startTlsEnable = enable;
    }

    public static void sendVerificationEmail(String recipientEmail, String token, String contextPath) {
        String subject = "[PetCare] Please verify your account.";
        String verificationLink = "http://localhost:8080" + contextPath + "/verify?token=" + token;
        String body = "<html>"
               + "<body>"
               + "<h2>Welcome to PetCare!</h2>"
                + "<p>Please click the link below to activate your account:</p>"
                + "<a href='" + verificationLink + "' style='padding: 10px 15px; background-color: #007bff; color: white; text-decoration: none; border-radius: 5px;'>"
                + "Activate Account"
                + "</a>"
                + "<p>If you did not register, please ignore this email.</p>"
                + "</body>"
                + "</html>";
        sendEmail(recipientEmail, subject, body);
   }
    public static void sendNewPasswordEmail(String recipientEmail, String newPassword) {
        String subject = "[PetCare] Your new password";
        String body = "<html>"
                + "<body>"
                + "<h2>Password Reset Request for PetCare</h2>"
                + "<p>Your new password is:</p>"
                + "<h3 style='padding: 10px; background-color: #f0f0f0; border-radius: 5px;'>"
               + newPassword
                + "</h3>"
               + "<p>Please log in and change your password immediately.</p>"
                + "</body>"
                + "</html>";
        sendEmail(recipientEmail, subject, body);
    }
    public static void sendContactFormEmail(String fromName, String fromEmail, String subject, String userMessage) {
        String recipientEmail = EmailService.fromEmail;
        String emailSubject = "[PetCare Contact Form] " + subject + " (From: " + fromName + ")";
        String body = "<html><body>"
                + "<h2>You have received a new message from the PetCare Contact Form:</h2>"
                + "<p><strong>From:</strong> " + fromName + "</p>"
                + "<p><strong>Sender's Email:</strong> " + fromEmail + "</p>"
                + "<p><strong>Subject:</strong> " + subject + "</p>"
                + "<h3>Nội dung:</h3>"
                + "<div style='padding: 15px; background-color: #f4f4f4; border-radius: 5px;'>"
                + "<p style='white-space: pre-wrap;'>" + userMessage + "</p>"
                + "</div>"
                + "</body></html>";
        sendEmail(recipientEmail, emailSubject, body);
    }

    private static void sendEmail(String to, String subject, String body) {
        Properties props = new Properties();
        props.put("mail.smtp.host", smtpHost);
        props.put("mail.smtp.port", String.valueOf(smtpPort));
        props.put("mail.smtp.auth", String.valueOf(smtpAuth));
        props.put("mail.smtp.starttls.enable", String.valueOf(startTlsEnable));

        Authenticator auth = new Authenticator() {
           protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, appPassword);
           }
        };
       Session session = Session.getInstance(props, auth);

        try {
           MimeMessage msg = new MimeMessage(session);

          msg.setFrom(new InternetAddress(fromEmail));
           msg.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
           msg.setSubject(subject, "UTF-8");

           msg.setContent(body, "text/html; charset=UTF-8");
           new Thread(() -> {
              try {
                   Transport.send(msg);
                   System.out.println("Email sent successfully to " + to);
                } catch (MessagingException e) {
                    System.err.println("Failed to send email: " + e.getMessage());
                    e.printStackTrace();
                }
            }).start();

       } catch (MessagingException e) {
            System.err.println("Failed to create email message: " + e.getMessage());
            e.printStackTrace();
       }
    }
}
