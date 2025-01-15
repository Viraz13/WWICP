<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%
   
    String chars = "0123456789";
    StringBuilder captcha = new StringBuilder();
    for (int i = 0; i < 6; i++) { 
        captcha.append(chars.charAt((int) (Math.random() * chars.length())));
    }
    session.setAttribute("captcha", captcha.toString());
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Wind World India</title>
<link rel="icon" href="img/favicon.ico" type="image/x-icon">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<style>
  body {
    background-image: url('img/dd.jpg');
    background-size: cover;
    background-position: center left;
    background-attachment: fixed;
    font-family: Arial, sans-serif;
    color: #fff;
  }
  .login-card {
    max-width: 400px;
    background: rgba(255, 255, 255, 0.9);
    margin: 80px auto;
    padding: 25px;
    border-radius: 15px;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
    color: #444;
    text-align: center;
  }
  .login-card .logo-container {
    display: flex;
    justify-content: center;
    align-items: center;
    margin-bottom: 20px;
  }
  .login-card .logo-container img {
    width: 150px; /* Adjust size as needed */
    height: auto;
  }
  .login-card h5 {
    font-weight: bold;
    margin-bottom: 20px;
    color: #333;
    text-align: center;
  }
  .form-control {
    border-radius: 30px;
    padding: 10px 15px;
    border: 1px solid #ced4da;
  }
  .btn-primary {
    background: #4caf50;
    border: none;
    border-radius: 30px;
    padding: 10px 15px;
    width: 100%;
    transition: all 0.3s;
    color: #fff;
    font-size: 16px;
  }
  .btn-primary:hover {
    background: #45a049;
  }
  .captcha-box {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-top: 30px;
  }
  .captcha-text {
    font-size: 20px;
    font-weight: bold;
    color: #fff;
    background: #4caf50;
    padding: 8px 19px;
    border-radius: 5px;
    border: 1px solid #3e8e41;
  }
  .refresh-captcha {
    font-size: 20px;
    color: #333;
    cursor: pointer;
  }
  .refresh-captcha:hover {
    color: #4caf50;
  }
</style>
</head>
<body>
<div class="login-card">
  <div class="logo-container">
    <img src="img/logo.png" alt="Wind World Logo"> <!-- Improved logo display -->
  </div>
  <form action="LoginServlet" method="post">
   <!--  <h5 class="text-center">Welcome to Wind World</h5> -->
    <div class="mb-3">
      <input type="text" name="userid" class="form-control" placeholder="UserID" required>
    </div>
    <div class="mb-3">
      <input type="password" name="password" class="form-control" placeholder="Password" required>
    </div>
    <div class="mb-3">
      <!-- CAPTCHA Section -->
      <div class="captcha-box">
        <span class="captcha-text"><%= session.getAttribute("captcha") %></span>
        <i class="fa fa-refresh refresh-captcha" onclick="location.reload()"></i> <!-- Refresh Icon -->
      </div>
      <input type="text" name="captcha" class="form-control mt-2" placeholder="Enter CAPTCHA" required>
    </div>
    <button type="submit" class="btn-primary">Login</button>
  </form>
</div>
</body>
</html>
