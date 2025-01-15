<%@page import="deto1.in.UserDao"%>
<jsp:useBean id="u" class="deto1.in.User"></jsp:useBean>
<jsp:setProperty property="*" name="u"/>

<%
int i=UserDao.update(u);
response.sendRedirect("viewusers.jsp");
%>