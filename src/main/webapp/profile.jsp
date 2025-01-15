<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile Page</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
           background-image: url('img/mm.jpg');
            background-size: cover; 
            background-position: center left;
            background-attachment: fixed; 
        }
        .card {
            margin-top: 50px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }
        .card-header {
            background-color: #007bff; /* Bootstrap primary color */
            color: white;
            font-size: 1.5rem;
            font-weight: bold;
        }
        .table th, .table td {
            vertical-align: middle;
        }
        .btn-primary {
            background-color: #007bff;
            border-color: #007bff;
        }
        .btn-primary:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="card">
            <div class="card-header text-center">
                User Profile
            </div>
            <div class="card-body">
                <%
                    String userid = (String) session.getAttribute("userid");
                    if (userid == null) {
                        response.sendRedirect("login.jsp");
                    } else {
                        Connection con = null;
                        PreparedStatement ps = null;
                        ResultSet rs = null;
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/userdb", "ptl", "root@123");
                            ps = con.prepareStatement("SELECT uname, email, role FROM login WHERE userid = ?");
                            ps.setString(1, userid);
                            rs = ps.executeQuery();
                            if (rs.next()) {
                %>
                <table class="table table-bordered">
                   <!--  <thead class="table-light">
                        <tr>
                            <th>Field</th>
                            <th>Details</th>
                        </tr>
                    </thead> -->
                    <tbody>
                        <tr>
                            <th scope="row">Name :</th>
                            <td><%= rs.getString("uname") %></td>
                        </tr>
                        <tr>
                            <th scope="row">Employee ID :</th>
                            <td><%= userid %></td>
                        </tr>
                        <tr>
                            <th scope="row">Email :</th>
                            <td><%= rs.getString("email") %></td>
                        </tr>
                        <tr>
                            <th scope="row">Role :</th>
                            <td><%= rs.getString("role") %></td>
                        </tr>
                    </tbody>
                </table>
                <% 
                            }
                        } catch (Exception e) {
                            out.println("Error: " + e.getMessage());
                        } finally {
                            if (rs != null) rs.close();
                            if (ps != null) ps.close();
                            if (con != null) con.close();
                        }
                    }
                %>
            </div>
            <div class="card-footer text-center">
                <a href="graphuser.jsp" class="btn btn-primary">Back to Home</a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
