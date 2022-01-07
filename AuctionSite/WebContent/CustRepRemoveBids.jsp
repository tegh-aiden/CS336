<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
	<script src="https://code.jquery.com/jquery-1.10.2.js"></script>
	<link rel="stylesheet" href="stylesAuctionSite.css">
<title>Remove a Bid</title>
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
	
	<form method="post" action="CustRepDeleteBid.jsp">
		<label>Bidder's Username: </label>
			<input type="text" name="bidder_uname" max="30">
		<label>Auction ID: </label>
			<input type="number" name="auction_id">
		<label>Bid value: </label>
			<input type="number" name="bid_value">
			
		<input type="submit" value="Remove">
			
	
	</form>

</body>
</html>