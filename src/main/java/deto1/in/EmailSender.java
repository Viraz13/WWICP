package deto1.in;

import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

public class EmailSender {
	 public static void sendEmail(String to, String ccList,String subject, String body) {
	        final String smtpHost = "172.18.16.43";
	        final int smtpPort = 25;
	        final String username = "om.sai";
	        final String password = "enercon";

	        Properties props = new Properties();
	        props.put("mail.smtp.host", smtpHost);
	        props.put("mail.smtp.port", smtpPort);
	        props.put("mail.smtp.auth", "true");
	        props.put("mail.smtp.starttls.enable", "false");
	        props.put("mail.smtp.ssl.enable", "false");

	        Session session = Session.getInstance(props, new Authenticator() {
	            protected PasswordAuthentication getPasswordAuthentication() {
	                return new PasswordAuthentication(username, password);
	            }
	        });

	        try {
	            Message message = new MimeMessage(session);
	            message.setFrom(new InternetAddress(username));
	            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
	            if (ccList != null && !ccList.trim().isEmpty()) {
	                message.setRecipients(Message.RecipientType.CC, InternetAddress.parse(ccList));
	            }
	            message.setSubject(subject);
	            message.setText(body);

	            Transport.send(message);
	            System.out.println("Email sent successfully!");
	            if (ccList != null) {
	                System.out.println("CC: " + ccList);
	            }
	        } catch (MessagingException e) {
	            System.err.println("Failed to send email: " + e.getMessage());
	            e.printStackTrace();
	        }
	    }
}
