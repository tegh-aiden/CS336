<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1;">
	<link rel="stylesheet" href="stylesAuctionSite.css">
	<title>Auction Site - Login Page</title>	
</head>
<body>
	<% 
	if (session != null && session.getAttribute("username") != null) {
		response.sendRedirect("HomePageRedirect.jsp");
		return;
	}
	%>	
	<h1 class="message">Welcome to AuctionSite</h1>
    <h2 class="message">Log in to your Account or Create a new Account</h2>
    <% 
	Integer errorCode = (Integer)session.getAttribute("errorCode");
	if (errorCode != null) { 
		if (errorCode.equals(-1)) {
	%>
	<h3 class="message error">Oops! Login failed - Incorrect Username or Password!</h3>
	<%	
		}
		else if (errorCode.equals(-2)) {
	%>
	<h3 class="message error">Oops! Registration failed - Username already in use! Please choose another Username.</h3>
	<%	
		}
		session.removeAttribute("errorCode");
	}
	%>	
   	<form  id="login" class="col" method="post" action="LoginVerification.jsp" autocomplete="off">
		<h3 class="message">Login using Your Credentials</h3>
		<input type="text" name="username" title="Enter your username" placeholder="Username" required>
		<input type="password" name="password" title="Enter your password" placeholder="Password" required>
		<input type="submit" value="Login" title="Log in to your account.">
	</form>    
	<form id="register" class="col" method="post" action="RegistrationVerification.jsp" autocomplete="off">
		<h3 class="message">Register a new User Account</h3>
		<input type="text" name="first_name" maxlength="20" placeholder="First Name" title="Enter your first name.&#10;First Name must contain only letters (A-Z and a-z)." pattern="^[A-Za-z]+$" required>
		<input type="text" name="last_name" maxlength="20" placeholder="Last Name" title="Enter your last name.&#10;Last Name must contain only letters (A-Z and a-z)." pattern="^[A-Za-z]+$" required>
		<input type="email" name="email" maxlength="50" placeholder="Email Address" title="Enter your email address." required>
		<input type="text" name="username" minlength="6" maxlength="30" placeholder="Username" pattern="^(?!CustomerRep[0-9]*)(?!.*[\._\-][\._\-]+)(?![\._\-].*)(?!.*[\._\-]$)(?!.*\s)[a-zA-Z0-9\._\-]{6,}$" title="Create your username (6-30 characters).&#10;Username can only include letters, numbers, full stops, underscores or dashes.&#10;Username can't begin or end with a full stop, an underscore or a dash.&#10;Username can't have consecutive fullstops, underscores or dashes.&#10;Username must not contain any whitespace character.&#10;Username can't be like 'CustomerRep' optionally followed by a number." required>
		<input type="password" name="password" minlength="8" maxlength="20" placeholder="Password" pattern="^(?!.*\s)(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*\(\-\+]).{8,}$" title="Create your password (8-20 characters).&#10;Password must contain a lowercase letter (a-z).&#10;Password must conatin an uppercase letter (A-Z).&#10;Password must contain a number (0-9).&#10;Password must contain a special character (!@#$%^&*()-+).&#10;Password must not contain any whitespace character." required>
		<input type="submit" value="Create Account" title="Register your account.">
	</form>    
</body>
</html>