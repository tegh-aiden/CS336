<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
	<script src="https://code.jquery.com/jquery-1.10.2.js"></script>
	<link rel="stylesheet" href="stylesAuctionSite.css">
<title>Edit User Account Information</title>
</head>
<body>
	<!--Navigation bar-->
		<div id="nav-placeholder">
		
		</div>
		
		<script>
		$(function(){
		  $("#nav-placeholder").load("NavCustServ.html");
		});
		</script>
	<!--end of Navigation bar-->
	
	<form method="post" action="CustRepUpdateUserAccountInfo.jsp">
		<label>Username: </label>
			<input name="uname" type="text" max="30">
		<label>Password: </label>
			<input name="password" type="text" max="20">
		<label>First Name: </label>
			<input name="fname" type="text" max="20">
		<label>Last Name: </label>
			<input name="lname" type="text" max="20">
		<label>Email: </label>
			<input name="email" type="email"max="50">			
		<input type="submit" value="Update">
			
	
	</form>

</body>
</html>