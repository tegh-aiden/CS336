<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
	<script src="https://code.jquery.com/jquery-1.10.2.js"></script>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<link rel="stylesheet" href="stylesAuctionSite.css">
	<title>Ask a new Question</title>
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
			String username = (String)(session.getAttribute("username"));
			
			PreparedStatement ps;
			ResultSet rs;
	%>
	<h1 class="message">Ask a Question</h1>
	<form id="create_question" class="col" method="post" action="InsertQuestion.jsp">
		<textarea name="question" maxlength="300" placeholder="Question" rows="10" required></textarea>
		<input type="submit" value="Ask Question" title="Ask a new Question">
	</form>
		
	<%					
		} catch (Exception ex) {
			out.print(ex);
		}
	%>		
</body>
</html>