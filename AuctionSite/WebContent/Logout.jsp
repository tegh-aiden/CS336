<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1;">
	<title>Logging Out!</title>	
</head>
<body>
	<% 
	if (session != null) {
	    session.invalidate();
	}

	response.sendRedirect("LoginRegistration.jsp");
	%>
</body>
</html>