<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<link rel="stylesheet" href="stylesAuctionSite.css">
	<meta http-equiv="Refresh" content="0; LoginRegistration.jsp">
	<title>Login Verification</title>
</head>
<body>	

	<% 
	if (session != null && session.getAttribute("username") != null) {
		response.sendRedirect("HomePageRedirect.jsp");
		return;
	}
	
	try {

		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		//Get parameters from the HTML form at the Login.jsp
		String login_id = request.getParameter("username");
		String password = request.getParameter("password");

		String select = "SELECT login_id, password, permissions_class FROM Account WHERE login_id = ? AND password = ?";
				
		//Create a Prepared SQL statement allowing you to introduce the parameters of the query
		PreparedStatement ps = con.prepareStatement(select);

		//Add parameters of the query. Start with 1, the 0-parameter is the SELECT statement itself
		ps.setString(1, login_id);
		ps.setString(2, password);
		//Run the query against the DB
		ResultSet rs = ps.executeQuery();
		
		if (rs.next()) {
			String role = rs.getString("permissions_class");
			session.setAttribute("username", login_id);
			session.setAttribute("role", role);
			session.removeAttribute("errorCode");
			response.sendRedirect("HomePageRedirect.jsp");
			return;
		}
		else {
			session.setAttribute("errorCode", -1);			
		}

		//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
		rs.close();
		ps.close();
		con.close();
		
	} catch (Exception ex) {
		out.print(ex);
	}
%>
</body>
</html>