<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<link rel="stylesheet" href="stylesAuctionSite.css">
	<meta http-equiv="Refresh" content="0; LoginRegistration.jsp">
	<title>Delete an Auction</title>
</head>
<body>	

	<% 
	if (session == null || session.getAttribute("username") == null) {
		response.sendRedirect("HomePageRedirect.jsp");
		return;
	}else if (!"customer_rep".equals(session.getAttribute("role"))) {
		response.sendRedirect("HomePageRedirect.jsp");
		return;
	} else{
		
	}
	
	try {

		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		//Get parameters from the HTML form at the Login.jsp
		String auction_id = request.getParameter("auction_id");

		String delete = "DELETE FROM auctionsellsbuys WHERE auction_id = ? and closing_date_time > CURRENT_TIMESTAMP()";
				
		//Create a Prepared SQL statement allowing you to introduce the parameters of the query
		PreparedStatement ps = con.prepareStatement(delete);

		//Add parameters of the query. Start with 1, the 0-parameter is the SELECT statement itself
		ps.setInt(1, Integer.parseInt(auction_id));
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
		response.sendRedirect("CustRepRemoveAuction.jsp");
		return;
		
	} catch (Exception ex) {
		out.print(ex);
	}
%>
</body>
</html>