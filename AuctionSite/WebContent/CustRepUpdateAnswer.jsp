<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<link rel="stylesheet" href="stylesAuctionSite.css">
	<meta http-equiv="Refresh" content="0; LoginRegistration.jsp">
	<title>Insert Answer</title>
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
		String question_id = request.getParameter("question_id");
		String cr_answer = request.getParameter("cr_answer");

		String update = "UPDATE questionanswer SET cust_rep_login_id = ?, answer = ? where question_id = ? and cust_rep_login_id IS NULL";
				
		//Create a Prepared SQL statement allowing you to introduce the parameters of the query
		PreparedStatement ps = con.prepareStatement(update);

		//Add parameters of the query. Start with 1, the 0-parameter is the SELECT statement itself
		ps.setString(1, (String)session.getAttribute("username"));
		ps.setString(2, cr_answer);
		ps.setInt(3, Integer.parseInt(question_id));
		//Run the query against the DB
		ps.executeUpdate();
		

		//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
		ps.close();
		con.close();
		response.sendRedirect("CustRepBrowseQuestions.jsp");
		return;
		
	} catch (Exception ex) {
		out.print(ex);
	}
%>
</body>
</html>