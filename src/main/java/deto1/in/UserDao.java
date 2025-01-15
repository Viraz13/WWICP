package deto1.in;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import org.apache.tomcat.jakartaee.commons.lang3.StringUtils;

import deto1.loginbean.*;
import deto1.logindao.*;
import deto1.web.*;
import jakarta.servlet.http.HttpSession;

public class UserDao {
    public static Connection getConnection() {
        Connection con = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/complaintportal", "ptl", "root@123");
        } catch (Exception e) {
            System.out.println(e);
        }
        return con;
    }

    public static int save(User u, String loggedInUser) {
        int status = 0;
        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(
                "insert into register(user_name, location, state, asset_type, make, model, system_serialnumber, problem_description, complaint_logged_by, informed_to_purchased_vendor_date, vendor_name, case_log_date, case_number, part_replacement, case_resolved_date, no_of_days_taken_to_resolve, status, remarks, ipadd, complain_type, application_type, related_type,user_mail_id) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
                PreparedStatement.RETURN_GENERATED_KEYS // To get the generated ID
            );

            ps.setString(1, u.getUserName());
            ps.setString(2, u.getLocation());
            ps.setString(3, u.getState());
            ps.setString(4, u.getAssetType());
            ps.setString(5, u.getMake());
            ps.setString(6, u.getModel());
            ps.setString(7, u.getSystemSerialNumber());
            ps.setString(8, u.getProblemDescription());
            ps.setString(9, loggedInUser);
            ps.setString(10, u.getInformedToPurchasedVendorDate());
            ps.setString(11, u.getVendorName());
            ps.setString(12, u.getCaseLogDate());
            ps.setString(13, u.getCaseNumber());
            ps.setString(14, u.getPartReplacement());
            ps.setString(15, u.getCaseResolvedDate());
            ps.setInt(16, u.getNoOfDaysTakenToResolve());
            ps.setString(17, u.getStatus());
            ps.setString(18, u.getRemarks());
            ps.setString(19, u.getIpAdd());
            ps.setString(20, u.getComplaintype());
            ps.setString(21, u.getApplitype());
            ps.setString(22, u.getReletedtype());
            ps.setString(23, u.getUsermailId());
            
            status = ps.executeUpdate();

            // Get the generated ID of the inserted complaint
            if (status > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    int complaintId = rs.getInt(1); // Get the auto-generated complaint ID

                    // Send email if the status is OPEN
                    if ("OPEN".equalsIgnoreCase(u.getStatus())) {
                        ComplaintNotifier.notifyUser(complaintId, u.getStatus());
                        System.out.println("Notification sent for new complaint ID: " + complaintId);
                    }
                }
            }

        } catch (Exception e) {
            System.out.println(e);
        }
        return status;
    }
    public static int update(User u) {
        int status = 0;
        try {
            Connection con = getConnection();

            // Check the existing status before the update
            String currentStatus = null;
            PreparedStatement checkStatusPs = con.prepareStatement("SELECT status FROM register WHERE id = ?");
            checkStatusPs.setInt(1, u.getId());
            ResultSet rs = checkStatusPs.executeQuery();
            if (rs.next()) {
                currentStatus = rs.getString("status");
            }
            rs.close();
            checkStatusPs.close();

            // Update the record
            PreparedStatement ps = con.prepareStatement(
                "update register set user_name=?, location=?, state=?, asset_type=?, make=?, model=?, system_serialnumber=?, problem_description=?, complaint_logged_by=?, informed_to_purchased_vendor_date=?, vendor_name=?, case_log_date=?, case_number=?, part_replacement=?, case_resolved_date=?, no_of_days_taken_to_resolve=?, status=?, remarks=?, ipadd=?, complain_type=?, application_type=?, related_type=?, user_mail_id=? where id=?"
            );
            ps.setString(1, u.getUserName());
            ps.setString(2, u.getLocation());
            ps.setString(3, u.getState());
            ps.setString(4, u.getAssetType());
            ps.setString(5, u.getMake());
            ps.setString(6, u.getModel());
            ps.setString(7, u.getSystemSerialNumber());
            ps.setString(8, u.getProblemDescription());
            ps.setString(9, u.getComplaintLoggedBy());
            ps.setString(10, u.getInformedToPurchasedVendorDate());
            ps.setString(11, u.getVendorName());
            ps.setString(12, u.getCaseLogDate());
            ps.setString(13, u.getCaseNumber());
            ps.setString(14, u.getPartReplacement());
            ps.setString(15, u.getCaseResolvedDate());
            ps.setInt(16, u.getNoOfDaysTakenToResolve());
            ps.setString(17, u.getStatus());
            ps.setString(18, u.getRemarks());
            ps.setString(19, u.getIpAdd());
            ps.setString(20, u.getComplaintype());
            ps.setString(21, u.getApplitype());
            ps.setString(22, u.getReletedtype());
            ps.setString(23, u.getUsermailId());
            ps.setInt(24, u.getId());
            status = ps.executeUpdate();

            // Send email notification if status changed
            if (status > 0 && u.getStatus() != null && u.getStatus().equalsIgnoreCase("RESOLVED") 
                    && (currentStatus == null || !currentStatus.equalsIgnoreCase("RESOLVED"))) {
                ComplaintNotifier.notifyUser(u.getId(), u.getStatus());
                System.out.println("Notification sent for resolved complaint ID: " + u.getId());
            }

        } catch (Exception e) {
            System.out.println(e);
        }
        return status;
    }


    public static int delete(User u) {
        int status = 0;
        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement("delete from register where id=?");
            ps.setInt(1, u.getId());
            status = ps.executeUpdate();
        } catch (Exception e) {
            System.out.println(e);
        }
        return status;
    }

    public static List<User> getAllRecords(String loggedinUser, String role) {
        List<User> list = new ArrayList<User>();
        try {
        	
        	if(StringUtils.isEmpty(role) || StringUtils.isEmpty(loggedinUser)) {
        		System.out.println("Either loggedinUser or role in session is empty . Role : "+ role+" user :: "+loggedinUser);
        	}
        	String sqlQuery="";
        	if("customer".equalsIgnoreCase(role)) {
        		sqlQuery = "select * from register where complaint_logged_by = '"+loggedinUser+"'";
        	}else if("Admin".equalsIgnoreCase(role)) {
        		sqlQuery = "select * from register";
        	} else {
        		System.out.println("Invalid role. Its neither Admin nor customer, loking for  role : " + role);
        	}
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(sqlQuery);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUserName(rs.getString("user_name"));
                u.setLocation(rs.getString("location"));
                u.setState(rs.getString("state"));
                u.setAssetType(rs.getString("asset_type"));
                u.setMake(rs.getString("make"));
                u.setModel(rs.getString("model"));
                u.setSystemSerialNumber(rs.getString("system_serialnumber"));
                u.setProblemDescription(rs.getString("problem_description"));
                u.setComplaintLoggedBy(rs.getString("complaint_logged_by"));
                u.setInformedToPurchasedVendorDate(rs.getString("informed_to_purchased_vendor_date"));
                u.setVendorName(rs.getString("vendor_name"));
                u.setCaseLogDate(rs.getString("case_log_date"));
                u.setCaseNumber(rs.getString("case_number"));
                u.setPartReplacement(rs.getString("part_replacement"));
                u.setCaseResolvedDate(rs.getString("case_resolved_date"));
                u.setNoOfDaysTakenToResolve(rs.getInt("no_of_days_taken_to_resolve"));
                u.setStatus(rs.getString("status"));
                u.setRemarks(rs.getString("remarks"));
                u.setIpAdd(rs.getString("ipadd")); 
                u.setComplaintype(rs.getString("complain_type"));
                u.setApplitype(rs.getString("application_type"));
                u.setReletedtype(rs.getString("related_type"));
                u.setUsermailId(rs.getString("user_mail_id"));
                list.add(u);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    public static User getRecordById(int id) {
        User u = null;
        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement("select * from register where id=?");
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                u = new User();
                u.setId(rs.getInt("id"));
                u.setUserName(rs.getString("user_name"));
                u.setLocation(rs.getString("location"));
                u.setState(rs.getString("state"));
                u.setAssetType(rs.getString("asset_type"));
                u.setMake(rs.getString("make"));
                u.setModel(rs.getString("model"));
                u.setSystemSerialNumber(rs.getString("system_serialnumber"));
                u.setProblemDescription(rs.getString("problem_description"));
                u.setComplaintLoggedBy(rs.getString("complaint_logged_by"));
                u.setInformedToPurchasedVendorDate(rs.getString("informed_to_purchased_vendor_date"));
                u.setVendorName(rs.getString("vendor_name"));
                u.setCaseLogDate(rs.getString("case_log_date"));
                u.setCaseNumber(rs.getString("case_number"));
                u.setPartReplacement(rs.getString("part_replacement"));
                u.setCaseResolvedDate(rs.getString("case_resolved_date"));
                u.setNoOfDaysTakenToResolve(rs.getInt("no_of_days_taken_to_resolve"));
               
                u.setStatus(rs.getString("status"));
                u.setRemarks(rs.getString("remarks"));
                u.setIpAdd(rs.getString("ipadd"));
                u.setComplaintype(rs.getString("complain_type"));
                u.setApplitype(rs.getString("application_type"));
                u.setReletedtype(rs.getString("related_type"));
                u.setUsermailId(rs.getString("user_mail_id"));
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return u;
    }
    public static int getCountByStatus(String status, String loggedinUser, String role) {
        int count = 0;
        try (Connection con = getConnection()) {
            String query;
            PreparedStatement ps;

            if ("Admin".equalsIgnoreCase(role)) {
                // Admin sees all complaints with the given status
                query = "SELECT COUNT(*) FROM register WHERE LOWER(status) = LOWER(?)";
                ps = con.prepareStatement(query);
                ps.setString(1, status);
            } else {
                // Customer sees only their complaints with the given status
                query = "SELECT COUNT(*) FROM register WHERE LOWER(status) = LOWER(?) AND complaint_logged_by = ?";
                ps = con.prepareStatement(query);
                ps.setString(1, status);
                ps.setString(2, loggedinUser);
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1); // Get the count
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    public static int getTotalCount(String loggedinUser, String role) {
        int total = 0;
        try (Connection con = getConnection()) {
            String query;
            PreparedStatement ps;
            if ("Admin".equals(role)) {
                // Admin sees all complaints
                query = "SELECT COUNT(*) FROM register";
                ps = con.prepareStatement(query);
            } else {
                // Customer sees only their complaints
                query = "SELECT COUNT(*) FROM register WHERE complaint_logged_by =?";
                ps = con.prepareStatement(query);
                ps.setString(1, loggedinUser);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }

    public static List<User> getOpenCases(String loggedInUser, String role) {
        List<User> list = new ArrayList<>();
        try {
            Connection con = getConnection();
            String query = "";

            if ("customer".equalsIgnoreCase(role)) {
                query = "SELECT * FROM register WHERE complaint_logged_by = ? AND LOWER(status) = 'open'";
            } else if ("Admin".equalsIgnoreCase(role)) {
                query = "SELECT * FROM register WHERE LOWER(status) = 'open'";
            } else {
                System.out.println("Invalid role. Role must be 'Admin' or 'Customer'.");
                return list;
            }

            PreparedStatement ps = con.prepareStatement(query);

            if ("customer".equalsIgnoreCase(role)) {
                ps.setString(1, loggedInUser);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUserName(rs.getString("user_name"));
                u.setLocation(rs.getString("location"));
                u.setState(rs.getString("state"));
                u.setAssetType(rs.getString("asset_type"));
                u.setMake(rs.getString("make"));
                u.setModel(rs.getString("model"));
                u.setSystemSerialNumber(rs.getString("system_serialnumber"));
                u.setProblemDescription(rs.getString("problem_description"));
                u.setComplaintLoggedBy(rs.getString("complaint_logged_by"));
                u.setInformedToPurchasedVendorDate(rs.getString("informed_to_purchased_vendor_date"));
                u.setVendorName(rs.getString("vendor_name"));
                u.setCaseLogDate(rs.getString("case_log_date"));
                u.setCaseNumber(rs.getString("case_number"));
                u.setStatus(rs.getString("status"));
                u.setRemarks(rs.getString("remarks"));
                u.setIpAdd(rs.getString("ipadd"));
                u.setComplaintype(rs.getString("complain_type"));
                u.setApplitype(rs.getString("application_type"));
                u.setReletedtype(rs.getString("related_type"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
        
    public static List<User> getreslovedCases(String loggedInUser,String role) {
        List<User> list = new ArrayList<>();
        try {
            Connection con = getConnection();
            String query = "";

            // Only return open cases for the 'admin' role
            if ("customer".equalsIgnoreCase(role)) {
                query = "SELECT * FROM register WHERE complaint_logged_by = ? AND LOWER(status) = 'resolved'";
            } else if ("Admin".equalsIgnoreCase(role)) {
                query = "SELECT * FROM register WHERE LOWER(status) = 'resolved'";
            } else {
                System.out.println("Invalid role. Role must be 'Admin' or 'Customer'.");
                return list;
            }

            PreparedStatement ps = con.prepareStatement(query);

            if ("customer".equalsIgnoreCase(role)) {
                ps.setString(1, loggedInUser);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUserName(rs.getString("user_name"));
                u.setLocation(rs.getString("location"));
                u.setState(rs.getString("state"));
                u.setAssetType(rs.getString("asset_type"));
                u.setMake(rs.getString("make"));
                u.setModel(rs.getString("model"));
                u.setSystemSerialNumber(rs.getString("system_serialnumber"));
                u.setProblemDescription(rs.getString("problem_description"));
                u.setComplaintLoggedBy(rs.getString("complaint_logged_by"));
                u.setInformedToPurchasedVendorDate(rs.getString("informed_to_purchased_vendor_date"));
                u.setVendorName(rs.getString("vendor_name"));
                u.setCaseLogDate(rs.getString("case_log_date"));
                u.setCaseNumber(rs.getString("case_number"));
                u.setPartReplacement(rs.getString("part_replacement"));
                u.setCaseResolvedDate(rs.getString("case_resolved_date"));
                u.setNoOfDaysTakenToResolve(rs.getInt("no_of_days_taken_to_resolve"));
               
                u.setStatus(rs.getString("status"));
                u.setRemarks(rs.getString("remarks"));
                u.setIpAdd(rs.getString("ipadd"));
                u.setComplaintype(rs.getString("complain_type"));
                u.setApplitype(rs.getString("application_type"));
                u.setReletedtype(rs.getString("related_type"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
		}
    
    public static List<User> getworkingvendorCases(String loggedInUser,String role) {
        List<User> list = new ArrayList<>();
        try {
            Connection con = getConnection();
            String query = "";

            // Only return open cases for the 'admin' role
            if ("customer".equalsIgnoreCase(role)) {
                query = "SELECT * FROM register WHERE complaint_logged_by = ? AND LOWER(status) = 'Waiting on vendor'";
            } else if ("Admin".equalsIgnoreCase(role)) {
                query = "SELECT * FROM register WHERE LOWER(status) = 'Waiting on vendor'";
            } else {
                System.out.println("Invalid role. Role must be 'Admin' or 'Customer'.");
                return list;
            }

            PreparedStatement ps = con.prepareStatement(query);

            if ("customer".equalsIgnoreCase(role)) {
                ps.setString(1, loggedInUser);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUserName(rs.getString("user_name"));
                u.setLocation(rs.getString("location"));
                u.setState(rs.getString("state"));
                u.setAssetType(rs.getString("asset_type"));
                u.setMake(rs.getString("make"));
                u.setModel(rs.getString("model"));
                u.setSystemSerialNumber(rs.getString("system_serialnumber"));
                u.setProblemDescription(rs.getString("problem_description"));
                u.setComplaintLoggedBy(rs.getString("complaint_logged_by"));
                u.setInformedToPurchasedVendorDate(rs.getString("informed_to_purchased_vendor_date"));
                u.setVendorName(rs.getString("vendor_name"));
                u.setCaseLogDate(rs.getString("case_log_date"));
                u.setCaseNumber(rs.getString("case_number"));
                u.setPartReplacement(rs.getString("part_replacement"));
                u.setCaseResolvedDate(rs.getString("case_resolved_date"));
                u.setNoOfDaysTakenToResolve(rs.getInt("no_of_days_taken_to_resolve"));
               
                u.setStatus(rs.getString("status"));
                u.setRemarks(rs.getString("remarks"));
                u.setIpAdd(rs.getString("ipadd"));
                u.setComplaintype(rs.getString("complain_type"));
                u.setApplitype(rs.getString("application_type"));
                u.setReletedtype(rs.getString("related_type"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
		}
    
    
    public static List<User> getworkingprogessCases(String loggedInUser,String role) {
        List<User> list = new ArrayList<>();
        try {
            Connection con = getConnection();
            String query = "";

            // Only return open cases for the 'admin' role
            if ("customer".equalsIgnoreCase(role)) {
                query = "SELECT * FROM register WHERE complaint_logged_by = ? AND LOWER(status) = 'Working in process'";
            } else if ("Admin".equalsIgnoreCase(role)) {
                query = "SELECT * FROM register WHERE LOWER(status) = 'Working in process'";
            } else {
                System.out.println("Invalid role. Role must be 'Admin' or 'Customer'.");
                return list;
            }

            PreparedStatement ps = con.prepareStatement(query);

            if ("customer".equalsIgnoreCase(role)) {
                ps.setString(1, loggedInUser);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUserName(rs.getString("user_name"));
                u.setLocation(rs.getString("location"));
                u.setState(rs.getString("state"));
                u.setAssetType(rs.getString("asset_type"));
                u.setMake(rs.getString("make"));
                u.setModel(rs.getString("model"));
                u.setSystemSerialNumber(rs.getString("system_serialnumber"));
                u.setProblemDescription(rs.getString("problem_description"));
                u.setComplaintLoggedBy(rs.getString("complaint_logged_by"));
                u.setInformedToPurchasedVendorDate(rs.getString("informed_to_purchased_vendor_date"));
                u.setVendorName(rs.getString("vendor_name"));
                u.setCaseLogDate(rs.getString("case_log_date"));
                u.setCaseNumber(rs.getString("case_number"));
                u.setPartReplacement(rs.getString("part_replacement"));
                u.setCaseResolvedDate(rs.getString("case_resolved_date"));
                u.setNoOfDaysTakenToResolve(rs.getInt("no_of_days_taken_to_resolve"));
               
                u.setStatus(rs.getString("status"));
                u.setRemarks(rs.getString("remarks"));
                u.setIpAdd(rs.getString("ipadd"));
                u.setComplaintype(rs.getString("complain_type"));
                u.setApplitype(rs.getString("application_type"));
                u.setReletedtype(rs.getString("related_type"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
		}
    
    
        
    }
	


