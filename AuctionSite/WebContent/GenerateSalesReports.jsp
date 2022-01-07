<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<%
	if (session == null || session.getAttribute("username") == null) {
		response.sendRedirect("LoginRegistration.jsp");
		return;
	}
	else if (!"admin".equals(session.getAttribute("role"))){
		response.sendRedirect("HomePageRedirect.jsp");
		return;
	}
	
	try {

		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		PreparedStatement ps;
		ResultSet rs;
	
		String reportType = request.getParameter("reportType");
		String title = "";
		String select = "SELECT SUM(a.price) AS total_sale, COUNT(a.price) AS total_num_sold FROM AuctionSellsBuys AS a WHERE a.closing_date_time <= CURRENT_TIMESTAMP AND a.buyer_login_id IS NOT NULL AND a.price >= a.secret_minimum_price";
		ps = con.prepareStatement(select);
		rs = ps.executeQuery();
		
		long totalSale = 0;
		int totalNumSold = 0;
		if (rs.next()) {
			totalSale = rs.getInt("total_sale");
			totalNumSold = rs.getInt("total_num_sold");
		}		
		
		if ("Total Earnings".equals(reportType)) {
			select = "SELECT a.auction_id AS `Auction ID`, a.price AS `Earning` FROM AuctionSellsBuys AS a WHERE a.closing_date_time <= CURRENT_TIMESTAMP AND a.buyer_login_id IS NOT NULL AND a.price >= a.secret_minimum_price ORDER BY `Auction ID`";
		}
		else if ("Earnings per Item".equals(reportType)) {
			select = "SELECT a.item_id AS `Item ID`, SUM(a.price) AS `Earnings`, COUNT(a.price) AS `Quantity Sold` FROM AuctionSellsBuys AS a WHERE a.closing_date_time <= CURRENT_TIMESTAMP AND a.buyer_login_id IS NOT NULL AND a.price >= a.secret_minimum_price GROUP BY a.item_id ORDER BY `Item ID`";
		}
		else if ("Earnings per Item Type".equals(reportType)) {
			select = "SELECT i.category AS `Item Category`, SUM(a.price) AS `Earnings`, COUNT(a.price) AS `Number of Items Sold` FROM AuctionSellsBuys AS a, Apparel AS i WHERE a.item_id = i.item_id AND a.closing_date_time <= CURRENT_TIMESTAMP AND a.buyer_login_id IS NOT NULL AND a.price >= a.secret_minimum_price GROUP BY i.category ORDER BY `Item Category`";
		}
		else if ("Earnings per End-User".equals(reportType)) {
			select = "SELECT a.seller_login_id AS `Seller`, SUM(a.price) AS `Earnings`, COUNT(a.price) AS `Number of Items Sold` FROM AuctionSellsBuys AS a WHERE a.closing_date_time <= CURRENT_TIMESTAMP AND a.buyer_login_id IS NOT NULL AND a.price >= a.secret_minimum_price AND a.seller_login_id IS NOT NULL GROUP BY a.seller_login_id ORDER BY `Seller`";
		}
		else if ("Best-selling Items".equals(reportType)) {
			select = "SELECT a.item_id AS `Item ID`, SUM(a.price) AS `Net Purchases of Item`, COUNT(a.price) AS `Quantity Purchased` FROM AuctionSellsBuys AS a WHERE a.closing_date_time <= CURRENT_TIMESTAMP AND a.buyer_login_id IS NOT NULL AND a.price >= a.secret_minimum_price GROUP BY a.item_id ORDER BY `Quantity Purchased` DESC, `Net Purchases of Item` DESC, `Item ID` ASC";
		}
		else if ("Best Buyers".equals(reportType)){
			select = "SELECT a.buyer_login_id AS `Buyer`, SUM(a.price) AS `Net Expenditure`, COUNT(a.price) AS `Number of Items Purchased` FROM AuctionSellsBuys AS a WHERE a.closing_date_time <= CURRENT_TIMESTAMP AND a.buyer_login_id IS NOT NULL AND a.price >= a.secret_minimum_price GROUP BY a.buyer_login_id ORDER BY `Number of Items Purchased` DESC, `Net Expenditure` DESC, `Buyer` ASC";
		}
		else {
			response.sendRedirect("HomePageRedirect.jsp");
		}
		
		title = "Sales Report for " + reportType;		
%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<link rel="stylesheet" href="stylesAuctionSite.css">
	<title><%= title %></title>
</head>
<body>
	<h1 class="message"><%= title %></h1>
	<br>
	<% 
		//Create a Prepared SQL statement allowing you to introduce the parameters of the query
		ps = con.prepareStatement(select);

		//Run the query against the DB
		rs = ps.executeQuery();
	%>
	<div class="container">
		<table>
			<tr>
	<%
		ResultSetMetaData rsmd = rs.getMetaData();
		for (int i = 1; i <= rsmd.getColumnCount(); i++) {
	%>
				<th><%= rsmd.getColumnLabel(i) %></th>
	<%
		}
	%>
			</tr>
	<%	
		while(rs.next()) {		
	%>
			<tr>
				<td><%= rs.getString(1) %></td>
				<td><%= rs.getString(2) %></td>
	<%
				if (!reportType.equals("Total Earnings")) {
	%>
				<td><%= rs.getString(3) %></td>
	<%	
				}
	%>
			</tr>
	<%
		}				
	%>
			<tr>
				<td>Total</td>
				<td><%= totalSale %></td>
	<% 
				if (!reportType.equals("Total Earnings")) {
	%>
				<td><%= totalNumSold %></td>
	<%	
				}
	%>
			</tr>
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
	<form method="post" action="HomePageRedirect.jsp">
    	<input type="submit" value="Back To Home Page"/>
	</form>
</body>
</html>