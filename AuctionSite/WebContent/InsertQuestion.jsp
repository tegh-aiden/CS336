<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Insert Question</title>
</head>
<body>
	<% 
	if (session == null || session.getAttribute("username") == null) {
		response.sendRedirect("LoginRegistration.jsp");
		return;
	}
	else if (!("user".equals(session.getAttribute("role")))) {
		response.sendRedirect("HomePageRedirect.jsp");
		return;
	}
	
	try {
		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		//Get parameters from the HTML form at the Login.jsp
		String user_login_id = (String) session.getAttribute("username");
		String question = request.getParameter("question");
							
		//Create a Prepared SQL statement allowing you to introduce the parameters of the query
		String insert = "INSERT INTO QuestionAnswer (user_login_id, question, answer) VALUES (?,?,'')";
				
		//Create a Prepared SQL statement allowing you to introduce the parameters of the query
		PreparedStatement ps = con.prepareStatement(insert);
		//Add parameters of the query. Start with 1, the 0-parameter is the SELECT statement itself
		ps.setString(1, user_login_id);
		ps.setString(2, question);
		//Run the query against the DB
	    ps.executeUpdate();
		//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
	
		ps.close();
		con.close();
		
		response.sendRedirect("CreateQuestion.jsp");
		return;
		
	} catch (Exception ex) {
		out.print(ex);
	}
%>
</body>
</html>