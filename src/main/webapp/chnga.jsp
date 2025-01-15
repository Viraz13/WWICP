<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>

<%@ page import="deto1.logindao.*" %>
<%@ page import="deto1.web.*" %>
<%
   
    String errorMessage = null;
    String successMessage = null;

    
    String userid = (String) session.getAttribute("userid");
    if (userid == null) {
        response.sendRedirect("login.jsp"); 
    }

    if (request.getMethod().equalsIgnoreCase("POST")) {
        // Retrieve form data
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (newPassword.equals(confirmPassword)) {
            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            try {
                
                Class.forName("com.mysql.cj.jdbc.Driver"); 
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/userdb", "ptl", "root@123");

                
                String validateQuery = "SELECT * FROM login WHERE userid = ? AND password = ?";
                ps = con.prepareStatement(validateQuery);
                ps.setString(1, userid);
                ps.setString(2, currentPassword);
                rs = ps.executeQuery();

                if (rs.next()) {
                    
                    String updateQuery = "UPDATE login SET password = ? WHERE userid = ?";
                    ps = con.prepareStatement(updateQuery);
                    ps.setString(1, newPassword);
                    ps.setString(2, userid);
                    int updated = ps.executeUpdate();

                    if (updated > 0) {
                        successMessage = "Password updated successfully!";
                    } else {
                        errorMessage = "Failed to update password. Please try again.";
                    }
                } else {
                    errorMessage = "Current password is incorrect.";
                }
            } catch (Exception e) {
                e.printStackTrace();
                errorMessage = "An error occurred: " + e.getMessage();
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (con != null) con.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        } else {
            errorMessage = "New password and confirm password do not match.";
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="img/favicon.ico" type="image/x-icon">
    <title>Change Password</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-image: url('img/sbg1.jpeg');
    background-size: cover;
    background-position: center;
    background-attachment: fixed;
    position: relative;
        }
        .container {
            max-width: 500px;
            margin: 0 auto;
            margin-top: 5%;
            background: #ffffff; /* White form container */
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }
        .form-label {
            font-weight: bold;
            color: #555; /* Softer font color for labels */
        }
        .form-control {
            border-radius: 6px;
            padding: 12px 15px;
            font-size: 1rem;
            border: 1px solid #ced4da;
        }
        .btn-primary {
            background-color: #007bff; /* Bootstrap default blue */
            border-color: #007bff;
            padding: 12px 15px;
            font-size: 1rem;
            border-radius: 6px;
            width: 100%;
        }
        .btn-primary:hover {
            background-color: #0056b3;
        }
        h2 {
            text-align: center;
            margin-bottom: 20px;
            font-weight: bold;
            color: #333;
        }
        .alert {
            font-size: 0.9rem;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <!-- Include Header -->
    <jsp:include page="hdr2.html" />  

    <div class="container">
        <h2>Change Password</h2>
        <% if (errorMessage != null) { %>
            <div class="alert alert-danger"><%= errorMessage %></div>
        <% } %>
        <% if (successMessage != null) { %>
            <div class="alert alert-success"><%= successMessage %></div>
            <script>
                
                setTimeout(function() {
                    window.location.href = 'graph.jsp';
                }, 2000); 
            </script>
        <% } %>
        <form method="post" action="chnga.jsp">
            <div class="mb-3">
                <label for="currentPassword" class="form-label">Current Password</label>
                <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
            </div>
            <div class="mb-3">
                <label for="newPassword" class="form-label">New Password</label>
                <input type="password" class="form-control" id="newPassword" name="newPassword" required>
            </div>
            <div class="mb-3">
                <label for="confirmPassword" class="form-label">Confirm New Password</label>
                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
            </div>
            <button type="submit" class="btn btn-primary">Change Password</button>
        </form>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
