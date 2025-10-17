package com.petcaresystem.service.email;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;

public class EmailService {
    private static final String FROM_EMAIL = "hahshe186536@fpt.edu.vn";
    private static final String APP_PASSWORD = "qhbt asof xjdv xbpm";

    public static void sendVerificationEmail(String recipientEmail, String token, String contextPath) {
        String subject = "[PetCare] Vui long xac thuc tai khoan cua ban";
        String verificationLink = "http://localhost:8080" + contextPath + "/verify?token=" + token;
        String body = "<html>"
                + "<body>"
                + "<h2>Chao mung ban den voi PetCare!</h2>"
                + "<p>Vui long nhan vao duong link duoi day de kich hoat tai khoan cua ban:</p>"
                + "<a href='" + verificationLink + "' style='padding: 10px 15px; background-color: #007bff; color: white; text-decoration: none; border-radius: 5px;'>"
                + "Kich Hoat Tai Khoan"
                + "</a>"
                + "<p>Neu ban khong dang ky, vui long bo qua email nay.</p>"
                + "</body>"
                + "</html>";
        sendEmail(recipientEmail, subject, body);
    }

    private static void sendEmail(String to, String subject, String body) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Authenticator auth = new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL,APP_PASSWORD);
            }
        };

        Session session = Session.getInstance(props, auth);

        try {
            MimeMessage msg = new MimeMessage(session);

            msg.setFrom(new InternetAddress(FROM_EMAIL));
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
