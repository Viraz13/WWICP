<!DOCTYPE html>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Edit User</title>
<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet">
<link rel="icon" href="img/favicon.ico" type="image/x-icon">
<style type="text/css">


 body {
            background-image: url('img/sbg1.jpeg');
    background-size: cover;
    background-position: center;
    background-attachment: fixed;
    position: relative;
        }

/* Form Container */
.container {
    background-color: #f5f7fa; 
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.2);
}

/* Input Fields Styling */
input[type="text"],
input[type="date"],
select,
textarea {
    background-color: #ffffff; 
    color: #333333; 
    border: 1px solid #ccc; 
    padding: 10px;
    border-radius: 5px; 
    box-shadow: inset 0px 1px 3px rgba(0, 0, 0, 0.1); 
    font-size: 16px; 
    transition: background-color 0.3s ease, box-shadow 0.3s ease;
}

/* Focused Input Fields */
input[type="text"]:focus,
input[type="date"]:focus,
select:focus,
textarea:focus {
    background-color: #f0f8ff; 
    border-color: #28a745; 
    box-shadow: 0px 0px 5px rgba(40, 167, 69, 0.5); 
    outline: none; 
}

/* Labels */
label {
    color: #333; 
    font-weight: bold;
}

/* Buttons */
.btn-primary {
    background-color: #28a745; 
    border-color: #28a745;
    color: #ffffff; 
}

.btn-primary:hover {
    background-color: #218838; 
    border-color: #1e7e34;
}
h4.display-5.fw-bold {
    color: #333333; 
    text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.3); 
}
</style>

<script type="text/javascript">
    
    function calculateDays() {
        
        var caseLogDate = document.getElementById("caseLogDate").value;
        var caseResolvedDate = document.getElementById("caseResolvedDate").value;

        if (caseLogDate && caseResolvedDate) {
           
            var logDate = new Date(caseLogDate);
            var resolvedDate = new Date(caseResolvedDate);

            
            var timeDifference = resolvedDate.getTime() - logDate.getTime();

            
            var daysTaken = Math.ceil(timeDifference / (1000 * 3600 * 24));

            
            if (daysTaken >= 0) {
                document.getElementById("noOfDaysTakenToResolve").value = daysTaken;
            } else {
                document.getElementById("noOfDaysTakenToResolve").value = 0;
            }
        }
    }
    
   
</script>

</head>
<body>
<%@page import="deto1.in.UserDao,deto1.in.User"%>

<%
    String id = request.getParameter("id");
    User u = UserDao.getRecordById(Integer.parseInt(id));
%>

<div class="container mt-5">
    <h4 class="display-5 fw-bold">Edit Complain</h4>
    <form action="edituser.jsp" method="post">
        <!-- Hidden ID field -->
        <input type="hidden" name="id" value="<%= u.getId() %>" />

        <!-- User Name -->
        <div class="form-group">
            <label for="userName">User Name:</label>
            <input type="text" class="form-control" id="userName" name="userName" value="<%= u.getUserName() %>" readonly>
        </div>
        
        
     <div class="form-group">
            <label for="user_mail_id">User Email Id:</label>
            <input type="email" class="form-control" id="user_mail_id" name="usermailId" value="<%= u.getUsermailId() %>" readonly>
        </div>

      
        <div class="form-group">
            <label for="location">Location:</label>
            <input type="text" class="form-control" id="location" name="location" value="<%= u.getLocation() %>" readonly>
        </div>

      
        <div class="form-group">
            <label for="state">State:</label>
            <input type="text" class="form-control" id="state" name="state" value="<%= u.getState() %>" readonly>
        </div>
        
        
        
         <div class="form-group">
            <label for="related_type">Related Type :</label>
            <input type="text" class="form-control" id="related_type" name="reletedtype" value="<%= u.getReletedtype() %>" readonly>
        </div>
        
       
       <div class="from-group">
          <label for="complain_type" class="form-label">Complaint Type</label>
          <input type="text" class="form-control" id="complain_type" name="complaintype" value="<%= u.getComplaintype() %>" readonly>
       </div>
       
       
        <div class="form-group">
            <label for="assetType">Asset Type:</label>
            <input type="text" class="form-control" id="assetType" name="assetType" value="<%= u.getAssetType() %>" readonly>
        </div>

       
        <div class="form-group">
            <label for="make">Make:</label>
            <input type="text" class="form-control" id="make" name="make" value="<%= u.getMake() %>" readonly>
        </div>

       
        <div class="form-group">
            <label for="model">Model:</label>
            <input type="text" class="form-control" id="model" name="model" value="<%= u.getModel() %>" readonly>
        </div>

      
        <div class="form-group">
            <label for="systemSerialNumber">System Serial Number:</label>
            <input type="text" class="form-control" id="systemSerialNumber" name="systemSerialNumber" value="<%= u.getSystemSerialNumber() %>" readonly>
        </div>

                        <div class="form-group">
            <label for="ipadd">Type Of Link:</label>
            <input type="text" class="form-control" id="ipAdd" name="ipAdd" value="<%= u.getIpAdd() %>" readonly>
             
        </div>

          <div class="from-group">
          <label for="application_type" class="form-label">Application Type</label>
           <input type="text" class="form-control" id="application_type" name="Applitype" value="<%= u.getApplitype() %>" readonly>
          </div>


        
        <div class="form-group">
            <label for="problemDescription">Problem Description:</label>
            <input type="text" class="form-control" id="problemDescription" name="problemDescription" value="<%= u.getProblemDescription() %>" readonly>
        </div>

        
        <div class="form-group">
            <label for="complaintLoggedBy">Complaint Logged By:</label>
            <input type="text" class="form-control" id="complaintLoggedBy" name="complaintLoggedBy" value="<%= u.getComplaintLoggedBy() %>" readonly>
        </div>

       
        <div class="form-group">
            <label for="informedToPurchasedVendorDate">Informed to Vendor Date:</label>
            <input type="date" class="form-control" id="informedToPurchasedVendorDate" name="informedToPurchasedVendorDate" value="<%= u.getInformedToPurchasedVendorDate() %>" readonly>
        </div>

        
        <div class="form-group">
            <label for="vendorName">Vendor Name:</label>
            <input type="text" class="form-control" id="vendorName" name="vendorName" value="<%= u.getVendorName() %>" readonly>
        </div>

        
        <div class="form-group">
            <label for="caseLogDate">Case Log Date:</label>
            <input type="date" class="form-control" id="caseLogDate" name="caseLogDate" value="<%= u.getCaseLogDate() %>">
        </div>

        
        <div class="form-group">
            <label for="caseNumber">Case Number:</label>
            <input type="text" class="form-control" id="caseNumber" name="caseNumber" value="<%= u.getCaseNumber() %>" required>
        </div>

        
        <div class="form-group">
            <label for="partReplacement">Part Replacement:</label>
            <input type="text" class="form-control" id="partReplacement" name="partReplacement" value="<%= u.getPartReplacement() %>" required>
        </div>

       
        <div class="form-group">
            <label for="caseResolvedDate">Case Resolved Date:</label>
            <input type="date" class="form-control" id="caseResolvedDate" name="caseResolvedDate" value="<%= u.getCaseResolvedDate() %>"  onchange="calculateDays()">
        </div> 
        
       

        
   <div class="form-group">
            <label for="noOfDaysTakenToResolve">No. of Days Taken to Resolve:</label>
            <input type="number" class="form-control" id="noOfDaysTakenToResolve" name="noOfDaysTakenToResolve" value="<%= u.getNoOfDaysTakenToResolve() %>" >
        </div>
     
        <div class="form-group">
    <label for="status">Status:</label>
    <select class="form-control" id="status" name="status" required>
         <option value="OPEN">OPEN</option>
        <option value="Assigned" <%= u.getStatus().equals("Assigned") ? "selected" : "" %>>Assigned</option>
        <option value="Working in process" <%= u.getStatus().equals("Working in process") ? "selected" : "" %>>Working in process</option>
        <option value="Waiting on vendor" <%= u.getStatus().equals("Waiting on vendor") ? "selected" : "" %>>Waiting on vendor</option>
        <option value="Resolved" <%= u.getStatus().equals("Resolved") ? "selected" : "" %>>Resolved</option>
    </select>
</div>

        
        <div class="form-group">
            <label for="remarks">Remarks:</label>
            <textarea class="form-control" id="remarks" name="remarks" required><%= u.getRemarks() %></textarea>
        </div>

        <button type="submit" class="btn btn-primary">Update Complain</button>
    </form>
</div>
</body>
</html>
