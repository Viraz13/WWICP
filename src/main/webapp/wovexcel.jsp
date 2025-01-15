<%@ page import="java.io.*, java.util.*, javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, deto1.in.UserDao, deto1.in.User" %>
<%
    
    response.setContentType("text/csv");
    response.setHeader("Content-Disposition", "attachment;filename=complaint_data.csv");
    
  
     String loggedInUser = (String)session.getAttribute("userid");
        String role = (String)session.getAttribute("role");
    List<User> list = UserDao.getworkingvendorCases(loggedInUser,role);
    
    
    PrintWriter writer = response.getWriter();

  
    writer.println("Id,User Name,Location,State,Asset Type,Make,Model,System Serial Number,Problem Description,Complaint Logged By,Informed to Purchased Vendor Date,Vendor Name,Case Log Date,Case Number,Part Replacement,Case Resolved Date,No. of Days taken to resolve,Status,Remarks,Link Type,Complain Type,Application Type,Related Type");
    
  
    for (User u : list) {
        writer.println(u.getId() + "," +
                       u.getUserName() + "," +
                       u.getLocation() + "," +
                       u.getState() + "," +
                       u.getAssetType() + "," +
                       u.getMake() + "," +
                       u.getModel() + "," +
                       u.getSystemSerialNumber() + "," +
                       u.getProblemDescription() + "," +
                       u.getComplaintLoggedBy() + "," +
                       u.getInformedToPurchasedVendorDate() + "," +
                       u.getVendorName() + "," +
                       u.getCaseLogDate() + "," +
                       u.getCaseNumber() + "," +
                       u.getPartReplacement() + "," +
                       u.getCaseResolvedDate() + "," +
                       u.getNoOfDaysTakenToResolve() + "," +
                       u.getStatus() + "," +
                       u.getRemarks()+","+
                       u.getIpAdd()+","+
                       u.getComplaintype()+","+
                       u.getApplitype()+","+
                       u.getReletedtype());
    }

   
    writer.flush();
    writer.close();
%>
