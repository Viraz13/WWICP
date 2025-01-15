<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // Check if the user session is active
    String username = (String) session.getAttribute("userid");
    if (username == null) {
        // If no valid session, redirect to an error page
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Case Statistics Graph</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="icon" href="img/favicon.ico" type="image/x-icon">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        body {
            background-image: url('img/sbg1.jpeg');
    background-size: cover;
    background-position: center;
    background-attachment: fixed;
    position: relative;
        }

        .container {
            background: #ffffff;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            padding: 40px;
            max-width: 800px;
            margin: 20px auto;
        }

        h2 {
            font-size: 2rem;
            font-weight: bold;
            text-align: center;
            margin-bottom: 20px;
            color: #4a4a4a;
        }

        .chart-box {
            padding: 20px;
            background: #f8f9fa;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

           .total-cases {
            text-align: center;
           
            
           font-size: 1.5rem;
            font-weight: bold;
            margin-bottom: 20px;
            
        }
        
         .total-cases a{
          text-decoration: none;
         color: #d60f4e;
         }
        canvas {
            max-width: 100%;
            margin: 0 auto;
        }

        footer {
            text-align: center;
            margin-top: 30px;
            font-size: 0.9rem;
            color: #6c757d;
        }
    </style>
</head>
<body>
<%@ page import="deto1.in.UserDao" %>

<jsp:include page="header1.html"></jsp:include>

<%
    String loggedInUser = (String) session.getAttribute("userid");
    String role = (String) session.getAttribute("role");

    // Fetch case counts
    int totalCases = UserDao.getTotalCount(loggedInUser, role);
    int openCases = UserDao.getCountByStatus("OPEN", loggedInUser, role);
    int resolvedCases = UserDao.getCountByStatus("RESOLVED", loggedInUser, role);
    int waitingVendor = UserDao.getCountByStatus("Waiting on vendor", loggedInUser, role);
    int workingProcess = UserDao.getCountByStatus("Working in process", loggedInUser, role);
%>

<div class="container">
 


    <div class="chart-box">
     <div class="total-cases">
        <a href="Adminveiw.jsp">Total Cases: <%= totalCases %></a>
    </div>
        <canvas id="donutChart"></canvas>
    </div>
</div>

<footer>© 2024 Case Management System. All Rights Reserved.</footer>

<script>
    const ctx = document.getElementById('donutChart').getContext('2d');
    const donutChart = new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: ['Open Cases', 'Resolved Cases', 'Waiting on Vendor', 'Working in Process'],
            datasets: [{
                data: [<%= openCases %>, <%= resolvedCases %>, <%= waitingVendor %>, <%= workingProcess %>],
                backgroundColor: ['#f6c23e', '#1cc88a', '#e74a3b', '#0f0a46'],
                hoverBackgroundColor: ['#d6a20f', '#17a673', '#c62b22', '#0d4303'],
                borderWidth: 1
            }]
        },
        options: {
            plugins: {
                legend: {
                    position: 'top',
                    labels: {
                        color: '#333',
                        font: {
                            size: 14
                        }
                    }
                }
            },
            onClick: function(event, elements) {
                if (elements.length > 0) {
                    const chartElement = elements[0];
                    const label = donutChart.data.labels[chartElement.index];
                    
                    // Handle navigation for specific categories
                    if (label === 'Open Cases') {
                        window.location.href = 'opencase.jsp';
                    } else if (label === 'Resolved Cases') {
                        window.location.href = 'resloved.jsp';
                    } else if (label === 'Waiting on Vendor') {
                        window.location.href = 'wov.jsp';
                    } else if (label === 'Working in Process') {
                        window.location.href = 'wop.jsp';
                    }
                }
            }
        }
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
