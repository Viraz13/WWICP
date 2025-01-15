package deto1.in;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class ComplaintNotifier {
	private static final String DB_URL = "jdbc:mysql://localhost:3306/complaintportal?useSSL=false";
    private static final String USER = "ptl";
    private static final String PASSWORD = "root@123";

    public static void notifyUser(int id, String status) {
        String email = null, userName = null, description = null, additionalEmail = null;

        // Fetch complaint details
        try (Connection conn = DriverManager.getConnection(DB_URL, USER, PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(
                 "SELECT r.problem_description, l.email, r.user_name , r.user_mail_id " +
                 "FROM register r " +
                 "JOIN userdb.login l ON r.complaint_logged_by = l.userid " +
                 "WHERE r.id = ?")) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    description = rs.getString("problem_description");
                    email = rs.getString("email");
                    userName = rs.getString("user_name");
                    additionalEmail = rs.getString("user_mail_id");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return;
        }

        if (email == null || userName == null) {
            System.err.println("Failed to fetch user details for complaint ID: " + id);
            return;
        }
        String ccList = "Babrubahan.Sahoo@windworldindia.com";
       

        // Send email
        String subject = status.equals("OPEN") ? "Complaint Registered: " + id
                                               : "Complaint Resolved: " + id;
        String body = String.format(
        	    "<html>" +
        	    "<body>" +
        	    "<p>Dear <b>%s</b>,</p>" +
        	    "<p>Your complaint (Ticket ID: <b>%d</b>) has been <b style='color:black;'>%s</b>.</p>" +
        	    "<p>Details: <b>%s</b></p>" +
        	    "<p>Regards,<br>WWIL Support Team.</p>" +
        	    "<p><b>NOTE: </b>This is an automatically generated email. Please do not reply to this mail.</p>"+
        	   
                 "</body>" +
        	    "</html>",
        	    userName, id, status.equals("OPEN") ? "registered successfully" : "resolved", description
        	);
   
        	sendEmail(email, ccList, subject, body,additionalEmail );
    }

    public static void sendEmail(String to,String ccList, String subject, String body,String additionalTo) {
        final String smtpHost = "172.18.16.43";
        final int smtpPort = 25;
        final String username = "om.sai";
        final String password = "enercon";

        Properties props = new Properties();
        props.put("mail.smtp.host", smtpHost);
        props.put("mail.smtp.port", smtpPort);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(username, "WWIL Support"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            
            if (additionalTo != null && !additionalTo.trim().isEmpty()) {
                message.addRecipients(Message.RecipientType.TO, InternetAddress.parse(additionalTo));
            }
            
            if (ccList != null && !ccList.trim().isEmpty()) {
                message.setRecipients(Message.RecipientType.CC, InternetAddress.parse(ccList));
            }
            message.setSubject(subject);
            message.setContent(body, "text/html");
            Transport.send(message);
            System.out.println("Email sent successfully to: " + to);
            if (additionalTo != null) {
                System.out.println("Additional recipient: " + additionalTo);
            }
            if (ccList != null) {
                System.out.println("CC: " + ccList);
            }
        } catch (MessagingException | java.io.UnsupportedEncodingException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        // Example: Notify user of a new complaint
        notifyUser(101, "OPEN");

        // Example: Notify user of a resolved complaint
        notifyUser(101, "RESOLVED");
    }
}


