package deto1.logindao;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import deto1.loginbean.*;

public class Logindao {
	private String dburl = "jdbc:mysql://localhost:3306/userdb";
	private String dbUname = "ptl";
	private String dbPass = "root@123";
	private String dbDriver = "com.mysql.cj.jdbc.Driver";
	
	public void loadDriver(String dbDriver) {
		
		try {
			Class.forName(dbDriver);
			
		} catch (ClassNotFoundException e) {
			// TODO: handle exception
			e.printStackTrace();
		}
	}
	
	public Connection getConnection()
	{
		Connection con = null;
		try {
			 con = DriverManager.getConnection(dburl,dbUname,dbPass );
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return con;
	}
	
	
	  public LoginBean validate(LoginBean loginBean) {
	        loadDriver(dbDriver);
	        Connection con = getConnection();
	        String sql = "SELECT * FROM login WHERE userid = ? AND password = ?";
	        PreparedStatement ps;
	        try {
	            ps = con.prepareStatement(sql);
	            ps.setString(1, loginBean.getuserid());
	            ps.setString(2, loginBean.getPassword());

	            ResultSet rs = ps.executeQuery();
	            if (rs.next()) {
	                // If credentials are valid, set user details into LoginBean
	                loginBean.setRole(rs.getString("role"));  // Assuming 'role' is a column in the login table
	                return loginBean; // Return LoginBean on success
	            }

	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	        // Return null if authentication fails
	        return null;
	    }
	
	
		/*
		 * public int updatePassword(String userid, String newPassword) {
		 * loadDriver(dbDriver); Connection con = getConnection(); int status = 0;
		 * String query = "UPDATE login SET password = ? WHERE userid = ?"; try {
		 * PreparedStatement ps = con.prepareStatement(query); ps.setString(1,
		 * newPassword); ps.setString(2, userid); status = ps.executeUpdate();
		 * con.close(); } catch (SQLException e) { e.printStackTrace(); } return status;
		 * }
		 */
	
		/*
		 * public boolean changePassword(String userid, String oldPassword, String
		 * newPassword) { boolean isUpdated = false;
		 * 
		 * try (Connection con = getConnection()) { // Check if the old password matches
		 * String checkQuery = "SELECT * FROM users WHERE userid = ? AND password = ?";
		 * PreparedStatement psCheck = con.prepareStatement(checkQuery);
		 * psCheck.setString(1, userid); psCheck.setString(2, oldPassword); ResultSet rs
		 * = psCheck.executeQuery();
		 * 
		 * if (rs.next()) { // If old password is correct, update the password String
		 * updateQuery = "UPDATE users SET password = ? WHERE userid = ?";
		 * PreparedStatement psUpdate = con.prepareStatement(updateQuery);
		 * psUpdate.setString(1, newPassword); psUpdate.setString(2, userid); int
		 * rowsAffected = psUpdate.executeUpdate();
		 * 
		 * isUpdated = rowsAffected > 0; } } catch (Exception e) { e.printStackTrace();
		 * } return isUpdated; }
		 */
}


