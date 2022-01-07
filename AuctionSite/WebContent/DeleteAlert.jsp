<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<link rel="stylesheet" href="stylesAuctionSite.css">
	<title>Delete a Bid</title>
</head>
<body>	

	<% 
	if (session == null || session.getAttribute("username") == null) {
		response.sendRedirect("HomePageRedirect.jsp");
		return;
	}else if (!"user".equals(session.getAttribute("role"))) {
		response.sendRedirect("HomePageRedirect.jsp");
		return;
	}
	
	try {

		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		//Get parameters from the HTML form at the Login.jsp
		String uname = (String) session.getAttribute("username");
		String wish_id = request.getParameter("wish_id");

		String delete = "DELETE FROM alertforwishapparel WHERE user_login_id = ? AND wish_id = ?";
				
		//Create a Prepared SQL statement allowing you to introduce the parameters of the query
		PreparedStatement ps = con.prepareStatement(delete);

		//Add parameters of the query. Start with 1, the 0-parameter is the SELECT statement itself
		ps.setString(1, uname);
		ps.setInt(2, Integer.parseInt(wish_id));
		//Run the query against the DB
		int wasSuccess = 0;
		wasSuccess = ps.executeUpdate();
		
		if(wasSuccess != 0){
			System.out.println("was success");
		} else{
			System.out.println("wunt a success");
		}


		//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
		ps.close();
		con.close();
		response.sendRedirect("ViewAlerts.jsp");
		return;
		
	} catch (Exception ex) {
		out.print(ex);
	}
%>
</body>
</html>