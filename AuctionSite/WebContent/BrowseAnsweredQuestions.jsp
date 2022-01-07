<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.format.FormatStyle" %>
<!DOCTYPE html>
<% 
	if (session == null || session.getAttribute("username") == null) {
		response.sendRedirect("LoginRegistration.jsp");
		return;
	}
	try {
		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		String selectQuestion = "SELECT question_id, question FROM questionanswer WHERE answer is not null and answer <> \'\'";
		
		//Create a Prepared SQL statement allowing you to introduce the parameters of the query
		PreparedStatement ps = con.prepareStatement(selectQuestion);

		//Run the query against the DB
		ResultSet rs = ps.executeQuery();			
%>
<html>
<head>
	<script src="https://code.jquery.com/jquery-1.10.2.js"></script>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<link rel="stylesheet" href="stylesAuctionSite.css">
	<title>Browse Answered Questions</title>
</head>
<body>
logged in as, <%=(String)(session.getAttribute("username"))%><br>
<!--Navigation bar-->
		<div id="nav-placeholder">
		
		</div>
		
		<script>
		$(function(){
		  $("#nav-placeholder").load("NavUser.html");
		});
		</script>
<!--end of Navigation bar-->
	<h1 class="message">Answered Questions</h1>
	<div class ="container">
	<table id="info">
		<tr>
		<th>Question</th>
		</tr>
<% 
	if (!rs.next()) {
%>
		<tr>
			<td>No Questions Answered</td>
		</tr>
<%
	}
	else {
	do {
%>
		<tr>
			<th><a href="QuestionAnswer.jsp?question_id=<%= rs.getString(1) %>"><%= rs.getString(2) %></a></th>
		</tr>	
<%
	} while (rs.next());
	}
%>	
	</table>	
	</div>
<%		
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
