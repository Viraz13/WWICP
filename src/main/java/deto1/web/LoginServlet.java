package deto1.web;

import java.io.IOException;


import deto1.loginbean.*;
import deto1.logindao.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet implementation class LoginServlet
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public LoginServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Logindao loginDao = new Logindao();
		
		
		String username = request.getParameter("userid");
		String password = request.getParameter("password");
		 String enteredCaptcha = request.getParameter("captcha");
		 HttpSession session1 = request.getSession();
	        String sessionCaptcha = (String) session1.getAttribute("captcha");

	        
	        session1.removeAttribute("captcha");

	      
	        if (sessionCaptcha == null || !sessionCaptcha.equals(enteredCaptcha)) {
	           
	            response.sendRedirect("login.jsp?error=captcha");
	            return;
	        }
		LoginBean loginBean = new LoginBean();
		loginBean.setuserid(username);
		loginBean.setPassword(password);
		  LoginBean validatedUser = loginDao.validate(loginBean);

	       
		  if (validatedUser != null) {
	            
	            HttpSession session = request.getSession();
	            session.setAttribute("userid", validatedUser.getuserid());
	            session.setAttribute("role", validatedUser.getRole());

	           
	            if ("Admin".equals(validatedUser.getRole())) {
	                response.sendRedirect("graph.jsp");
	            } else if ("customer".equals(validatedUser.getRole())) {
	                response.sendRedirect("graphuser.jsp");
	            } else {
	                response.sendRedirect("login.jsp?error=role");
	            }
	        } else {
	           
	            response.sendRedirect("login.jsp?error=invalid");
	        }
	    }
	}