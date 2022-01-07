<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Redirecting to Home Page</title>
</head>
<body>
	<% 
		if (session == null || session.getAttribute("username") == null || session.getAttribute("role") == null) {
			response.sendRedirect("LoginRegistration.jsp");
		}
		else if (session.getAttribute("role").equals("admin")) {
			response.sendRedirect("AdminHomePage.jsp");
		}
		else if (session.getAttribute("role").equals("customer_rep")) {
			response.sendRedirect("CustomerRepHomePage.jsp");
		}
		else if (session.getAttribute("role").equals("user")){
			response.sendRedirect("UserHomePage.jsp");
		}
	%>
</body>
</html>