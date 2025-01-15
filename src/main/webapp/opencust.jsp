<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Wind World India</title>
<link rel="icon" href="img/favicon.ico" type="image/x-icon">

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Include DataTables Bootstrap 5 CSS -->
<link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet">

<style>
     body {
            background-image: url('img/sbg1.jpeg');
    background-size: cover;
    background-position: center;
    background-attachment: fixed;
    position: relative;
        }

    .container {
        margin-top: 30px;
    }

    h2 {
        color: #007bff;
        font-weight: bold;
        text-align: center;
        margin-bottom: 30px;
    }

    .table-responsive {
        background-color: #ffffff;
        padding: 20px;
        border-radius: 15px;
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
    }

    .dataTable thead th {
        background-color: #000 !important;
        color: #fff !important;
        text-align: center;
    }

    .dataTable tbody td {
        text-align: center;
    }

    .dataTable tbody tr:hover {
        background-color: #f1f1f1;
    }

    .dataTable .pagination {
        justify-content: center;
    }
    .table th, .table td {
        padding: 10px;
        vertical-align: middle;
        text-align: center;
        border: 1px solid #dee2e6;
        white-space: nowrap; /* Prevent long text from wrapping */
    }

    .table tbody tr:nth-child(even) {
        background-color: #f9f9f9;
    }

    .table tbody tr:hover {
        background-color: #eaf4fc;
    }

    .btn {
        border-radius: 50px;
        font-size: 12px;
        padding: 6px 12px;
    }

    .btn-success, .btn-danger {
        font-size: 12px;
        padding: 6px 12px;
    }

    .btn:hover {
        opacity: 0.9;
    }

    .pagination {
        margin-top: 20px;
    }

    .pagination .page-link {
        color: #007bff;
        font-size: 14px;
    }

    .page-item.active .page-link {
        background-color: #007bff;
        border-color: #007bff;
    }

    .text-end img {
        margin-right: 5px;
    }

    /* Responsive Design */
    @media (max-width: 768px) {
        .table th, .table td {
            font-size: 12px;
            padding: 8px;
        }

        .btn {
            font-size: 10px;
            padding: 5px 8px;
        }
    }
</style>
</head>
<body>
<%@page import="deto1.in.UserDao,deto1.in.*,java.util.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<jsp:include page="header.html"></jsp:include>

<section>

    

       
    <div class="container">
        <h2>Case Log Details</h2>
		<%
String loggedInUser = (String) session.getAttribute("userid");
String role = (String) session.getAttribute("role");

if (loggedInUser == null || role == null) {
    response.sendRedirect("login.jsp");
} else {
    List<User> openCases = UserDao.getOpenCases(loggedInUser, role);
    request.setAttribute("openCases", openCases);
}
%>
        
            <div class="text-end mb-3">
        <a href="openexcel.jsp" class="btn btn-danger btn-sm">
            <img height="18" width="18" src="img/exc.png"> Export Excel
        </a>
    </div>
        <div class="table-responsive">
            <table id="caseLogTable" class="table table-striped table-bordered">
                <thead>
                    <tr>
                        <th>Id</th>
                        <th>User Name</th>
                        <th>Location</th>
                        <th>State</th>
                        <th>Related Type</th>
                        <th>Complaint Type</th>
                        <th>Asset Type</th>
                        <th>Make</th>
                        <th>Model</th>
                        <th>Serial Number</th>
                        <th>Link Type</th>
                        <th>Application Type</th>
                        <th>Problem Description</th>
                        <th>Complaint Logged By</th>
                        <th>Informed Date</th>
                        <th>Vendor Name</th>
                        <th>Log Date</th>
                        <th>Case Number</th>
                        <th>Part Replacement</th>
                        <th>Case Resolved Date</th>
                        <th>No. of Days Taken</th>
                        <th>Status</th>
                        <th>Remarks</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${openCases}" var="u">
                        <tr>
                            <td>${u.getId()}</td>
                            <td>${u.getUserName()}</td>
                            <td>${u.getLocation()}</td>
                            <td>${u.getState()}</td>
                            <td>${u.getReletedtype()}</td>
                            <td>${u.getComplaintype()}</td>
                            <td>${u.getAssetType()}</td>
                            <td>${u.getMake()}</td>
                            <td>${u.getModel()}</td>
                            <td>${u.getSystemSerialNumber()}</td>
                            <td>${u.getIpAdd()}</td>
                            <td>${u.getApplitype()}</td>
                            <td>${u.getProblemDescription()}</td>
                            <td>${u.getComplaintLoggedBy()}</td>
                            <td>${u.getInformedToPurchasedVendorDate()}</td>
                            <td>${u.getVendorName()}</td>
                            <td>${u.getCaseLogDate()}</td>
                            <td>${u.getCaseNumber()}</td>
                            <td>${u.getPartReplacement()}</td>
                            <td>${u.getCaseResolvedDate()}</td>
                            <td>${u.getNoOfDaysTakenToResolve()}</td>
                            <td>${u.getStatus()}</td>
                            <td>${u.getRemarks()}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${fn:toLowerCase(u.getStatus()) == 'resolved'}">
                                        <button class="btn btn-success btn-sm" disabled>Closed</button>
                                    </c:when>
                                    <c:otherwise>
                                        <a class="btn btn-danger btn-sm" href="editform.jsp?id=${u.getId()}">Edit</a>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</section>

<!-- Include jQuery and DataTables JS -->
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

<script>
    $(document).ready(function() {
        $('#caseLogTable').DataTable({
            paging: true,
            searching: true,
            ordering: true,
            order: [[0, 'asc']], // Default sort by ID
            lengthMenu: [10, 25, 50, 100],
            pageLength: 10,
            responsive: true,
            language: {
                search: "Search:",
                lengthMenu: "Show _MENU_ entries",
                info: "Showing _START_ to _END_ of _TOTAL_ entries",
                paginate: {
                    previous: "&laquo;",
                    next: "&raquo;"
                }
            }
        });
    });
</script>

</body>
</html>
