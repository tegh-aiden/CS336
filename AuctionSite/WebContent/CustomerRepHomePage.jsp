<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<% 
	if (session == null || session.getAttribute("username") == null) {
		response.sendRedirect("LoginRegistration.jsp");
		return;
	}
	else if (!"customer_rep".equals(session.getAttribute("role"))){
		response.sendRedirect("HomePageRedirect.jsp");
		return;
	}
	try {
		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		//Get parameters from the HTML form at the Login.jsp
		String username = (String)(session.getAttribute("username"));
		
		String select = "SELECT first_name FROM Account WHERE login_id = ?";
		
		//Create a Prepared SQL statement allowing you to introduce the parameters of the query
		PreparedStatement ps = con.prepareStatement(select);

		ps.setString(1, username);
		//Run the query against the DB
		ResultSet rs = ps.executeQuery();
		String first_name = "";
		String title = "";
		
		if (rs.next()) {
			first_name = rs.getString("first_name");
			title = "Hello Customer Rep. " + first_name + "!";
		}
		else {
			response.sendRedirect("Logout.jsp");
			return;
		}		
%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<link rel="stylesheet" href="stylesAuctionSite.css">
	<title><%= title %></title>
	<script src="https://code.jquery.com/jquery-1.10.2.js"></script>
	
</head>
<body>
logged in as, <%=(String)(session.getAttribute("username"))%><br>
	<!--Navigation bar-->
		<div id="nav-placeholder">
		
		</div>
		
		<script>
		$(function(){
		  $("#nav-placeholder").load("NavCustServ.html");
		});
		</script>
	<!--end of Navigation bar-->
<%	
		out.print("Welcome to AuctionSite Customer Rep. " + first_name + "!");
%>
<br>


<footer>
<%		
		out.print("Last Accessed on " + new java.util.Date(session.getLastAccessedTime()));
		//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
		rs.close();
		ps.close();			
		con.close();		
	} catch (Exception ex) {
		out.print(ex);
	}
%>    
	<form method="post" action="Logout.jsp">
    	<input type="submit" value="Logout"/>
	</form>
</footer>
</body>
</html>