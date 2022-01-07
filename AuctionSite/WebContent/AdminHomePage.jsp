<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<link rel="stylesheet" href="stylesAuctionSite.css">
	<title>Hello Administrator!</title>
</head>
<body>

	<h1 class="message">Welcome to AuctionSite Administrator!</h1>
	<br>
	<% 
	if (session == null || session.getAttribute("username") == null) {
		response.sendRedirect("LoginRegistration.jsp");
		return;
	}
	else if (!"admin".equals(session.getAttribute("role"))){
		response.sendRedirect("HomePageRedirect.jsp");
		return;
	}
	Integer statusCode = (Integer)session.getAttribute("statusCode");
	if (statusCode != null) { 
		if (statusCode.equals(1)) {
	%>
	<h3 class="message" style="color: green">Customer Representative Account created successfully!</h3>
	<%	
		}
		else if (statusCode.equals(-1)) {
	%>
	<h3 class="message error">Oops! Registration failed - Username already in use! Please choose another Username.</h3>
	<%	
		}
		session.removeAttribute("statusCode");			
	}	
%>    
	<form id="register" class="col" method="post" action="RegisterCustomerRep.jsp" autocomplete="off">
		<h3 class="message">Create a new Account for a Customer Representative</h3>
		<input type="text" name="first_name" maxlength="20" placeholder="First Name" title="Enter first name of the new Customer Representative.&#10;First Name must contain only letters (A-Z and a-z)." pattern="^[A-Za-z]+$" required>
		<input type="text" name="last_name" maxlength="20" placeholder="Last Name" title="Enter last name of the new Customer Representative.&#10;Last Name must contain only letters (A-Z and a-z)." pattern="^[A-Za-z]+$" required>
		<input type="email" name="email" maxlength="50" placeholder="Auto-generated Email Address" title="Auto-generated Email Address: first_name.last_name.{Rep#}@auctionsite.org&#10;Otherwise, create an email address.">
		<input type="text" name="username" minlength="6" maxlength="30" placeholder="Auto-generated Username" pattern="^(?!.*[\._\-][\._\-]+)(?![\._\-].*)(?!.*[\._\-]$)(?!.*\s)[a-zA-Z0-9\._\-]{6,}$" title="Auto-generated Username: CustomerRep{Rep#}&#10;Otherwise, create a username (6-30 characters).&#10;Username can only include letters, numbers, full stops, underscores or dashes.&#10;Username can't begin or end with a full stop, an underscore or a dash.&#10;Username can't have consecutive fullstops, underscores or dashes.&#10;Username must not contain any whitespace character.">
		<input type="password" name="password" minlength="8" maxlength="20" placeholder="Auto-generated Password" pattern="^(?!.*\s)(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*\(\-\+]).{8,}$" title="Auto-generated Password: \${Rep#}Crep{first_name_initial}{last_name_initial}&#10;Otherwise, create a password (8-20 characters).&#10;Password must contain a lowercase letter (a-z).&#10;Password must conatin an uppercase letter (A-Z).&#10;Password must contain a number (0-9).&#10;Password must contain a special character (!@#$%^&*()-+).&#10;Password must not contain any whitespace character.">
		<input type="submit" value="Create Customer Rep. Account" title="Register a new Customer Representative.">
	</form>
	<form id="reports" class="col" method="post" action="GenerateSalesReports.jsp" autocomplete="off">
		<h3 class="message">Generate Sales Reports</h3>
		<input type="radio" name="reportType" value="Total Earnings" placeholder="Total Earnings" checked>
		<label>Total Earnings</label><br>
		<input type="radio" name="reportType" value="Earnings per Item">
		<label>Earnings per Item</label><br>
		<input type="radio" name="reportType" value="Earnings per Item Type">
		<label>Earnings per Item Type</label><br>
		<input type="radio" name="reportType" value="Earnings per End-User">
		<label>Earnings per End-User</label><br>
		<input type="radio" name="reportType" value="Best-selling Items">
		<label>Best-selling Items</label><br>
		<input type="radio" name="reportType" value="Best Buyers">
		<label>Best Buyers</label><br>
		<input type="submit" value="Generate Sales Report" title="Generate Sales Report.">
	</form>    
	<form method="post" action="Logout.jsp">
    	<input type="submit" value="Logout"/>
	</form>
</body>
</html>