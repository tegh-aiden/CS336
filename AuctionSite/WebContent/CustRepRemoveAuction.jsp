<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
	<script src="https://code.jquery.com/jquery-1.10.2.js"></script>
	<link rel="stylesheet" href="stylesAuctionSite.css">
<title>Remove an Auction</title>
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
	
	<form method="post" action="CustRepDeleteAuction.jsp">
		<label>Auction ID: </label>
			<input type="number" name="auction_id">
		
		<input type="submit" value="Remove">
	
	</form>

</body>
</html>