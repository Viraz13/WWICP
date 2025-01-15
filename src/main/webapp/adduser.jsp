<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@page import="deto1.in.UserDao"%>
<jsp:useBean id="u" class="deto1.in.User"></jsp:useBean>
<jsp:setProperty property="*" name="u"/>

<%
String loggedInUser = (String)session.getAttribute("userid");
int i=UserDao.save(u,loggedInUser);
if(i>0){
response.sendRedirect("adduser-success.jsp");
}else{
response.sendRedirect("adduser-error.jsp");
}
%>
